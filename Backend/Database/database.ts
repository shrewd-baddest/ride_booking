import { Pool } from "pg";
import dotenv from "dotenv";

dotenv.config();

const connectionString = process.env.DATABASE_URL;
const isRemoteDatabase = connectionString?.includes("neon.tech") || connectionString?.includes("pooler");

const db = new Pool({
  connectionString,
  ssl: isRemoteDatabase ? { rejectUnauthorized: false } : false,
  max: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 15000,
});

export const testDatabaseConnection = async () => {
  try {
    const result = await db.query("SELECT NOW() AS now");

    console.log("✅ PostgreSQL connected successfully!");
    console.log("Database time:", result.rows[0].now);
  } catch (error) {
    console.error("❌ PostgreSQL connection failed! Check your DATABASE_URL and ensure the database is reachable.");
    console.error(error);
  }
};

export default db;