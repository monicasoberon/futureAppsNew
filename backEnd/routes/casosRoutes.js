const express = require('express');
const casosController = require('../controllers/casosController');

const router = express.Router();

router.get('/', casosController.getCasos);
router.get('/:id', casosController.getCasoById);
//http://localhost:3000/api/casos/66e9c3caa65dfe5e11969a35

module.exports = router;

