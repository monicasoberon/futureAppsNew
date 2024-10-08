const express = require("express");
const tesisController = require("../controllers/tesisController"); // Import the tesis controller

const router = express.Router();

router.get("/", tesisController.getTesis); // Route to get all tesis
router.get("/:id", tesisController.getTesisById);

module.exports = router;
