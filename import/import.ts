/**
 * Impordiskript — loeb CSV, JSON ja XML failid ning sisestab andmed PostgreSQL-i.
 *
 * Käivitamine:
 *   bun run import/import.ts
 */

import postgres from "postgres";
import { readFileSync } from "fs";
import { resolve } from "path";

const sql = postgres({
  host: process.env.PGHOST || "localhost",
  port: Number(process.env.PGPORT) || 5432,
  database: process.env.PGDATABASE || "arvutiklassid",
  username: process.env.PGUSER || "postgres",
  password: process.env.PGPASSWORD || "postgres",
});

const dir = resolve(import.meta.dir);

// ── CSV parser (lihtne) ────────────────────────────────────────────
function parseCsv(text: string): Record<string, string>[] {
  const lines = text.trim().split("\n");
  const headers = lines[0].split(",");
  return lines.slice(1).map((line) => {
    const values = line.split(",");
    const obj: Record<string, string> = {};
    headers.forEach((h, i) => (obj[h.trim()] = values[i]?.trim() || ""));
    return obj;
  });
}

// ── XML parser (lihtne regex-põhine) ───────────────────────────────
function parseBookingsXml(text: string): Record<string, string>[] {
  const bookings: Record<string, string>[] = [];
  const bookingBlocks = text.match(/<booking>([\s\S]*?)<\/booking>/g) || [];
  for (const block of bookingBlocks) {
    const obj: Record<string, string> = {};
    const tags = block.match(/<(\w+)>(.*?)<\/\1>/g) || [];
    for (const tag of tags) {
      const match = tag.match(/<(\w+)>(.*?)<\/\1>/);
      if (match) obj[match[1]] = match[2];
    }
    bookings.push(obj);
  }
  return bookings;
}

async function main() {
  console.log("=== Import alustatud ===\n");

  // 1. Impordi klassiruumid CSV-st
  console.log("1. Impordib klassiruume (classes.csv)...");
  const classroomsCsv = readFileSync(resolve(dir, "classes.csv"), "utf-8");
  const classrooms = parseCsv(classroomsCsv);
  for (const c of classrooms) {
    await sql`
      INSERT INTO classroom (name, building, capacity, has_projector, description)
      VALUES (${c.name}, ${c.building}, ${Number(c.capacity)}, ${c.has_projector === "true"}, ${c.description})
      ON CONFLICT (name) DO UPDATE SET
        building = EXCLUDED.building,
        capacity = EXCLUDED.capacity,
        has_projector = EXCLUDED.has_projector,
        description = EXCLUDED.description
    `;
  }
  console.log(`   ✓ ${classrooms.length} klassiruumi imporditud\n`);

  // 2. Impordi kasutajad JSON-ist
  console.log("2. Impordib kasutajaid (teachers.json)...");
  const teachersJson = readFileSync(resolve(dir, "teachers.json"), "utf-8");
  const teachers = JSON.parse(teachersJson);
  for (const t of teachers) {
    await sql`
      INSERT INTO user_group (name, email, role)
      VALUES (${t.name}, ${t.email}, ${t.role})
      ON CONFLICT (email) DO UPDATE SET
        name = EXCLUDED.name,
        role = EXCLUDED.role
    `;
  }
  console.log(`   ✓ ${teachers.length} kasutajat imporditud\n`);

  // 3. Impordi broneeringud XML-ist
  console.log("3. Impordib broneeringuid (bookings.xml)...");
  const bookingsXml = readFileSync(resolve(dir, "bookings.xml"), "utf-8");
  const bookings = parseBookingsXml(bookingsXml);

  // Veendu, et tunnitüübid on olemas
  const lessonTypeNames = [...new Set(bookings.map((b) => b.lesson_type))];
  for (const name of lessonTypeNames) {
    await sql`INSERT INTO lesson_type (name) VALUES (${name}) ON CONFLICT (name) DO NOTHING`;
  }

  let importedCount = 0;
  for (const b of bookings) {
    // Otsi seotud ID-d
    const [classroom] = await sql`SELECT id FROM classroom WHERE name = ${b.classroom}`;
    const [user] = await sql`SELECT id FROM user_group WHERE email = ${b.teacher}`;
    const [lt] = await sql`SELECT id FROM lesson_type WHERE name = ${b.lesson_type}`;

    if (!classroom || !user) {
      console.log(`   ⚠ Vahele jäetud: klass="${b.classroom}", kasutaja="${b.teacher}" ei leitud`);
      continue;
    }

    await sql`
      INSERT INTO booking (classroom_id, user_group_id, lesson_type_id, booking_date, start_time, end_time, participants, description)
      VALUES (${classroom.id}, ${user.id}, ${lt?.id || null}, ${b.date}, ${b.start_time}, ${b.end_time}, ${Number(b.participants) || 0}, ${b.description || null})
    `;
    importedCount++;
  }
  console.log(`   ✓ ${importedCount} broneeringut imporditud\n`);

  console.log("=== Import lõpetatud ===");
  await sql.end();
}

main().catch((err) => {
  console.error("Viga importimisel:", err);
  process.exit(1);
});
