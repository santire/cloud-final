import { Recipe } from "../types/Recipe";
import { apiClient } from "./client";

const BASE_PATH = "/recipes";

interface RecipeDao {
  id: number;
  title: string;
  body: string;
  image_full_size_url: string;
  thumbnail_url: string;
  owner_id: string;
  likes: number;
  liked_by_user: boolean;
}

const parseRecipe = (recipe: RecipeDao): Recipe => {
  return {
    id: recipe.id,
    title: recipe.title,
    body: recipe.body,
    imgUrl: recipe.image_full_size_url,
    thumbnailUrl: recipe.thumbnail_url,
    likes: recipe.likes,
    likedByUser: recipe.liked_by_user,
  };
};

export interface RecipeForm {
  title: string;
  username: string;
  body: string;
  image: any;
}

export async function getRecipeById(id: string): Promise<Recipe> {
  const url = `${BASE_PATH}/${id}`;
  const response = await apiClient.get<RecipeDao>(url);
  return parseRecipe(response.data);
}

export async function getRecipes(): Promise<Recipe[]> {
  const url = `${BASE_PATH}`;
  const response = await apiClient.get<RecipeDao[]>(url);
  return response.data.map((r) => parseRecipe(r));
}

export async function createRecipe(data: RecipeForm) {
  const url = `${BASE_PATH}`;
  const response = await apiClient.post(url, data, {
    headers: {
      "Content-Type": "multipart/form-data",
    },
  });

  return response.data;
}

export async function likeRecipe({ recipeId }: { recipeId: string }) {
  const url = `/likes?recipe_id=${recipeId}`;
  const response = await apiClient.post(url, {});
  return response.data;
}

export async function dislikeRecipe({ recipeId }: { recipeId: string }) {
  const url = `/likes?recipe_id=${recipeId}`;
  const response = await apiClient.delete(url);
  return response.data;
}
