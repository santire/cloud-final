import {
  Header as MantineHeader,
  Group,
  Button,
  Divider,
  Box,
  Burger,
  Drawer,
  ScrollArea,
  Anchor,
} from "@mantine/core";
import { useDisclosure } from "@mantine/hooks";
import { Link, useNavigate } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";
import { TokenProvider } from "../../utils/TokenProvider";
import { ThemeToggle } from "../ThemeToggle/ThemeToggle";
import useStyles from "./Header.styles";

export function Header() {
  const [drawerOpened, { toggle: toggleDrawer, close: closeDrawer }] =
    useDisclosure(false);
  const { classes, theme } = useStyles();
  const { authed } = useAuth();
  const navigate = useNavigate();
  const tokenProvider = TokenProvider.getInstance();

  const LOGIN_URL =
    import.meta.env.VITE_LOGIN_ENDPOINT ||
    "localhost:3000";

  const logout = () => {
    tokenProvider.setToken("");
    navigate("/");
  };

  return (
    <Box pb={20}>
      <MantineHeader height={60} px="md">
        <Group position="apart" sx={{ height: "100%" }}>
          <Group
            sx={{ height: "100%" }}
            spacing={0}
            className={classes.hiddenMobile}
          >
            <Link to="/" className={classes.link}>
              Inicio
            </Link>
            {authed ? (
              <Link to="/upload" className={classes.link}>
                Subir una receta
              </Link>
            ) : null}
          </Group>

          <Group className={classes.hiddenMobile}>
            <ThemeToggle />
            {authed ? (
              <Button variant="default" onClick={() => logout()}>
                Logout
              </Button>
            ) : (
              <Anchor href={LOGIN_URL}>
                <Button color="orange">Ingresar</Button>
              </Anchor>
            )}
          </Group>

          <Burger
            opened={drawerOpened}
            onClick={toggleDrawer}
            className={classes.hiddenDesktop}
          />
        </Group>
      </MantineHeader>

      <Drawer
        opened={drawerOpened}
        onClose={closeDrawer}
        size="100%"
        padding="md"
        title="Navigation"
        className={classes.hiddenDesktop}
        zIndex={1000000}
      >
        <ScrollArea sx={{ height: "calc(100vh - 60px)" }} mx="-md">
          <Divider
            my="sm"
            color={theme.colorScheme === "dark" ? "dark.5" : "gray.1"}
          />

          <Link to="/" className={classes.link}>
            Inicio
          </Link>
          <Link to="/upload" className={classes.link}>
            Subir una receta
          </Link>

          <Divider
            my="sm"
            color={theme.colorScheme === "dark" ? "dark.5" : "gray.1"}
          />

          <Group position="center" grow pb="xl" px="md">
            <ThemeToggle />

            {authed ? (
              <Button variant="default" onClick={() => logout()}>
                Logout
              </Button>
            ) : (
              <Anchor href={LOGIN_URL}>
                <Button color="orange">Ingresar</Button>
              </Anchor>
            )}
          </Group>
        </ScrollArea>
      </Drawer>
    </Box>
  );
}
