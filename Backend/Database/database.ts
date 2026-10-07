import { Client } from "pg";
import dotenv from "dotenv";

dotenv.config();

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  throw new Error("DATABASE_URL is not defined in .env");
}

const db = new Client({
  connectionString,
  ssl: {
    rejectUnauthorized: false,
  },
});

export const testDatabaseConnection = async () => {
  try {
    await db.connect();

    const result = await db.query("SELECT NOW() AS now");

    console.log("✅ PostgreSQL connected successfully!");
    console.log("Database time:", result.rows[0].now);
    console.log("DATABASE_URL exists:", !!process.env.DATABASE_URL);
  } catch (error) {
    console.error("❌ PostgreSQL connection failed!");
    console.error(error);
  }
};

export default db;