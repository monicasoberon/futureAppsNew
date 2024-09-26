const TAREASCASOS = require("../schemas/tareasCasosSchema");

exports.getTareasCasos =  async (req, res) => {
    try {
        const tareasCasos = await TAREASCASOS.find();
        res.status(200).json(tareasCasos);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};