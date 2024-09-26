const express = require('express');
const citasController = require("../controllers/citasController");

const router = express.Router()

router.get("/", citasController.getCitas)

module.exports = router;
