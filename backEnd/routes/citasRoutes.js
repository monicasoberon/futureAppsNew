const express = require("express");
const citasController = require("../controllers/citasController");

const router = express.Router();

// Routes
router.get("/", citasController.getCitas);
router.get("/citaByEmail/:email", citasController.getCitasByEmail);
router.post("/", citasController.createCita);
router.get("/lawyers/:lawyerId/availability", citasController.getBookedTimes);  // Make sure this route points correctly

module.exports = router;