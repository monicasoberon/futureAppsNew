const CASOS = require('../schemas/casosSchema');

exports.getCasos = async (req, res) => {
    try {
        const casos = await CASOS.find();
        res.status(200).json(casos);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.getCasoById = async (req, res) => {
    const id = req.params.id;

    try {
        const caso = await CASOS.findById(id);
        if (!caso) {
            return res.status(404).json({ message: 'Caso no encontrado' });
        }
        res.status(200).json(caso);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
}