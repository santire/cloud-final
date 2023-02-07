import {
  ActionIcon,
  Button,
  Card,
  Flex,
  Group,
  Image,
  Text,
} from "@mantine/core";
import { IconHeart } from "@tabler/icons";
import { useMutation, useQueryClient } from "react-query";
import { dislikeRecipe, likeRecipe } from "../../api/RecipeService";
import { useAuth } from "../../context/AuthContext";
import { Recipe } from "../../types/Recipe";
import useStyles from "./RecipeCard.styles";

interface RecipeCardProps {
  recipe: Recipe;
  likedByUser?: Boolean;
}
export function RecipeCard({ recipe }: RecipeCardProps) {
  const { classes, theme } = useStyles();
  const queryClient = useQueryClient();
  const { user } = useAuth();

  const likeMutation = useMutation(likeRecipe, {
    onSuccess: () => {
      queryClient.invalidateQueries(["recipes"]);
    },

    onError: (error) => {
      console.error(error);
    },
    onSettled: () => {
      queryClient.invalidateQueries("recipes");
    },
  });

  const dislikeMutation = useMutation(dislikeRecipe, {
    onSuccess: () => {
      queryClient.invalidateQueries(["recipes"]);
    },

    onError: (error) => {
      console.error(error);
    },
    onSettled: () => {
      queryClient.invalidateQueries("recipes");
    },
  });

  const handleLike = () => {
    if (!user || !recipe.id) return;

    if (recipe.likes.filter((l) => l == user?.userId).length > 0) {
      dislikeMutation.mutate({
        userId: user.userId ?? "0",
        recipeId: recipe.id,
      });
    } else {
      likeMutation.mutate({
        userId: user.userId ?? "0",
        recipeId: recipe.id,
      });
    }
  };

  return (
    <Card withBorder p="lg" radius="md" className={classes.card}>
      <Card.Section mb="md">
        <Image src={recipe.thumbnailUrl} alt={recipe.title} height={180} />
      </Card.Section>
      <Card.Section mt="xs" className={classes.section}>
        <Text weight={700} className={classes.title} lineClamp={4}>
          {recipe.title}
        </Text>
      </Card.Section>
      <Card.Section className={classes.section}>
        <Text className={classes.text} lineClamp={2}>
          {recipe.ingredients}
        </Text>
      </Card.Section>

      <Flex justify="center" align="center" mt="md">
        <Button
          color="orange"
          variant="outline"
          size="md"
          fullWidth
          // onClick={() => navigate(`/restaurants/${id}`)}
        >
          Ver Más
        </Button>
      </Flex>

      <Card.Section className={classes.footer}>
        <Group position="apart">
          <Text size="xs" color="dimmed">
            Le gusta a {recipe.likes.length} usuarios
          </Text>
          <Group spacing={0}>
            <ActionIcon onClick={handleLike}>
              <IconHeart
                size={18}
                color={theme.colors.red[6]}
                stroke={1.5}
                fill={
                  recipe.likes.filter((l) => l == user?.userId).length > 0
                    ? theme.colors.red[6]
                    : "none"
                }
              />
            </ActionIcon>
          </Group>
        </Group>
      </Card.Section>
    </Card>
  );
}
