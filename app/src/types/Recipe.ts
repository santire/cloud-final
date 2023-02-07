export interface Recipe {
  id?: string;
  title: string;

  imgUrl?: string;
  thumbnailUrl?: string;

  ingredients: string;
  instructions: string;

  // likes: number;
  likes: string[];
}
