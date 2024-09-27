//chatGPTRoutes.js

const express = require("express");
const chatGPTController = require("../controllers/chatGPTController");

const router = express.Router();

router.post("/", chatGPTController.preguntar);

module.exports = router;
