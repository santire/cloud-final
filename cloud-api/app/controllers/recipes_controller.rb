class RecipesController < ApplicationController
  authorizer "main#my_cognito", only: %w[create delete]

  def index
    render json: Recipe.all.map do |r|
      {
        id: r.id,
        title: r.title,
        contenido: r.body,
        image_full_size_url: r.image,
        thumbnail_url: r.image,
        owner_id: r.user_id,
        likes: 0,
        liked_by_user: Like.exists?(recipe: r, user: current_user)
      }
    end
  end

  def show
    r = Recipe.find(params[:id])

    render json: {
      id: r.id,
      title: r.title,
      contenido: r.body,
      image_full_size_url: r.image,
      thumbnail_url: r.image,
      owner_id: r.user_id,
      likes: Like.where(recipe: r).count,
      liked_by_user: Like.exists?(recipe: r, user: current_user)
    }
  end

  def create
    image = params[:image]
    bucket_name = 'cloud-api-raw-images'
    key = "#{current_user.instagram_username}/#{image.original_filename}"
    image_file = image.tempfile
    object = Aws::S3::Object.new(bucket_name, key)
    object.upload_file(image_file.path)

    recipe = Recipe.create!(
      image: object.public_url,
      title: params[:title],
      body:  params[:body],
      user:  current_user
    )

    render status: 201, json: recipe.attributes.to_h.merge(liked_by_user: false)
  end

  def delete
    Recipe.find(params[:id]).destroy

    render status: 204
  end

  def like
    recipe = Recipe.find(params[:id])

    like = Like.create(recipe: recipe, user: current_user)

    render status: 201, json: { recipe_id: recipe.id, user_id: current_user.id }
  end

  def unlike
    Like.find_by(recipe_id: params[:id], user_id: current_user.id).destroy

    render status: 204
  end
end
