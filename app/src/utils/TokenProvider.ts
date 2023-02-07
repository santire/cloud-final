export class TokenProvider {
  private static instance: TokenProvider;
  private token: string;
  private user: string;
  private observers: Array<(isLogged: boolean) => void>;

  static getInstance(): TokenProvider {
    if (!TokenProvider.instance) {
      TokenProvider.instance = new TokenProvider();
    }

    return TokenProvider.instance;
  }
  private constructor() {
    this.token = localStorage.getItem("REACT_TOKEN_AUTH") || "";
    this.user = localStorage.getItem("REACT_AUTH_USER") || "null";
    this.observers = [];
  }
  private getExpirationDate = (jwtToken?: string): number | null => {
    if (!jwtToken) {
      return null;
    }

    try {
      const jwt = JSON.parse(atob(jwtToken.split(".")[1]));
      // multiply by 1000 to convert seconds into milliseconds
      return (jwt && jwt.exp && jwt.exp * 1000) || null;
      // DEBUG: force token validity to x mins
      // let x = 0.15;
      // return (jwt && jwt.exp && jwt.exp * 1000) - (60 - x) * 60 * 1000 || null;
    } catch (e) {
      console.log("Invalid token");
      this.setToken("");
      this.setUser("null");
      return null;
    }
  };

  private isExpired = (exp?: number | null) => {
    if (!exp) {
      return false;
    }
    // console.log(`valid for ${-(Date.now() - exp) / 1000} more seconds`);
    return Date.now() > exp;
  };

  private notify = () => {
    const isLogged = this.isLoggedIn();
    this.observers.forEach((observer) => observer(isLogged));
  };

  isLoggedIn = () => {
    return !!this.token;
  };

  getToken = () => {
    if (!this.token) {
      return "";
    }

    if (this.isExpired(this.getExpirationDate(this.token))) {
      // If a refresh-token were to be made available this could
      // check token validity and refresh if expired
      console.log("Token is expired");
      this.setToken("");
      this.setUser("null");
    }

    return this.token;
  };

  getUser = () => {
    if (!this.user) return "null";
    return this.user;
  };

  setToken = (token: typeof this.token) => {
    if (token) {
      localStorage.setItem("REACT_TOKEN_AUTH", token);
    } else {
      localStorage.removeItem("REACT_TOKEN_AUTH");
    }
    this.token = token;
    this.notify();
  };

  setUser = (user: string) => {
    if (user) {
      localStorage.setItem("REACT_AUTH_USER", user);
    } else {
      localStorage.removeItem("REACT_AUTH_USER");
    }
    this.user = user;
    this.notify();
  };

  subscribe = (observer: (isLogged: boolean) => void) => {
    this.observers.push(observer);
  };

  unsubscribe = (observer: (isLogged: boolean) => void) => {
    this.observers = this.observers.filter(
      (_observer) => _observer !== observer
    );
  };
}
