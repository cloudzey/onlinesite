const path = require("path");
const dotenv = require("dotenv");
const { Pool } = require("pg");

const envPath = path.join(__dirname, "../../.env");
dotenv.config({ path: envPath });

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false,
  },
});

module.exports = pool;