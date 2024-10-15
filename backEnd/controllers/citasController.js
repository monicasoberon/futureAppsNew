const CITAS = require('../schemas/citasSchema');
const USUARIOS = require("../schemas/usuariosSchema");

const idByEmail = async (email) => {
    try {
        const usuario = await USUARIOS.findOne({ correo: email });
        return usuario ? usuario._id : null;
    } catch (error) {
        throw new Error('Error al buscar el usuario por email');
    }
};

exports.getCitas = async (req, res) => {
    try {
      const citas = await CITAS.find();
      res.status(200).json(citas);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  };

exports.getCitasByEmail = async (req, res) => {
  const { email } = req.params;

  try {
    const id = await idByEmail(email);

    if (!id) {
        return res.status(404).json({ message: 'Usuario no encontrado' });
    }

    const citas = await CITAS.find({             
      $or: [
        { cliente_id: id },
        { abogado_id: id }
    ] });

    console.log(citas);

    res.status(200).json(citas);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};