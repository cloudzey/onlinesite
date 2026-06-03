const express = require("express");
const router = express.Router();

const shopAuthMiddleware = require("../middlewares/shopAuthMiddleware");

const {
  shopLogin,
  getShopProfile,
} = require("../controllers/shopAuthController");

router.post("/login", shopLogin);
router.get("/profile", shopAuthMiddleware, getShopProfile);

module.exports = router;