const express = require('express');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const faqRoutes = require('./routes/faqRoutes');
const noticiasRoutes = require('./routes/noticiasRoutes');
const usuariosRoutes = require('./routes/usuariosRoutes');
const citasRoutes = require('./routes/citasRoutes');
const casosRoutes = require('./routes/casosRoutes');
const tareasCasosRoutes = require('./routes/tareasCasosRoutes');

dotenv.config();
connectDB();

const app = express();

app.use(express.json());

app.use("/media", express.static("media"));

app.use('/api/faq', faqRoutes);
app.use('/api/noticias', noticiasRoutes);
app.use('/api/usuarios', usuariosRoutes);
app.use('/api/citas', citasRoutes);
app.use('/api/casos', casosRoutes);
app.use('/api/tareasCasos', tareasCasosRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

// Get all citas
// Get all citas por abogado
// Create a cita

// get all noticias titulo, fecha y id
// get noticias por id
// post noticias

// get all usuarios tipo abogado: nombre, especialidad
// get abogado by id: nombre, especialidad, descripcion y foto?

// get all casos numero, nombre y estado
// 
