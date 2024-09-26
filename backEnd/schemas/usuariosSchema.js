const mongoose = require('mongoose');

const usuariosSchema = new mongoose.Schema({
    tipo: { type: String, required: true },
    id: { type: String, required: true },
    nombre: { type: String, required: true },
    correo: { type: String, required: true },
    especialidad: { type: String, required: false },
    descripcion: { type: String, required: false},
    caso_id: [{ type: String, required: false }],
    foto: { type: String, required: false }
},{
    collection: 'usuarios'
});

module.exports = mongoose.model('USUARIOS', usuariosSchema);
