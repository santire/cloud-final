import { createContext, useContext, useEffect, useState } from "react";
import { User } from "../types/User";
import { TokenProvider } from "../utils/TokenProvider";

interface AuthValue {
  user: User | null;
  authed: boolean;
}

// Initializing context with default values
const AuthContext = createContext<AuthValue>({
  user: null,
  authed: false,
});

const tokenProvider = TokenProvider.getInstance();

export const useAuth = () => {
  const [authed, setAuthed] = useState(tokenProvider.isLoggedIn());
  const user = JSON.parse(tokenProvider.getUser()) as User | null;

  useEffect(() => {
    const listener = (newIsAuthed: boolean) => {
      setAuthed(newIsAuthed);
    };

    tokenProvider.subscribe(listener);
    return () => {
      tokenProvider.unsubscribe(listener);
    };
  }, []);

  return {
    user,
    authed,
  };
};

type Props = { children: React.ReactNode };
export function AuthProvider({ children }: Props) {
  const auth = useAuth();

  return <AuthContext.Provider value={auth}>{children}</AuthContext.Provider>;
}

export default function AuthConsumer() {
  return useContext(AuthContext);
}
