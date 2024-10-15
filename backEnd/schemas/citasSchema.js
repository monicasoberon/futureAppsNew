const mongoose = require('mongoose');

const citasSchema = new mongoose.Schema({
    cliente_id: { type: String, required: true },
    abogado_id: { type: String, required: true },
    hora: { type: Date, required: true },
},{
    collection: 'citas'
});

module.exports = mongoose.model('CITAS', citasSchema);
