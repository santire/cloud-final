import boto3
import base64
import json
import jwt
import psycopg2
import os

import base64
from requests_toolbelt.multipart import decoder

from datetime import datetime

DATABASE_URL = os.getenv("DATABASE_URL")
RAW_IMAGES_BUCKET_NAME = os.getenv("RAW_IMAGES_BUCKET_NAME")

connection = psycopg2.connect(DATABASE_URL)
s3 = boto3.client("s3")


def serialize_recipe(
    current_user, recipe_id, title, body, image_url, owner_id, created_at, updated_at
):
    return {
        "id": recipe_id,
        "title": title,
        "body": body,
        "image_full_size_url": image_url,
        "thumbnail_url": image_url,
        "owner_id": owner_id,
        "likes": count_recipe_likes(recipe_id),
        "liked_by_user": recipe_liked_by_user(recipe_id, current_user["id"]),
    }


def get_recipes(event, context):
    current_user = user_from_jwt(event["headers"]["Authorization"])
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM recipes;")

    result = []
    for recipe in cursor:
        serialized_recipe = serialize_recipe(current_user, *recipe)
        result.append(serialized_recipe)

    cursor.close()

    response = {"statusCode": 200, "body": json.dumps(result)}

    return response

    # Use this code if you don't use the http event with the LAMBDA-PROXY
    # integration
    """
    return {
        "message": "Go Serverless v1.0! Your function executed successfully!",
        "event": event
    }
    """


def get_recipe(event, context):
    recipe_id = 10
    current_user = user_from_jwt(event["headers"]["Authorization"])
    cursor = connection.cursor()
    cursor.execute(f"SELECT * FROM recipes WHERE id = {recipe_id};")
    recipe = cursor.fetchone()

    cursor.close()

    serialized_recipe = serialize_recipe(current_user, *recipe)

    response = {"statusCode": 200, "body": json.dumps(serialized_recipe)}

    return response

    # Use this code if you don't use the http event with the LAMBDA-PROXY
    # integration
    """
    return {
        "message": "Go Serverless v1.0! Your function executed successfully!",
        "event": event
    }
    """


def create_recipe(event, context):
    current_user = user_from_jwt(event["headers"]["Authorization"])
    content_type = event["headers"]["Content-Type"]
    postdata = base64.b64decode(event["body"])

    parts = decoder.MultipartDecoder(postdata, content_type).parts

    sql = f"""
        INSERT INTO recipes(title, body, image, user_id, created_at, updated_at)
        VALUES (%s, %s, %s, %s, %s, %s) RETURNING id;
    """
    title = [
        part.text
        for part in parts
        if b'name="title"' in part.headers[b"Content-Disposition"]
    ][0]
    body = [
        part.text
        for part in parts
        if b'name="body"' in part.headers[b"Content-Disposition"]
    ][0]

    import boto3

    image_bytes = [
        part
        for part in parts
        if b'name="image"' in part.headers[b"Content-Disposition"]
    ][0]

    key = "foo.jpeg"
    s3_client = boto3.client("s3")
    s3_client.put_object(
        Body=image_bytes.content,
        Bucket=RAW_IMAGES_BUCKET_NAME,
        Key=key,
        ContentType=image_bytes.headers[b"Content-Type"].decode("utf-8"),
    )

    cursor = connection.cursor()
    cursor.execute(
        sql, (title, body, key, current_user["id"], datetime.now(), datetime.now())
    )
    recipe_id = cursor.fetchone()[0]

    cursor.execute("SELECT * FROM recipes WHERE id = %s LIMIT 1;", (recipe_id,))
    recipe = cursor.fetchone()

    connection.commit()
    result = serialize_recipe(current_user, *recipe)
    response = {"statusCode": 200, "body": json.dumps(list(event.keys()))}

    return response

    # Use this code if you don't use the http event with the LAMBDA-PROXY
    # integration
    """
    return {
        "message": "Go Serverless v1.0! Your function executed successfully!",
        "event": event
    }
    """


def like_recipe(event, context):
    current_user = user_from_jwt(event["headers"]["Authorization"])

    recipe_id = event["queryStringParameters"]["recipe_id"]
    sql = f"""
        INSERT INTO likes(recipe_id, user_id, created_at, updated_at)
        VALUES ({recipe_id}, {current_user["id"]}, %s, %s) RETURNING id;
    """
    cursor = connection.cursor()
    cursor.execute(sql, (datetime.now(), datetime.now()))

    connection.commit()
    cursor.close()

    body = {
        "recipe_id": recipe_id,
        "user_id": current_user["id"],
    }

    response = {"statusCode": 200, "body": json.dumps(body)}

    return response

    # Use this code if you don't use the http event with the LAMBDA-PROXY
    # integration
    """
    return {
        "message": "Go Serverless v1.0! Your function executed successfully!",
        "event": event
    }
    """


def unlike_recipe(event, context):
    current_user = user_from_jwt(event["headers"]["Authorization"])
    recipe_id = event["queryStringParameters"]["recipe_id"]
    sql = f"""
        DELETE FROM likes
        WHERE recipe_id = {recipe_id} AND user_id = {current_user["id"]}
    """

    cursor = connection.cursor()
    cursor.execute(sql)

    connection.commit()

    cursor.close()

    response = {"statusCode": 204, "body": {}}

    return response

    # Use this code if you don't use the http event with the LAMBDA-PROXY
    # integration
    """
    return {
        "message": "Go Serverless v1.0! Your function executed successfully!",
        "event": event
    }
    """


def sign_up(event, context):
    username = event["userName"]
    email = event["request"]["userAttributes"]["email"]
    profile = event["request"]["userAttributes"]["profile"]

    sql = f"""
        INSERT INTO users(username, email, instagram_username, created_at, updated_at)
        VALUES (%s, %s, %s, NOW(), NOW()) RETURNING id;
    """
    cursor = connection.cursor()
    cursor.execute(sql, (username, email, profile))

    connection.commit()

    return event


def select_winner(event, context):
    cursor = connection.cursor()
    cursor.execute(
        f"SELECT user_id FROM likes WHERE created_at > CURRENT_DATE - interval '7 days' GROUP BY 1 ORDER BY 2 DESC LIMIT 1;"
    )
    (winner_id,) = cursor.fetchone()

    cursor.execute(f"SELECT email FROM users WHERE id = {winner_id};")
    winner_email = cursor.fetchone()[0]

    cursor.close()

    send_winner_email(winner_email)


def send_winner_email(winner_email):
    pass


def user_from_jwt(token):
    decoded_token = jwt.decode(token, options={"verify_signature": False})
    username = decoded_token["cognito:username"]

    cursor = connection.cursor()
    cursor.execute(
        f"SELECT id, username, email, instagram_username FROM users WHERE username = '{username}' LIMIT 1;"
    )
    username = cursor.fetchone()

    return {
        "id": username[0],
        "username": username[1],
        "email": username[2],
        "instagram_username": username[3],
    }


def count_recipe_likes(recipe_id):
    cursor = connection.cursor()
    cursor.execute(f"SELECT COUNT(*) FROM likes WHERE recipe_id = {recipe_id} LIMIT 1;")

    return cursor.fetchone()[0]


def recipe_liked_by_user(recipe_id, user_id):
    cursor = connection.cursor()
    cursor.execute(
        f"SELECT COUNT(*) FROM likes WHERE recipe_id = {recipe_id} AND user_id = {user_id};"
    )

    return cursor.fetchone()[0] > 0
