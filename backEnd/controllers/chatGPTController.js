//chatGPTController.js
const preguntar = require("../schemas/chatGPTSchema");

exports.preguntar = async (req, res) => {
  const { pregunta } = req.body; // Extract 'pregunta' from request body
  if (!pregunta) {
    return res.status(400).json({ message: "No question provided" });
  }

  try {
    const chatResponse = await preguntar.askQuestion(pregunta);
    res.status(200).json({ message: chatResponse });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
