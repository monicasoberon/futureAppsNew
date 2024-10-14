const express = require('express');
const casosController = require('../controllers/casosController');

const router = express.Router();

router.get('/', casosController.getCasos);
router.get('/:id', casosController.getCasoById);
//http://localhost:3000/api/casos/66e9c3caa65dfe5e11969a35
router.get('/casosPorUsuario/:id', casosController.casosPorUsuario);
router.post('/crearCaso', casosController.crearCaso);
router.post('/agregarArchivo', casosController.agregarArchivos);
router.put('/cambiarEstatus/:id', casosController.cambiarEstatus);

module.exports = router;