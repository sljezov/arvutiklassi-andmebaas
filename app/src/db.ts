import postgres from "postgres";

const sql = postgres({
  host: process.env.PGHOST || "localhost",
  port: Number(process.env.PGPORT) || 5432,
  database: process.env.PGDATABASE || "arvutiklassid",
  username: process.env.PGUSER || "postgres",
  password: process.env.PGPASSWORD || "postgres",
});

export default sql;
