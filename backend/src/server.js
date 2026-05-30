require("dotenv").config();

const express = require("express");
const cors = require("cors");

const pool = require("./config/db");
const productRoutes = require("./routes/productRoutes");
const categoryRoutes = require("./routes/categoryRoutes");
const authRoutes = require("./routes/authRoutes");
const cartRoutes = require("./routes/cartRoutes");
const orderRoutes = require("./routes/orderRoutes");

const app = express();

app.use(cors({
  origin: "*",
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
}));

app.use(express.json());

app.use("/api/products", productRoutes);
app.use("/api/categories", categoryRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/cart", cartRoutes);
app.use("/api/orders", orderRoutes);

app.get("/", (req, res) => {
  res.send("E-commerce backend çalışıyor.");
});

app.get("/db-test", async (req, res) => {
  try {
    const result = await pool.query("SELECT NOW()");

    res.json({
      message: "Supabase PostgreSQL connection successful.",
      time: result.rows[0],
    });
  } catch (error) {
    console.error("DB connection error full object:", error);

    res.status(500).json({
      message: "Supabase PostgreSQL connection failed.",
      errorName: error.name,
      errorMessage: error.message,
      errorCode: error.code,
      errorStack: error.stack,
    });
  }
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server ${PORT} portunda çalışıyor.`);
});
