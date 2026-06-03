const pool = require("../config/db");

const getAllProducts = async (req, res) => {
  try {
    const { categoryId, search, shopId } = req.query;

    let query = `
      SELECT 
        p.product_id,
        p.product_name,
        p.description,
        p.price,
        p.stock,
        p.image_url,
        p.category_id,
        p.shop_id,
        c.category_name,
        s.shop_name
      FROM products p
      LEFT JOIN categories c ON p.category_id = c.category_id
      LEFT JOIN shops s ON p.shop_id = s.shop_id
      WHERE 1=1
    `;

    const values = [];

    if (categoryId) {
      values.push(categoryId);
      query += ` AND p.category_id = $${values.length}`;
    }

    if (search) {
      values.push(`%${search}%`);
      query += ` AND p.product_name ILIKE $${values.length}`;
    }

    if (shopId) {
      values.push(shopId);
      query += ` AND p.shop_id = $${values.length}`;
    }

    query += ` ORDER BY p.product_id DESC`;

    const result = await pool.query(query, values);

    res.status(200).json(result.rows);
  } catch (error) {
    console.error("Get products error:", error);
    res.status(500).json({
      message: "Products could not be fetched.",
      error: error.message,
    });
  }
};

const getProductById = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `
      SELECT 
        p.product_id,
        p.product_name,
        p.description,
        p.price,
        p.stock,
        p.image_url,
        p.category_id,
        p.shop_id,
        c.category_name,
        s.shop_name
      FROM products p
      LEFT JOIN categories c ON p.category_id = c.category_id
      LEFT JOIN shops s ON p.shop_id = s.shop_id
      WHERE p.product_id = $1
      `,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Product not found." });
    }

    res.status(200).json(result.rows[0]);
  } catch (error) {
    console.error("Get product by id error:", error);
    res.status(500).json({
      message: "Product could not be fetched.",
      error: error.message,
    });
  }
};

const createProduct = async (req, res) => {
  try {
    const {
      product_name,
      description,
      price,
      stock,
      image_url,
      category_id,
      shop_id,
    } = req.body;

    if (!product_name || product_name.trim() === "") {
      return res.status(400).json({
        message: "Product name is required.",
      });
    }

    if (price === undefined || Number(price) <= 0) {
      return res.status(400).json({
        message: "Price must be greater than 0.",
      });
    }

    if (stock === undefined || Number(stock) < 0) {
      return res.status(400).json({
        message: "Stock cannot be negative.",
      });
    }

    if (!category_id) {
      return res.status(400).json({
        message: "Category is required.",
      });
    }

    if (!shop_id) {
      return res.status(400).json({
        message: "Shop is required.",
      });
    }

    const result = await pool.query(
      `
      INSERT INTO products 
      (product_name, description, price, stock, image_url, category_id, shop_id)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING *
      `,
      [
        product_name.trim(),
        description || "Admin tarafından eklenen ürün.",
        Number(price),
        Number(stock),
        image_url || "https://images.unsplash.com/photo-1531403009284-440f080d1e12?w=500",
        Number(category_id),
        Number(shop_id),
      ]
    );

    res.status(201).json({
      message: "Product created successfully.",
      product: result.rows[0],
    });
  } catch (error) {
    console.error("Create product error:", error);
    res.status(500).json({
      message: "Product could not be created.",
      error: error.message,
    });
  }
};

const updateProduct = async (req, res) => {
  try {
    const { id } = req.params;

    const {
      product_name,
      description,
      price,
      stock,
      image_url,
      category_id,
      shop_id,
    } = req.body;

    const result = await pool.query(
      `
      UPDATE products
      SET 
        product_name = $1,
        description = $2,
        price = $3,
        stock = $4,
        image_url = $5,
        category_id = $6,
        shop_id = $7,
        updated_at = CURRENT_TIMESTAMP
      WHERE product_id = $8
      RETURNING *
      `,
      [
        product_name,
        description,
        price,
        stock,
        image_url,
        category_id,
        shop_id,
        id,
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Product not found." });
    }

    res.status(200).json(result.rows[0]);
  } catch (error) {
    console.error("Update product error:", error);
    res.status(500).json({
      message: "Product could not be updated.",
      error: error.message,
    });
  }
};

const deleteProduct = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `
      DELETE FROM products
      WHERE product_id = $1
      RETURNING *
      `,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Product not found." });
    }

    res.status(200).json({
      message: "Product deleted successfully.",
      deletedProduct: result.rows[0],
    });
  } catch (error) {
    console.error("Delete product error:", error);
    res.status(500).json({
      message: "Product could not be deleted.",
      error: error.message,
    });
  }
};

module.exports = {
  getAllProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
};