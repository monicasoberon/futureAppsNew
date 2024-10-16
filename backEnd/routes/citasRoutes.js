const express = require("express");
const citasController = require("../controllers/citasController");

const router = express.Router();

// Routes
router.get("/", citasController.getCitas);
router.get("/citaByEmail/:email", citasController.getCitasByEmail);
router.post("/", citasController.createCita);

module.exports = router;