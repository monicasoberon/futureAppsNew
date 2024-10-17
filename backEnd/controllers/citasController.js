const CITAS = require("../schemas/citasSchema");
const USUARIOS = require("../schemas/usuariosSchema");

// Helper function to get user ID by email
const idByEmail = async (email) => {
  try {
    const usuario = await USUARIOS.findOne({ correo: email });
    return usuario ? usuario._id : null;
  } catch (error) {
    throw new Error("Error al buscar el usuario por email");
  }
};

const idByUid = async (uid) => {
  try {
    const usuario = await USUARIOS.findOne({ uid: uid });
    return usuario ? usuario._id : null;
  } catch (error) {
    throw new Error("Error al buscar el usuario por uid");
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
    const id = await idByEmail(email);  // Find user ID by email

    if (!id) {
      return res.status(404).json({ message: "Usuario no encontrado" });
    }

    // Fetch citas for the user (either as a client or a lawyer)
    const citas = await CITAS.find({
      $or: [{ cliente_id: id }, { abogado_id: id }],
    });

    // Format the "hora" field as an ISO 8601 string
    const formattedCitas = citas.map((cita) => ({
      ...cita.toObject(),
      hora: cita.hora.toISOString(),  // Convert MongoDB Date to ISO 8601 string
    }));

    res.status(200).json(formattedCitas);  // Send formatted citas
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.createCita = async (req, res) => {
  const { cliente_id, abogado_id, hora } = req.body;
  
  try {
    // Use idByUid helper function to resolve Firebase UIDs to MongoDB _id
    const clientId = await idByUid(cliente_id);
    if (!clientId) {
      return res.status(404).json({ message: "Cliente no encontrado" });
    }


    console.log(clientId);

    // Create and save new cita with the resolved client and lawyer IDs
    const newCita = new CITAS({
      cliente_id: clientId,  // Resolved MongoDB ID for the client
      abogado_id,  // Resolved MongoDB ID for the lawyer
      hora
    });

    const savedCita = await newCita.save();
    console.log(savedCita);
    res.status(201).json(savedCita);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};