const CITAS = require('../schemas/citasSchema');

exports.getCitas = async (req, res) => {
    try {
      const citas = await CITAS.find();
      res.status(200).json(citas);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  };
  