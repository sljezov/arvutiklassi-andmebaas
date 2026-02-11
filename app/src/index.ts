import { Hono } from "hono";
import bookings from "./routes/bookings";
import classrooms from "./routes/classrooms";
import stats from "./routes/stats";

const app = new Hono();

// Marsruudid
app.route("/", bookings);
app.route("/", classrooms);
app.route("/", stats);

console.log("Server käivitatud: http://localhost:3000");

export default {
  port: 3000,
  fetch: app.fetch,
};
