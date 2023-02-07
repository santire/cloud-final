import axios from "axios";
import { TokenProvider } from "../utils/TokenProvider";
// import { TokenProvider } from "../utils/TokenProvider";
export const apiClient = axios.create({
  baseURL: process.env.REACT_APP_HOST_API || "http://localhost:3000",
  paramsSerializer: {
    indexes: null,
  },
});

// apiClient.defaults.headers.common["Content-Type"] = "application/json";
// apiClient.defaults.headers.common["Authorization"] = authHeader().Authorization;

function authHeader() {
  const token = TokenProvider.getInstance().getToken();

  if (token) {
    return { Authorization: "Bearer " + token };
  } else {
    return { Authorization: "" };
  }
}
