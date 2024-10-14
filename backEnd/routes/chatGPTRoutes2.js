//chatGPTRoutes.js

const express = require("express");
const chatGPTController2 = require("../controllers/chatGPTController2");

const router = express.Router();

router.post("/", chatGPTController2.preguntar);

module.exports = router;
