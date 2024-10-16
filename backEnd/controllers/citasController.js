const CITAS = require('../schemas/citasSchema');
const USUARIOS = require("../schemas/usuariosSchema");

// Helper function to get user ID by email
const idByEmail = async (email) => {
    try {
        const usuario = await USUARIOS.findOne({ correo: email });
        return usuario ? usuario._id : null;
    } catch (error) {
        throw new Error('Error al buscar el usuario por email');
    }
};

// Get all citas
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
    const id = await idByEmail(email);

    if (!id) {
        return res.status(404).json({ message: 'Usuario no encontrado' });
    }

    // Fetch citas for the user (either as a client or a lawyer)
    const citas = await CITAS.find({
      $or: [
        { cliente_id: id },
        { abogado_id: id }
      ]
    });

    // Format the "hora" field as an ISO 8601 string
    const formattedCitas = citas.map(cita => ({
      ...cita.toObject(),  // Convert Mongoose document to a plain object
      hora: cita.hora.toISOString()  // Convert MongoDB Date to ISO 8601 string
    }));

    res.status(200).json(formattedCitas);  // Send formatted citas
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create a new cita
exports.createCita = async (req, res) => {
  const { cliente_id, abogado_id, hora } = req.body;

  if (!cliente_id || !abogado_id || !hora) {
    return res.status(400).json({ message: "Missing required fields: cliente_id, abogado_id, and hora" });
  }

  try {
    const newCita = new CITAS({ cliente_id, abogado_id, hora });
    const savedCita = await newCita.save();
    res.status(201).json(savedCita);
  } catch (error) {
    res.status(500).json({ message: "Error creating appointment", error: error.message });
  }
};

exports.getBookedTimes = async (req, res) => {
  const { lawyerId } = req.params;
  const { date } = req.query;  // Expected format: "YYYY-MM-DD"

  if (!lawyerId || !date) {
    return res.status(400).json({ message: 'Missing required parameters: lawyerId or date' });
  }

  try {
    const selectedDate = new Date(date);
    
    // Set the start and end of the day (from 9 AM to 5 PM)
    const startDate = new Date(selectedDate);
    startDate.setHours(9, 0, 0, 0);  // Start at 9:00 AM

    const endDate = new Date(selectedDate);
    endDate.setHours(17, 0, 0, 0);  // End at 5:00 PM

    // Fetch all booked appointments for this lawyer on the selected date
    const bookedCitas = await CITAS.find({
      abogado_id: lawyerId,
      hora: { $gte: startDate, $lte: endDate }  // Find citas between 9 AM and 5 PM
    });

    // Return booked times as ISO 8601 strings
    const bookedTimes = bookedCitas.map(cita => cita.hora.toISOString());

    res.status(200).json(bookedTimes);  // Send booked time slots
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};