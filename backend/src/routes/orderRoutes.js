const express = require("express");
const router = express.Router();

const authMiddleware = require("../middlewares/authMiddleware");

const {
  createOrder,
  getMyOrders,
  getOrderDetail,
} = require("../controllers/orderController");

router.post("/create", authMiddleware, createOrder);
router.get("/", authMiddleware, getMyOrders);
router.get("/:orderId", authMiddleware, getOrderDetail);

module.exports = router;