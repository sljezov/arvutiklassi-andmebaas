/**
 * Ekspordiskript — genereerib koondandmed CSV ja JSON failidesse.
 *
 * Käivitamine:
 *   bun run export/export.ts
 */

import postgres from "postgres";
import { writeFileSync } from "fs";
import { resolve } from "path";

const sql = postgres({
  host: process.env.PGHOST || "localhost",
  port: Number(process.env.PGPORT) || 5432,
  database: process.env.PGDATABASE || "arvutiklassid",
  username: process.env.PGUSER || "postgres",
  password: process.env.PGPASSWORD || "postgres",
});

const dir = resolve(import.meta.dir);

async function main() {
  console.log("=== Eksport alustatud ===\n");

  // 1. Broneeringute koondtabel kuu kaupa → CSV
  console.log("1. Genereerib bookings_summary.csv ...");
  const summary = await sql`
    SELECT
      TO_CHAR(b.booking_date, 'YYYY-MM') AS kuu,
      cr.name AS klass,
      COUNT(*)::int AS broneeringuid,
      ROUND(SUM(EXTRACT(EPOCH FROM (b.end_time - b.start_time)) / 3600)::numeric, 1) AS tunnid_kokku,
      SUM(b.participants)::int AS osalejaid_kokku
    FROM booking b
    JOIN classroom cr ON cr.id = b.classroom_id
    GROUP BY TO_CHAR(b.booking_date, 'YYYY-MM'), cr.name
    ORDER BY kuu, klass
  `;

  const csvHeader = "Kuu,Klass,Broneeringuid,Tunnid kokku,Osalejaid kokku";
  const csvRows = summary
    .map((r: any) => `${r.kuu},${r.klass},${r.broneeringuid},${r.tunnid_kokku},${r.osalejaid_kokku}`)
    .join("\n");
  const csvContent = csvHeader + "\n" + csvRows + "\n";

  writeFileSync(resolve(dir, "bookings_summary.csv"), csvContent);
  console.log(`   ✓ ${summary.length} rida eksporditud\n`);

  // 2. Top 5 enim kasutatud klassid → JSON
  console.log("2. Genereerib top5_classes.json ...");
  const top5 = await sql`
    SELECT
      cr.name AS klass,
      cr.building AS hoone,
      cr.capacity AS mahutavus,
      COUNT(b.id)::int AS broneeringuid,
      ROUND(SUM(EXTRACT(EPOCH FROM (b.end_time - b.start_time)) / 3600)::numeric, 1) AS tunnid_kokku
    FROM classroom cr
    JOIN booking b ON b.classroom_id = cr.id
    GROUP BY cr.id, cr.name, cr.building, cr.capacity
    ORDER BY broneeringuid DESC, tunnid_kokku DESC
    LIMIT 5
  `;

  writeFileSync(resolve(dir, "top5_classes.json"), JSON.stringify(top5, null, 2) + "\n");
  console.log(`   ✓ Top 5 klassid eksporditud\n`);

  console.log("=== Eksport lõpetatud ===");
  await sql.end();
}

main().catch((err) => {
  console.error("Viga eksportimisel:", err);
  process.exit(1);
});
