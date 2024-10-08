const express = require('express');
const usuariosController = require("../controllers/usuariosController");
const verifyFirebaseToken = require('../middlewares/auth');

const router = express.Router()

router.get("/", usuariosController.getUsuarios);
router.get("/getAllClientes", usuariosController.getClientes);
router.get("/getAllAbogados", usuariosController.getAbogados);
router.get("/userByEmail/:email", usuariosController.getUsuarioByEmail);
router.put("/updateDescriptionAndEspecialidad", usuariosController.updateDescriptionAndEspecialidad);
router.get("/getPicture/:email", usuariosController.getPicture);
router.post("/updatePicture", usuariosController.updatePicture);
router.post('/loginOrRegister', verifyFirebaseToken, usuariosController.loginOrRegister);

module.exports = router;
