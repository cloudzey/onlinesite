const pool = require("../config/db");

const getAllCategories = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        category_id,
        category_name
      FROM categories
      ORDER BY category_id ASC
    `);

    res.status(200).json(result.rows);
  } catch (error) {
    console.error("Get categories error:", error);

    res.status(500).json({
      message: "Categories could not be fetched.",
      error: error.message,
    });
  }
};

module.exports = {
  getAllCategories,
};