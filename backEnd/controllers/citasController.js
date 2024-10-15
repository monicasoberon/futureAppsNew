const CITAS = require("../schemas/citasSchema");

exports.getCitas = async (req, res) => {
  try {
    const citas = await CITAS.find();
    res.status(200).json(citas);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getCitasByEmail = async (req, res) => {
  const { email } = req.params;
  try {
    const citas = await CITAS.find({ cliente_id: email });
    res.status(200).json(citas);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.createCita = async (req, res) => {
  const { cliente_id, abogado_id, hora } = req.body;

  if (!cliente_id || !abogado_id || !hora) {
    return res.status(400).json({
      message: "Missing required fields: cliente_id, abogado_id, and hora",
    });
  }

  const newCita = new CITAS({
    cliente_id,
    abogado_id,
    hora,
  });

  try {
    const savedCita = await newCita.save();
    res.status(201).json(savedCita);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error creating appointment", error: error.message });
  }
};
