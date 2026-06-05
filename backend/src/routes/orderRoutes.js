const express = require("express");
const router = express.Router();

const authMiddleware = require("../middlewares/authMiddleware");

const {
  createOrder,
  getMyOrders,
  getOrderDetail,
  getAllOrders,
  updateOrderStatus,
} = require("../controllers/orderController");

router.post("/create", authMiddleware, createOrder);
router.get("/", authMiddleware, getMyOrders);

router.get("/admin/all", getAllOrders);

router.get("/:orderId", authMiddleware, getOrderDetail);
router.put("/:orderId/status", updateOrderStatus);

module.exports = router;