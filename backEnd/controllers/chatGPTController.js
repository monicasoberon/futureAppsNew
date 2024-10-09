// chatGPTController.js
const preguntar = require("../schemas/chatGPTSchema");

exports.preguntar = async (req, res) => {
  const { question } = req.body; // Extract 'question' from request body
  if (!question) {
    return res.status(400).json({ message: "No question provided" });
  }
  try {
    const chatResponse = await preguntar.main(question);
    res.status(200).json({ message: chatResponse });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
