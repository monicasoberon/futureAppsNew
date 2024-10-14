const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const connectDB = require("./config/db");
const faqRoutes = require("./routes/faqRoutes");
const noticiasRoutes = require("./routes/noticiasRoutes");
const usuariosRoutes = require("./routes/usuariosRoutes");
const citasRoutes = require("./routes/citasRoutes");
const casosRoutes = require("./routes/casosRoutes");
const tareasCasosRoutes = require("./routes/tareasCasosRoutes");
const chatGPTRoutes = require("./routes/chatGPTRoutes");
const chatGPTRoutes2 = require("./routes/chatGPTRoutes2");
const tesisRoutes = require("./routes/tesisRoutes");

dotenv.config();
connectDB();

var admin = require("firebase-admin");

var serviceAccount = require("./bufetectest-firebase-adminsdk-cyhvc-6db128251a.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const app = express();

app.use(express.json());
app.use(cors());

app.use("/media", express.static("media"));

app.use("/api/faq", faqRoutes);
app.use("/api/noticias", noticiasRoutes);
app.use("/api/usuarios", usuariosRoutes);
app.use("/api/citas", citasRoutes);
app.use("/api/casos", casosRoutes);
app.use("/api/tareasCasos", tareasCasosRoutes);
app.use("/api/gpt", chatGPTRoutes);
app.use("/api/gpt2", chatGPTRoutes2);
app.use("/api/tesis", tesisRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
