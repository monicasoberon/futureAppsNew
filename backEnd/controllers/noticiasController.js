const NOTICIAS = require("../schemas/noticiasSchema");

exports.getNoticias =  async (req, res) => {
    try {
        const noticias = await NOTICIAS.find();
        res.status(200).json(noticias);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
