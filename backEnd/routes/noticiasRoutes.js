const express = require('express');
const noticiasController = require("../controllers/noticiasController");

const router = express.Router()

router.get("/", noticiasController.getNoticias)

module.exports = router;
