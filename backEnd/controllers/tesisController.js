const TESIS = require("../schemas/tesisSchema");

exports.getTesis = async (req, res) => {
  try {
    const tesis = await TESIS.find(); // Fetch all tesis documents
    res.status(200).json(tesis); // Return tesis as JSON
  } catch (error) {
    res.status(500).json({ message: error.message }); // Handle any errors
  }
};
