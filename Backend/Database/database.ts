import { Pool } from "pg"
import dotenv from "dotenv"

dotenv.config();

const db = new Pool({
  connectionString: process.env.DATABASE_URL,
});

export const testDatabaseConnection = async () => {
  try {
    const result = await db.query("SELECT NOW()");

    console.log("✅ PostgreSQL connected successfully!");
    console.log("Database time:", result.rows[0].now);
  } catch (error) {
    console.error("❌ PostgreSQL connection failed!");
    console.error(error);
  }
};

export default db;