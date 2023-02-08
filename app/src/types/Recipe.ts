export interface Recipe {
  id?: number;
  title: string;
  body: string;
  likes: number;

  imgUrl?: string;
  thumbnailUrl?: string;
  likedByUser?: boolean;
}
