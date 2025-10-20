import axios from "axios";

export const axiosInstance = axios.create({
  baseURL: import.meta.env.MODE === "development" ? "https://connect-td1o.onrender.com/api" : "/api",
  withCredentials: true,
});
