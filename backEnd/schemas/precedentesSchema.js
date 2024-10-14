
const mongoose = require("mongoose");

const precedentesSchema = new mongoose.Schema(
  {
    "Registro digital": { type: String, required: true, unique: true },
    precedente: { type: String, required: true },
    notas: { type: String, required: true },
    promovente: { type: String, required: true },
  },
  {
    collection: "sentencias",
  }
);

module.exports = mongoose.model("PRECEDENTES", precedentesSchema);
