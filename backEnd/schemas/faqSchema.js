const mongoose = require('mongoose');

const faqSchema = new mongoose.Schema({
    pregunta: { type: String, required: true },
    respuesta: { type: String, required: true },
}, {
    collection: 'faq'
});
  
module.exports = mongoose.model('FAQ', faqSchema);
