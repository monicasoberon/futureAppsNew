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
};

exports.crearCaso = async (req, res) => {
    const { cliente_id, abogado_asignado, detalles, nombre } = req.body;

    try {
        const nuevoCaso = new CASOS({
            cliente_id,
            abogado_asignado,
            estado: "abierto",
            detalles,
            nombre
        });

        const casoCreado = await nuevoCaso.save();

        return res.status(201).json({ message: 'Caso creado', caso: casoCreado });

    } catch (error) {
        res.status(500).json({message: "Error al crear caso " + error});
    }
};

exports.agregarArchivos = async (req, res) => {
    const id = req.params.id;
    
    try {
        const caso = await CASOS.findById(id);
        if (!caso) {
            return res.status(404).json({ message: 'Caso no encontrado' });
        }

        // Aquí agregarías la lógica para manejar los archivos que recibes (usualmente con multer)
        // Supongamos que req.files contiene los archivos subidos
        const archivos = req.files;
        caso.archivos = archivos; // Aquí puedes personalizar cómo agregar los archivos al caso

        await caso.save();
        res.status(200).json({ message: 'Archivos agregados al caso', caso });

    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.cambiarEstatus = async (req, res) => {
    const id = req.params.id;
    const { nuevoEstatus } = req.body;

    try {
        const caso = await CASOS.findById(id);
        if (!caso) {
            return res.status(404).json({ message: 'Caso no encontrado' });
        }

        caso.estado = nuevoEstatus;

        await caso.save();
        res.status(200).json({ message: 'Estatus del caso actualizado', caso });

    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.casosPorUsuario = async (req, res) => {
    const id = req.params.id;

    try {
        const casos = await CASOS.find({
            $or: [
                { cliente_id: id },
                { abogado_asignado: id }
            ]
        });

        if (casos.length === 0) {
            return res.status(404).json({ message: 'Casos no encontrados para este usuario' });
        }

        res.status(200).json(casos);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};