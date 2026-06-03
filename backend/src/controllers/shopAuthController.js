const pool = require("../config/db");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const shopLogin = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || email.trim() === "") {
      return res.status(400).json({
        message: "Shop email is required.",
      });
    }

    if (!password || password.trim() === "") {
      return res.status(400).json({
        message: "Shop password is required.",
      });
    }

    const result = await pool.query(
      `
      SELECT 
        shop_id,
        shop_name,
        description,
        email,
        password_hash,
        created_at
      FROM shops
      WHERE email = $1
      `,
      [email.trim()]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({
        message: "Invalid shop email or password.",
      });
    }

    const shop = result.rows[0];

    const isPasswordValid = await bcrypt.compare(
      password,
      shop.password_hash
    );

    if (!isPasswordValid) {
      return res.status(401).json({
        message: "Invalid shop email or password.",
      });
    }

    const token = jwt.sign(
      {
        shop_id: shop.shop_id,
        shop_name: shop.shop_name,
        type: "shop",
      },
      process.env.JWT_SECRET,
      {
        expiresIn: "7d",
      }
    );

    res.status(200).json({
      message: "Shop login successful.",
      token,
      shop: {
        shop_id: shop.shop_id,
        shop_name: shop.shop_name,
        description: shop.description,
        email: shop.email,
        created_at: shop.created_at,
      },
    });
  } catch (error) {
    console.error("Shop login error:", error);

    res.status(500).json({
      message: "Shop login failed.",
      error: error.message,
    });
  }
};

const shopRegister = async (req, res) => {
  try {
    const { shop_name, description, email, password } = req.body;

    if (!shop_name || shop_name.trim() === "") {
      return res.status(400).json({
        message: "Shop name is required.",
      });
    }

    if (!email || email.trim() === "") {
      return res.status(400).json({
        message: "Shop email is required.",
      });
    }

    if (!password || password.trim() === "") {
      return res.status(400).json({
        message: "Shop password is required.",
      });
    }

    if (password.length < 6) {
      return res.status(400).json({
        message: "Password must be at least 6 characters.",
      });
    }

    const existingShop = await pool.query(
      `
      SELECT shop_id
      FROM shops
      WHERE email = $1
      `,
      [email.trim()]
    );

    if (existingShop.rows.length > 0) {
      return res.status(409).json({
        message: "This shop email is already registered.",
      });
    }

    const passwordHash = await bcrypt.hash(password, 10);

    const result = await pool.query(
      `
      INSERT INTO shops
      (shop_name, description, email, password_hash)
      VALUES ($1, $2, $3, $4)
      RETURNING shop_id, shop_name, description, email, created_at
      `,
      [
        shop_name.trim(),
        description || "Yeni mağaza",
        email.trim(),
        passwordHash,
      ]
    );

    const shop = result.rows[0];

    const token = jwt.sign(
      {
        shop_id: shop.shop_id,
        shop_name: shop.shop_name,
        type: "shop",
      },
      process.env.JWT_SECRET,
      {
        expiresIn: "7d",
      }
    );

    res.status(201).json({
      message: "Shop registered successfully.",
      token,
      shop,
    });
  } catch (error) {
    console.error("Shop register error:", error);

    res.status(500).json({
      message: "Shop register failed.",
      error: error.message,
    });
  }
};

const getShopProfile = async (req, res) => {
  try {
    const shopId = req.shop.shop_id;

    const result = await pool.query(
      `
      SELECT
        shop_id,
        shop_name,
        description,
        email,
        created_at
      FROM shops
      WHERE shop_id = $1
      `,
      [shopId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        message: "Shop not found.",
      });
    }

    res.status(200).json(result.rows[0]);
  } catch (error) {
    console.error("Get shop profile error:", error);

    res.status(500).json({
      message: "Shop profile could not be fetched.",
      error: error.message,
    });
  }
};

module.exports = {
  shopRegister,
  shopLogin,
  getShopProfile,
};