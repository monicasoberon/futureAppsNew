const mongoose = require("mongoose");

const tesisSchema = new mongoose.Schema(
  {
    registro_digital: { type: String, required: true, unique: true },
    tesis: { type: String, required: true },
    rubro: { type: String, required: true },
    localizacion: { type: String, required: true },
  },
  {
    collection: "tesis",
  }
);

module.exports = mongoose.model("TESIS", tesisSchema);
