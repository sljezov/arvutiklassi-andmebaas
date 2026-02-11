import { Hono } from "hono";
import sql from "../db";
import { statsPage } from "../views/stats";

const app = new Hono();

app.get("/stats", async (c) => {
  const usage = await sql`
    SELECT
      cr.name AS classroom_name,
      'Nädal ' || EXTRACT(WEEK FROM b.booking_date)::int || ' (' || EXTRACT(YEAR FROM b.booking_date)::int || ')' AS week_label,
      ROUND(SUM(EXTRACT(EPOCH FROM (b.end_time - b.start_time)) / 3600)::numeric, 1) AS total_hours,
      COUNT(*)::int AS booking_count
    FROM booking b
    JOIN classroom cr ON cr.id = b.classroom_id
    GROUP BY cr.name, EXTRACT(YEAR FROM b.booking_date), EXTRACT(WEEK FROM b.booking_date)
    ORDER BY cr.name, EXTRACT(YEAR FROM b.booking_date), EXTRACT(WEEK FROM b.booking_date)
  `;
  return c.html(statsPage(usage as any));
});

export default app;
