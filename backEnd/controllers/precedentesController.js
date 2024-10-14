const PRECEDENTES = require("../schemas/precedentesSchema");
const mongoose = require("mongoose");


exports.getPrecedentes = async (req, res) => {
  try {
    const precedentes = await PRECEDENTES.find(); // Fetch all precedentes documents
    res.status(200).json(precedentes); // Return precedentes as JSON
  } catch (error) {
    res.status(500).json({ message: error.message }); // Handle any errors
  }
};

exports.getPrecedentesById = async (req, res) => {
    const { id } = req.params;
    //   console.log(id);
  
    try {
      const precedentes = await PRECEDENTES.findOne({ "Registro digital": id });
  
      if (!precedentes) {
        return res.status(404).json({ message: "Tesis not found" });
      }
  
      res.status(200).json(precedentes);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  };