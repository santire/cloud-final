import { Center, Container, Loader, SimpleGrid, Title } from "@mantine/core";
import { useEffect } from "react";
import { useQuery } from "react-query";
import { useLocation, useNavigate } from "react-router-dom";
import { getRecipes } from "../api/RecipeService";
import { RecipeCard } from "../components/RecipeCard/RecipeCard";
import { Recipe } from "../types/Recipe";
import { TokenProvider } from "../utils/TokenProvider";

export function HomePage() {
  const { status, data, error } = useQuery<Recipe[], Error>(
    ["recipes"],
    getRecipes
  );
  const tokenProvider = TokenProvider.getInstance();
  const location = useLocation();
  const navigate = useNavigate();

  useEffect(() => {
    const token = location.hash?.slice(1)?.split("&")[0]?.split("=")[1] ?? null;
    if (token) {
      tokenProvider.setToken(token);
      navigate("/");
    }
  });

  return (
    <Container>
      <Title mb="xl">Recetas</Title>
      <SimpleGrid cols={3} spacing="xl" mb="xl">
        {status == "loading" ? (
          <Center>
            <Loader color="orange" />
          </Center>
        ) : (
          data?.map((r, i) => <RecipeCard key={i} recipe={r} />)
        )}
      </SimpleGrid>
    </Container>
  );
}
