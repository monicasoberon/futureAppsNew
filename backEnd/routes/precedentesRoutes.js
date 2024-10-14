// routes/precedentesRoutes.js
const express = require("express");
const router = express.Router();
const precedentesController = require("../controllers/precedentesController");

router.get("/", precedentesController.getPrecedentes); // Get all precedentes
router.get("/:id", precedentesController.getPrecedentesById); // Get precedentes by ID


module.exports = router;
