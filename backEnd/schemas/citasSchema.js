const mongoose = require('mongoose');

const citasSchema = new mongoose.Schema({
    id: { type: String, required: true },
    cliente_id: { type: String, required: true },
    abogado_id: { type: String, required: true },
    plataforma: { type: String, required: true },
    estado: { type: String, required: true },
    enlace_invitacion: { type: String, required: false },
    horaComienzo: { type: Date, required: true },
    horaFin: { type: Date, required: true },
},{
    collection: 'citas'
});

module.exports = mongoose.model('CITAS', citasSchema);
