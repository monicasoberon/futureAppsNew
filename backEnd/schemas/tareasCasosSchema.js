const mongoose = require('mongoose');

const tareasCasosSchema = new mongoose.Schema({
    abogado_id: { type: String, required: true },
    cliente_id: { type: String, required: true },
    caso_id: { type: String, required: true },
    descripcion: [{ type: Object, required: true }],
}, {
    collection: 'tareasCasos'
});
  
module.exports = mongoose.model('TAREASCASOS', tareasCasosSchema);
