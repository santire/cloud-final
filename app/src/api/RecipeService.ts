import { Recipe } from "../types/Recipe";
import { apiClient } from "./client";

const BASE_PATH = "/recipes";

interface RecipeDao {
  id: string;
  title: string;
  thumbnailUrl: string;
  imgUrl: string;
  ingredients: string;
  instructions: string;
  likes: { id: string; userId: string; recipeId: string }[];
}

export interface RecipeForm {
  title: string;
  username: string;
  ingredients: string;
  instructions: string;
  image: any;
}

export async function getRecipeById(id: string): Promise<Recipe> {
  // const url = `${BASE_PATH}/${id}`;
  const url = `${BASE_PATH}/${id}?_embed=likes`;
  const response = await apiClient.get<RecipeDao>(url);
  return { ...response.data, likes: response.data.likes.map((o) => o.userId) };
}

export async function getRecipes(): Promise<Recipe[]> {
  // const url = `${BASE_PATH}`;
  const url = `${BASE_PATH}?_embed=likes`;
  const response = await apiClient.get<RecipeDao[]>(url);
  return response.data.map((r) => ({
    ...r,
    likes: r.likes.map((o) => o.userId),
  }));
}

export async function createRecipe(data: RecipeForm) {
  const url = `${BASE_PATH}`;
  const imageResponse = await apiClient.post(
    "https://api.imgbb.com/1/upload?key=b780b0f2b6104225622775592d907ae9",
    {
      image: data.image,
    },
    {
      headers: {
        "content-type": "multipart/form-data",
      },
    }
  );
  console.log(imageResponse);

  const { image, ...noImgData } = data;

  const response = await apiClient.post(url, {
    ...noImgData,
    thumbnailUrl: imageResponse.data.data.display_url,
  });

  return response.data;
}

export async function likeRecipe({
  userId,
  recipeId,
}: {
  userId: string;
  recipeId: string;
}) {
  // const url = `${BASE_PATH}/recipeId/like`;
  const url = "/likes";
  const data = {
    userId: userId,
    recipeId: recipeId,
  };
  const response = await apiClient.post(url, data);

  return response.data;
}

export async function dislikeRecipe({
  userId,
  recipeId,
}: {
  userId: string;
  recipeId: string;
}) {
  // const url = `${BASE_PATH}/recipeId/like`;
  const url = `${BASE_PATH}/${recipeId}?_embed=likes`;
  const getResponse = await apiClient.get<RecipeDao>(url);
  const resp = [];

  for (let value of getResponse.data.likes) {
    if (value.userId == userId) {
      console.log(value);
      const response = await apiClient.delete(`/likes/${value.id}`);
      resp.push(response.data);
    }
  }

  return resp;
}
