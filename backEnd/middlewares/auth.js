const admin = require('firebase-admin');

const verifyFirebaseToken = async (req, res, next) => {
  console.log("middleWare");
  const authorizationHeader = req.headers.authorization;

  if (!authorizationHeader || !authorizationHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'No se proporcionó token de autenticación' });
  }

  const idToken = authorizationHeader.split('Bearer ')[1];

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.user = decodedToken;
    next();
  } catch (error) {
    return res.status(401).json({ message: 'Token de autenticación inválido' });
  }
};

module.exports = verifyFirebaseToken;