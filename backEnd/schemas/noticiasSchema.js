const mongoose = require('mongoose');

const noticiasSchema = new mongoose.Schema({
    titulo: { type: String, required: true },
    tipo: { type: String, required: true },
    enlace: { type: String, required: true },
    descripcion: { type: String, required: true },
    fecha: { type: Date, require: true }
}, {
    collection: 'noticias'
});
  
module.exports = mongoose.model('NOTICIAS', noticiasSchema);
