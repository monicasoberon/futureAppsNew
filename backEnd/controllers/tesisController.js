const TESIS = require("../schemas/tesisSchema");
const mongoose = require("mongoose");


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

exports.getFilteredTesis = async (req, res) => {
  const { filter } = req.query;

  if (!filter) {
    return res.status(400).json({ message: "Filter parameter is required" });
  }

  const registroDigitalArray = filter.split(",").map((id) => id.trim());

  try {
    // Directly accessing the futureApps database and the tesis collection
    const tesis = await mongoose.connection.useDb("futureApps").collection("tesis").find({
      "Registro digital": { $in: registroDigitalArray },
    }).toArray();

    if (!tesis.length) {
      return res.status(404).json({ message: "Tesis not found" });
    }

    res.status(200).json(tesis);
  } catch (error) {
    console.error("Error executing query:", error);
    res.status(500).json({ message: error.message });
  }
};