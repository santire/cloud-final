import { createStyles } from "@mantine/core";
export default createStyles((theme) => {
  const BREAKPOINT = theme.fn.smallerThan("sm");

  return {
    wrapper: {
      display: "flex",
      backgroundColor:
        theme.colorScheme === "dark" ? theme.colors.dark[6] : theme.white,
      borderRadius: theme.radius.lg,
      padding: 4,
      border: `1px solid ${
        theme.colorScheme === "dark"
          ? theme.colors.dark[8]
          : theme.colors.gray[2]
      }`,

      [BREAKPOINT]: {
        flexDirection: "column",
      },
    },

    form: {
      boxSizing: "border-box",
      flex: 1,
      padding: theme.spacing.xl,
      paddingLeft: theme.spacing.xl * 2,
      borderLeft: 0,

      [BREAKPOINT]: {
        padding: theme.spacing.md,
        paddingLeft: theme.spacing.md,
      },
    },

    fields: {
      marginTop: -12,
    },

    fieldInput: {
      flex: 1,

      "& + &": {
        marginLeft: theme.spacing.md,

        [BREAKPOINT]: {
          marginLeft: 0,
          marginTop: theme.spacing.md,
        },
      },
    },

    fieldsGroup: {
      display: "flex",

      [BREAKPOINT]: {
        flexDirection: "column",
      },
    },

    sideInfo: {
      display: "flex",
      flexDirection: "column",
      borderRadius: theme.radius.lg,
      borderRight: `1px solid ${theme.colors.gray[8]}`,
      backgroundColor: "#FBAB7E",
      backgroundImage: "linear-gradient(62deg, #FBAB7E 0%, #F7CE68 100%)",
      width: "30%",

      [BREAKPOINT]: {
        display: "none",
      },
    },

    title: {
      fontSize: "2.5rem",
      color:
        theme.colorScheme === "dark"
          ? theme.colors.gray[5]
          : theme.colors.dark[6],
      fontWeight: 700,
    },
    subtitle: {
      fontSize: "2rem",
      color: theme.colors.gray[7],
    },

    control: {
      [BREAKPOINT]: {
        flex: 1,
      },
    },
  };
});
