const pool = require("../config/db");

const getOrCreateCart = async (userId) => {
  const existingCart = await pool.query(
    "SELECT * FROM cart WHERE user_id = $1",
    [userId]
  );

  if (existingCart.rows.length > 0) {
    return existingCart.rows[0];
  }

  const newCart = await pool.query(
    `
    INSERT INTO cart (user_id)
    VALUES ($1)
    RETURNING *
    `,
    [userId]
  );

  return newCart.rows[0];
};

const getCart = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const cart = await getOrCreateCart(userId);

    const result = await pool.query(
      `
      SELECT 
        ci.cart_item_id,
        ci.cart_id,
        ci.product_id,
        ci.quantity,
        p.product_name,
        p.description,
        p.price,
        p.stock,
        p.image_url,
        (p.price * ci.quantity) AS total_price
      FROM cart_items ci
      JOIN products p ON ci.product_id = p.product_id
      WHERE ci.cart_id = $1
      ORDER BY ci.cart_item_id ASC
      `,
      [cart.cart_id]
    );

    res.status(200).json({
      cart_id: cart.cart_id,
      user_id: userId,
      items: result.rows,
    });
  } catch (error) {
    console.error("Get cart error:", error);

    res.status(500).json({
      message: "Cart could not be fetched.",
      error: error.message,
    });
  }
};

const addToCart = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const { product_id, quantity } = req.body;

    if (!product_id) {
      return res.status(400).json({
        message: "product_id is required.",
      });
    }

    const itemQuantity = quantity || 1;

    if (itemQuantity <= 0) {
      return res.status(400).json({
        message: "Quantity must be greater than 0.",
      });
    }

    const productResult = await pool.query(
      "SELECT * FROM products WHERE product_id = $1",
      [product_id]
    );

    if (productResult.rows.length === 0) {
      return res.status(404).json({
        message: "Product not found.",
      });
    }

    const product = productResult.rows[0];

    if (product.stock < itemQuantity) {
      return res.status(400).json({
        message: "Not enough stock.",
      });
    }

    const cart = await getOrCreateCart(userId);

    const result = await pool.query(
      `
      INSERT INTO cart_items (cart_id, product_id, quantity)
      VALUES ($1, $2, $3)
      ON CONFLICT (cart_id, product_id)
      DO UPDATE SET quantity = cart_items.quantity + EXCLUDED.quantity
      RETURNING *
      `,
      [cart.cart_id, product_id, itemQuantity]
    );

    res.status(201).json({
      message: "Product added to cart.",
      item: result.rows[0],
    });
  } catch (error) {
    console.error("Add to cart error:", error);

    res.status(500).json({
      message: "Product could not be added to cart.",
      error: error.message,
    });
  }
};

const updateCartItem = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const { product_id, quantity } = req.body;

    if (!product_id || quantity === undefined) {
      return res.status(400).json({
        message: "product_id and quantity are required.",
      });
    }

    if (quantity <= 0) {
      return res.status(400).json({
        message: "Quantity must be greater than 0.",
      });
    }

    const cart = await getOrCreateCart(userId);

    const result = await pool.query(
      `
      UPDATE cart_items
      SET quantity = $1
      WHERE cart_id = $2 AND product_id = $3
      RETURNING *
      `,
      [quantity, cart.cart_id, product_id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        message: "Product not found in cart.",
      });
    }

    res.status(200).json({
      message: "Cart item updated.",
      item: result.rows[0],
    });
  } catch (error) {
    console.error("Update cart error:", error);

    res.status(500).json({
      message: "Cart item could not be updated.",
      error: error.message,
    });
  }
};

const removeFromCart = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const { productId } = req.params;

    const cart = await getOrCreateCart(userId);

    const result = await pool.query(
      `
      DELETE FROM cart_items
      WHERE cart_id = $1 AND product_id = $2
      RETURNING *
      `,
      [cart.cart_id, productId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        message: "Product not found in cart.",
      });
    }

    res.status(200).json({
      message: "Product removed from cart.",
      removedItem: result.rows[0],
    });
  } catch (error) {
    console.error("Remove from cart error:", error);

    res.status(500).json({
      message: "Product could not be removed from cart.",
      error: error.message,
    });
  }
};

const clearCart = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const cart = await getOrCreateCart(userId);

    await pool.query(
      "DELETE FROM cart_items WHERE cart_id = $1",
      [cart.cart_id]
    );

    res.status(200).json({
      message: "Cart cleared successfully.",
    });
  } catch (error) {
    console.error("Clear cart error:", error);

    res.status(500).json({
      message: "Cart could not be cleared.",
      error: error.message,
    });
  }
};

module.exports = {
  getCart,
  addToCart,
  updateCartItem,
  removeFromCart,
  clearCart,
};