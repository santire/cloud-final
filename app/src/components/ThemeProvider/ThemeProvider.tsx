import {
  ColorScheme,
  ColorSchemeProvider,
  MantineProvider,
} from "@mantine/core";
import { useEffect, useState } from "react";

interface ThemeProviderProps {
  children: React.ReactNode;
}

export function ThemeProvider({ children }: ThemeProviderProps) {
  const [colorScheme, setColorScheme] = useState<ColorScheme>("dark");
  const toggleColorScheme = (value?: ColorScheme) => {
    const nextColorScheme =
      value || (colorScheme === "dark" ? "light" : "dark");
    setColorScheme(nextColorScheme);
    localStorage.setItem("REACT_THEME", nextColorScheme);
  };
  useEffect(() => {
    const theme = localStorage.getItem("REACT_THEME");
    if (theme === "light" || theme === "dark") {
      setColorScheme(theme);
    } else {
      localStorage.setItem("REACT_THEME", "dark");
    }
  }, []);
  return (
    <MantineProvider
      withGlobalStyles
      withNormalizeCSS
      theme={{
        colorScheme: colorScheme,
        fontFamily: "Helvetica, Arial, sans-serif",
      }}
    >
      <ColorSchemeProvider
        colorScheme={colorScheme}
        toggleColorScheme={toggleColorScheme}
      >
        {children}
      </ColorSchemeProvider>
    </MantineProvider>
  );
}
