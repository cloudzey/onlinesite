const express = require("express");
const router = express.Router();

const shopAuthMiddleware = require("../middlewares/shopAuthMiddleware");

const {
  shopRegister,
  shopLogin,
  getShopProfile,
} = require("../controllers/shopAuthController");

router.post("/login", shopLogin);
router.get("/profile", shopAuthMiddleware, getShopProfile);
router.post("/register", shopRegister);
router.post("/login", shopLogin);
router.get("/profile", shopAuthMiddleware, getShopProfile);

module.exports = router;