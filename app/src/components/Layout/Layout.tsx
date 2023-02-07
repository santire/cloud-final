import { createStyles } from "@mantine/core";
import { Outlet } from "react-router-dom";
import { Header } from "../Header/Header";

const useStyles = createStyles(() => ({
  app: {
    display: "flex",
    flexFlow: "column nowrap",
    minHeight: "100vh",
    justifyContent: "center",
  },
  main: {
    flexGrow: 1,
  },
}));

export default function Layout() {
  const { classes } = useStyles();

  return (
    <div className={classes.app}>
      <Header />

      <main className={classes.main}>
        <Outlet />
      </main>
    </div>
  );
}
