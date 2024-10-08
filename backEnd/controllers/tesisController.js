const TESIS = require("../schemas/tesisSchema");

exports.getTesis = async (req, res) => {
  try {
    const tesis = await TESIS.find(); // Fetch all tesis documents
    res.status(200).json(tesis); // Return tesis as JSON
  } catch (error) {
    res.status(500).json({ message: error.message }); // Handle any errors
  }
};

exports.getTesisById = async (req, res) => {
  const { id } = req.params;
  //   console.log(id);

  try {
    const tesis = await TESIS.findOne({ "Registro digital": id });

    if (!tesis) {
      return res.status(404).json({ message: "Tesis not found" });
    }

    res.status(200).json(tesis);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
