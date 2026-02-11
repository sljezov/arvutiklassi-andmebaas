import { Hono } from "hono";
import sql from "../db";
import { classroomListPage } from "../views/classrooms";

const app = new Hono();

app.get("/classrooms", async (c) => {
  const classrooms = await sql`
    SELECT cr.id, cr.name, cr.building, cr.capacity, cr.has_projector, cr.description,
           COUNT(b.id)::int AS booking_count
    FROM classroom cr
    LEFT JOIN booking b ON b.classroom_id = cr.id
    GROUP BY cr.id
    ORDER BY cr.name
  `;
  return c.html(classroomListPage(classrooms as any));
});

export default app;
