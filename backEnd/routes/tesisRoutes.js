// routes/tesisRoutes.js
const express = require("express");
const router = express.Router();
const tesisController = require("../controllers/tesisController");

router.get("/", tesisController.getTesis); // Get all tesis
router.get("/filter", tesisController.getFilteredTesis); // Get filtered tesis
router.get("/:id", tesisController.getTesisById); // Get tesis by ID

module.exports = router;
