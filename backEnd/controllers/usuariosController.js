const USUARIOS = require("../schemas/usuariosSchema");

const idByEmail = async (email) => {
    try {
        const usuario = await USUARIOS.findOne({ correo: email });
        return usuario ? usuario._id : null;
    } catch (error) {
        throw new Error('Error al buscar el usuario por email');
    }
};


const updateDescription = async (_id, newDescription) => {
    try {
        return await USUARIOS.findByIdAndUpdate(_id, { descripcion: newDescription }, { new: true });
    } catch (error) {
        throw new Error('Error al actualizar la descripción');
    }
};

const updateEspecialidad = async (_id, newEspecialidad) => {
    try {
        return await USUARIOS.findByIdAndUpdate(_id, { especialidad: newEspecialidad }, { new: true });
    } catch (error) {
        throw new Error('Error al actualizar la especialidad');
    }
};


exports.getUsuarios = async (req, res) => {
    try {
        const usuarios = await USUARIOS.find();
        res.status(200).json(usuarios);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.getUsuarioByEmail = async (req, res) => {
    const email = req.params.email;

    try {
        const usuario = await USUARIOS.findOne({ correo: email });
        if (!usuario) {
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }

        res.status(200).json(usuario);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.updateDescriptionAndEspecialidad = async (req, res) => {
    const { email, newDescription, newEspecialidad } = req.body;

    try {
        const userId = await idByEmail(email);

        if (!userId) {
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }

        const updatedDescription = await updateDescription(userId, newDescription);
        const updatedEspecialidad = await updateEspecialidad(userId, newEspecialidad);

        const updatedUser = await USUARIOS.findById(userId);
        res.status(200).json(updatedUser);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.getClientes = async (req, res) => {
    try {
        const clientes = await USUARIOS.find({ tipo: "cliente" });
        res.status(200).json(clientes);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};


exports.getAbogados = async (req, res) => {
    try {
        const abogados = await USUARIOS.find({ tipo: "abogado" });
        res.status(200).json(abogados);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};


exports.loginOrRegister = async (req, res) => {
    console.log("loginOrRegister");
    // Obtén los datos del usuario desde el token verificado
    const { uid, email, name, picture } = req.user;
  
    try {
      // Busca si el usuario ya existe en la base de datos
      let usuario = await USUARIOS.findOne({ uid });
  
      if (usuario) {
        // Si el usuario ya existe, puedes actualizar su información si es necesario
        usuario.email = email;
        usuario.nombre = name;
        usuario.foto = picture;
        await usuario.save();
        return res.status(200).json({ message: 'Usuario existente', usuario });
      } else {
        // Si el usuario no existe, créalo
        const nuevoUsuario = new USUARIOS({
          uid,
          correo: email,
          nombre: name,
          foto: picture,
          tipo: 'cliente', // O asigna el tipo según tu lógica
          // Otros campos que desees inicializar
        });
  
        const usuarioCreado = await nuevoUsuario.save();
        return res.status(201).json({ message: 'Usuario creado', usuario: usuarioCreado });
      }
    } catch (error) {
      console.error('Error al crear o actualizar el usuario:', error);
      return res.status(500).json({ message: 'Error interno del servidor' });
    }
};

exports.createUser = async (req, res) => {
    const { email, nombre, tipo } = req.body;

    // Verificar que los campos requeridos estén presentes
    if (!email || !nombre || !tipo) {
        return res.status(400).json({ message: 'Email, nombre y tipo son requeridos para registrar un nuevo usuario' });
    }

    try {
        // Verificar nuevamente si el usuario ya existe (en caso de una segunda solicitud)
        let usuario = await USUARIOS.findOne({ correo: email.trim() });

        if (usuario) {
            return res.status(400).json({ message: 'Usuario ya registrado con este correo' });
        }

        // Crear el nuevo usuario
        const nuevoUsuario = new USUARIOS({
            correo: email.trim(),
            nombre,
            tipo,
            foto: '/media/foto_generica.png' // Foto predeterminada o se puede personalizar
        });

        // Guardar el usuario en la base de datos
        const usuarioCreado = await nuevoUsuario.save();

        console.log('Nuevo usuario creado:', usuarioCreado);
        return res.status(201).json({ message: 'Usuario creado exitosamente', usuario: usuarioCreado });

    } catch (error) {
        // Manejo de errores
        console.log('Error:', error.message);
        return res.status(500).json({ message: error.message });
    }
};

exports.getPicture = async (req, res) => {
    const email = req.params.email;

    try {
        const usuario = await USUARIOS.findOne({ correo: email });

        console.log('Usuario encontrado:', usuario);

        if (!usuario) {
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }
        if (!usuario.foto) {
            console.log('Foto no disponible:', usuario);
            return res.status(404).json({ message: 'Foto no disponible para este usuario' });
        }
        console.log('Foto encontrada:', usuario.foto);
        return res.status(200).json({ foto: usuario.foto });
    } catch (error) {
        console.log('Error encontrado:', error.message);
        return res.status(500).json({ message: error.message });
    }
};

exports.updatePicture = async (req, res) => {
    const { email, newPicture } = req.body;

    // Check if email and newPicture are provided
    if (!email || !newPicture) {
        return res.status(400).json({ message: 'Email o nueva imagen no proporcionados' });
    }

    try {
        // Log the email being passed
        console.log('Email recibido:', email);

        // Find the user by email and update the foto field
        const updatedUser = await USUARIOS.findOneAndUpdate(
            { correo: email.trim() }, // Using trim() to avoid leading/trailing spaces
            { foto: newPicture }, 
            { new: true } // Return the updated user
        );

        // Log the query result to check if a user is found
        console.log('Usuario actualizado:', updatedUser);

        // If no user is found, send a 404 response
        if (!updatedUser) {
            console.log('Usuario no encontrado');
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }

        // Send back the updated user with the new picture
        return res.status(200).json(updatedUser);
    } catch (error) {
        console.log('Error encontrado:', error.message);
        return res.status(500).json({ message: error.message });
    }
};

exports.convertirAbogado = async (req, res) => {
    const email = req.params.email; // Get email from URL parameters

    try {
        const userId = await idByEmail(email);

        if (!userId) {
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }

        // Update the user to convert them to an "abogado" and add initial fields if missing
        const updatedUser = await USUARIOS.findByIdAndUpdate(
            userId,
            {
                tipo: "abogado",
                descripcion: "Descripción inicial para el abogado",
                especialidad: "Especialidad inicial para el abogado"
            },
            { new: true } // Return the updated document
        );

        if (!updatedUser) {
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }

        res.status(200).json({message: 'Conversion exitosa'});
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.getUsuarioById = async (req, res) => {
    const id = req.params.id;

    try {
        const usuario = await USUARIOS.findById(id);
        if (!usuario) {
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }

        res.status(200).json(usuario);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};