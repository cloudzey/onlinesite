const pool = require("../config/db");

const createOrder = async (req, res) => {
  const client = await pool.connect();

  try {
    const userId = req.user.user_id;

    const {
      address_id,
      addressId,
      city,
      district,
      full_address,
      fullAddress,
      address,
    } = req.body;

    await client.query("BEGIN");

    const cartResult = await client.query(
      "SELECT * FROM cart WHERE user_id = $1",
      [userId]
    );

    if (cartResult.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(400).json({ message: "Cart not found." });
    }

    const cart = cartResult.rows[0];

    const cartItemsResult = await client.query(
      `
      SELECT
        ci.cart_item_id,
        ci.cart_id,
        ci.product_id,
        ci.quantity,
        p.product_name,
        p.price,
        p.stock
      FROM cart_items ci
      JOIN products p ON ci.product_id = p.product_id
      WHERE ci.cart_id = $1
      `,
      [cart.cart_id]
    );

    const cartItems = cartItemsResult.rows;

    if (cartItems.length === 0) {
      await client.query("ROLLBACK");
      return res.status(400).json({ message: "Cart is empty." });
    }

    for (const item of cartItems) {
      if (Number(item.stock) < Number(item.quantity)) {
        await client.query("ROLLBACK");
        return res.status(400).json({
          message: `Not enough stock for product: ${item.product_name}`,
        });
      }
    }

    const totalAmount = cartItems.reduce((total, item) => {
      return total + Number(item.price) * Number(item.quantity);
    }, 0);

    let selectedAddressId = address_id || addressId || null;

    
    if (selectedAddressId) {
      const addressCheckResult = await client.query(
        `
        SELECT address_id
        FROM addresses
        WHERE address_id = $1 AND user_id = $2
        `,
        [selectedAddressId, userId]
      );

      if (addressCheckResult.rows.length === 0) {
        await client.query("ROLLBACK");
        return res.status(400).json({
          message: "Selected address does not belong to this user.",
        });
      }
    }

    if (!selectedAddressId) {
      const finalCity = city?.trim();
      const finalDistrict = district?.trim();
      const finalFullAddress =
        full_address?.trim() ||
        fullAddress?.trim() ||
        address?.trim();

      if (!finalCity || !finalDistrict || !finalFullAddress) {
        await client.query("ROLLBACK");
        return res.status(400).json({
          message: "Address information is required.",
        });
      }

      const newAddressResult = await client.query(
        `
        INSERT INTO addresses (user_id, city, district, full_address)
        VALUES ($1, $2, $3, $4)
        RETURNING address_id
        `,
        [userId, finalCity, finalDistrict, finalFullAddress]
      );

      selectedAddressId = newAddressResult.rows[0].address_id;
    }

    const orderResult = await client.query(
      `
      INSERT INTO orders (user_id, address_id, total_amount, order_status)
      VALUES ($1, $2, $3, $4)
      RETURNING order_id, user_id, address_id, total_amount, order_status, order_date
      `,
      [userId, selectedAddressId, totalAmount, "pending"]
    );

    const order = orderResult.rows[0];

    for (const item of cartItems) {
      await client.query(
        `
        INSERT INTO order_items (order_id, product_id, quantity, price)
        VALUES ($1, $2, $3, $4)
        `,
        [order.order_id, item.product_id, item.quantity, item.price]
      );

      await client.query(
        `
        UPDATE products
        SET stock = stock - $1
        WHERE product_id = $2
        `,
        [item.quantity, item.product_id]
      );
    }

    await client.query("DELETE FROM cart_items WHERE cart_id = $1", [
      cart.cart_id,
    ]);

    await client.query("COMMIT");

    res.status(201).json({
      message: "Order created successfully.",
      order,
      address_id: selectedAddressId,
    });
  } catch (error) {
    await client.query("ROLLBACK");

    console.error("Create order error:", error);

    res.status(500).json({
      message: "Order could not be created.",
      error: error.message,
    });
  } finally {
    client.release();
  }
};

const getMyOrders = async (req, res) => {
  try {
    const userId = req.user.user_id;

    const result = await pool.query(
      `
      SELECT
        order_id,
        user_id,
        address_id,
        total_amount,
        order_status,
        order_date
      FROM orders
      WHERE user_id = $1
      ORDER BY order_date DESC
      `,
      [userId]
    );

    res.status(200).json(result.rows);
  } catch (error) {
    console.error("Get orders error:", error);

    res.status(500).json({
      message: "Orders could not be fetched.",
      error: error.message,
    });
  }
};

const getOrderDetail = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const { orderId } = req.params;

    const orderResult = await pool.query(
      `
      SELECT
        order_id,
        user_id,
        address_id,
        total_amount,
        order_status,
        order_date
      FROM orders
      WHERE order_id = $1 AND user_id = $2
      `,
      [orderId, userId]
    );

    if (orderResult.rows.length === 0) {
      return res.status(404).json({
        message: "Order not found.",
      });
    }

    const itemsResult = await pool.query(
      `
      SELECT
        oi.order_item_id,
        oi.order_id,
        oi.product_id,
        oi.quantity,
        oi.price,
        p.product_name,
        p.description,
        p.image_url
      FROM order_items oi
      JOIN products p ON oi.product_id = p.product_id
      WHERE oi.order_id = $1
      ORDER BY oi.order_item_id ASC
      `,
      [orderId]
    );

    res.status(200).json({
      order: orderResult.rows[0],
      items: itemsResult.rows,
    });
  } catch (error) {
    console.error("Get order detail error:", error);

    res.status(500).json({
      message: "Order detail could not be fetched.",
      error: error.message,
    });
  }
};

const updateOrderStatus = async (req, res) => {
  try {
    const { orderId } = req.params;
    const { order_status } = req.body;

    const allowedStatuses = [
      "pending",
      "preparing",
      "shipped",
      "delivered",
      "cancelled",
    ];

    if (!order_status || !allowedStatuses.includes(order_status)) {
      return res.status(400).json({
        message: "Invalid order status.",
      });
    }

    const result = await pool.query(
      `
      UPDATE orders
      SET order_status = $1
      WHERE order_id = $2
      RETURNING order_id, user_id, address_id, total_amount, order_status, order_date
      `,
      [order_status, orderId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        message: "Order not found.",
      });
    }

    res.status(200).json({
      message: "Order status updated successfully.",
      order: result.rows[0],
    });
  } catch (error) {
    console.error("Update order status error:", error);

    res.status(500).json({
      message: "Order status could not be updated.",
      error: error.message,
    });
  }
};

const getAllOrders = async (req, res) => {
  try {
    const result = await pool.query(
      `
      SELECT
        o.order_id,
        o.user_id,
        u.name,
        u.surname,
        u.email,
        o.address_id,
        a.city,
        a.district,
        a.full_address,
        o.total_amount,
        o.order_status,
        o.order_date
      FROM orders o
      LEFT JOIN users u ON o.user_id = u.user_id
      LEFT JOIN addresses a ON o.address_id = a.address_id
      ORDER BY o.order_date DESC
      `
    );

    res.status(200).json(result.rows);
  } catch (error) {
    console.error("Get all orders error:", error);

    res.status(500).json({
      message: "Orders could not be fetched.",
      error: error.message,
    });
  }
};

module.exports = {
  createOrder,
  getMyOrders,
  getOrderDetail,
  getAllOrders,
  updateOrderStatus,
};