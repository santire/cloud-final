import json
import jwt
import psycopg2
import os

from datetime import datetime

DATABASE_URL = os.getenv("DATABASE_URL")
IMAGE_BUCKET_NAME = os.getenv("IMAGE_BUCKET_NAME")

connection = psycopg2.connect(DATABASE_URL)


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
    current_user = user_from_jwt("asdas")
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM recipes;")

    result = []
    for recipe in cursor:
        serialized_recipe = serialize_recipe(current_user, *recipe)
        result.append(serialized_recipe)

    cursor.close()

    response = {"statusCode": 200, "body": json.dumps(result)}

    print(response)

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
    current_user = user_from_jwt("asdas")
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
    current_user = user_from_jwt("asdas")

    sql = f"""
        INSERT INTO recipes(title, body, image, user_id, created_at, updated_at)
        VALUES (%s, %s, %s, %s, %s, %s) RETURNING id;
    """
    title = "Alfajor"
    body = "Paso 1) asdas Paso 2) nigjewk"
    image = "https://asdasda.com"

    cursor = connection.cursor()
    cursor.execute(
        sql, (title, body, image, current_user["id"], datetime.now(), datetime.now())
    )
    recipe_id = cursor.fetchone()[0]

    cursor.execute("SELECT * FROM recipes WHERE id = %s LIMIT 1;", (recipe_id,))
    recipe = cursor.fetchone()

    body = serialize_recipe(current_user, *recipe)
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


def like_recipe(event, context):
    recipe_id = 10
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
    recipe_id = 10
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
    token = "eyJraWQiOiJJRTdFYzQySWNTMkVVZVFNK0RLYUVYaFBTZUJLRGs3a0k2RWlwUXZzV2g0PSIsImFsZyI6IlJTMjU2In0.eyJhdF9oYXNoIjoiU2s5VjR3RW9ERElkMzA1b1ZTUHBTZyIsInN1YiI6ImZjNmJmZmVkLThjMzQtNDYyNi1hZmFhLWNhMDljMjAyODA1NCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9pa21jTjBFMXkiLCJjb2duaXRvOnVzZXJuYW1lIjoianN1YXJlemIiLCJhdWQiOiI1OG9xdWZ2ZDc3dTE2ZGNmc2poZmtxdDluNiIsImV2ZW50X2lkIjoiYzE0MDE3MTAtMDdhYi00OTNhLWI4ZjItOTFjYzQzMDZlM2IxIiwidG9rZW5fdXNlIjoiaWQiLCJhdXRoX3RpbWUiOjE2NzU3ODI3MzAsImV4cCI6MTY3NTc4NjMzMCwiaWF0IjoxNjc1NzgyNzMwLCJqdGkiOiJkNWQxMzI2ZS1iMjNkLTQ5ODEtODg0MC1jYzE4MDBhMDkwYTciLCJlbWFpbCI6ImpzdWFyZXpib2RAZ21haWwuY29tIn0.XR23ixrGYeg50udK74K8OPf_8WQvE1L223n7lxBKzDz1NN4KYIZbk7w-PyDAg8amNJOg5FiG-tsOFowTYNjAQzdUpSsMpJ8hl9j1NLGdQj6DX6FPSPVc3lZaU7rO6aNX_zMps7yx4X_-QFU4p-zJhMMPnG4nlfcBQszl8I3HLhn_BJpc6Kn2rGV9EanRoi_GV44c0Byt29KC0zmzrt3QGbnZb7kCg3PN15ujTH9T3DI5rfc3VPoLksHXykjoaJWbRCfo5-AlY2-qk9nbyrvAH4ea4KSg97r15thk7Cpg5nnzo5CzcekKwNFWNcHszlSgJz6WkRgL5aNgPRbWPv4i-A"
    decoded_token = jwt.decode(token, options={"verify_signature": False})
    email = decoded_token["email"]

    cursor = connection.cursor()
    cursor.execute(
        f"SELECT id, username, email, instagram_username FROM users WHERE email = '{email}' LIMIT 1;"
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
