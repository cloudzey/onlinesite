const express = require("express");
const router = express.Router();

const authMiddleware = require("../middlewares/authMiddleware");

const {
  addToCart,
  getCart,
  removeCartItem,
  increaseCartItem,
  decreaseCartItem,
} = require("../controllers/cartController");

router.get("/", authMiddleware, getCart);
router.post("/add", authMiddleware, addToCart);

router.patch("/increase/:cartItemId", authMiddleware, increaseCartItem);
router.patch("/decrease/:cartItemId", authMiddleware, decreaseCartItem);
router.delete("/remove/:cartItemId", authMiddleware, removeCartItem);

module.exports = router;