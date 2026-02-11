import { Hono } from "hono";
import sql from "../db";
import { bookingListPage, bookingFormPage } from "../views/bookings";

const app = new Hono();

// Broneeringute nimekiri
app.get("/", async (c) => {
  const bookings = await sql`
    SELECT b.id, b.booking_date::text, b.start_time::text, b.end_time::text,
           b.participants, b.description,
           cr.name AS classroom_name,
           ug.name AS user_group_name,
           lt.name AS lesson_type_name
    FROM booking b
    JOIN classroom cr ON cr.id = b.classroom_id
    JOIN user_group ug ON ug.id = b.user_group_id
    LEFT JOIN lesson_type lt ON lt.id = b.lesson_type_id
    ORDER BY b.booking_date DESC, b.start_time
  `;
  return c.html(bookingListPage(bookings as any));
});

// Uue broneeringu vorm
app.get("/bookings/new", async (c) => {
  const [classrooms, userGroups, lessonTypes] = await Promise.all([
    sql`SELECT id, name FROM classroom ORDER BY name`,
    sql`SELECT id, name FROM user_group ORDER BY name`,
    sql`SELECT id, name FROM lesson_type ORDER BY name`,
  ]);
  return c.html(bookingFormPage(classrooms as any, userGroups as any, lessonTypes as any));
});

// Loo broneering
app.post("/bookings", async (c) => {
  const body = await c.req.parseBody();
  await sql`
    INSERT INTO booking (classroom_id, user_group_id, lesson_type_id, booking_date, start_time, end_time, participants, description)
    VALUES (
      ${Number(body.classroom_id)},
      ${Number(body.user_group_id)},
      ${body.lesson_type_id ? Number(body.lesson_type_id) : null},
      ${body.booking_date as string},
      ${body.start_time as string},
      ${body.end_time as string},
      ${Number(body.participants) || 0},
      ${(body.description as string) || null}
    )
  `;
  return c.redirect("/");
});

// Muutmisvorm
app.get("/bookings/:id/edit", async (c) => {
  const id = Number(c.req.param("id"));
  const [booking] = await sql`
    SELECT id, classroom_id, user_group_id, lesson_type_id,
           booking_date::text, start_time::text, end_time::text,
           participants, description
    FROM booking WHERE id = ${id}
  `;
  if (!booking) return c.text("Broneeringut ei leitud", 404);

  const [classrooms, userGroups, lessonTypes] = await Promise.all([
    sql`SELECT id, name FROM classroom ORDER BY name`,
    sql`SELECT id, name FROM user_group ORDER BY name`,
    sql`SELECT id, name FROM lesson_type ORDER BY name`,
  ]);
  return c.html(
    bookingFormPage(classrooms as any, userGroups as any, lessonTypes as any, booking)
  );
});

// Muuda broneeringut (PUT via _method override)
app.post("/bookings/:id", async (c) => {
  const id = Number(c.req.param("id"));
  const body = await c.req.parseBody();
  await sql`
    UPDATE booking SET
      classroom_id = ${Number(body.classroom_id)},
      user_group_id = ${Number(body.user_group_id)},
      lesson_type_id = ${body.lesson_type_id ? Number(body.lesson_type_id) : null},
      booking_date = ${body.booking_date as string},
      start_time = ${body.start_time as string},
      end_time = ${body.end_time as string},
      participants = ${Number(body.participants) || 0},
      description = ${(body.description as string) || null}
    WHERE id = ${id}
  `;
  return c.redirect("/");
});

// PUT marsruut (HTMX jaoks)
app.put("/bookings/:id", async (c) => {
  const id = Number(c.req.param("id"));
  const body = await c.req.parseBody();
  await sql`
    UPDATE booking SET
      classroom_id = ${Number(body.classroom_id)},
      user_group_id = ${Number(body.user_group_id)},
      lesson_type_id = ${body.lesson_type_id ? Number(body.lesson_type_id) : null},
      booking_date = ${body.booking_date as string},
      start_time = ${body.start_time as string},
      end_time = ${body.end_time as string},
      participants = ${Number(body.participants) || 0},
      description = ${(body.description as string) || null}
    WHERE id = ${id}
  `;
  return c.redirect("/");
});

// Kustuta broneering
app.delete("/bookings/:id", async (c) => {
  const id = Number(c.req.param("id"));
  await sql`DELETE FROM booking WHERE id = ${id}`;
  return c.html("");
});

export default app;
