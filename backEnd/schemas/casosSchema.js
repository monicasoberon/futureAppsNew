const mongoose = require('mongoose');

const casosSchema = new mongoose.Schema({
    id: { type: String, required: true },
    nombre: { type: String, require: true },
    cliente_id: { type: String, required: true },
    abogado_asignado: { type: String, required: true },
    estado: { type: String, required: true },
    detalles: { type: String, required: true },
    archivos: [{ type: String }]

}, {
    collection: 'casos'
});

module.exports = mongoose.model('CASOS', casosSchema);
