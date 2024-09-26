const mongoose = require('mongoose');

// MongoDB connection using MONGO_URI from .env
const connectDB = async () => {
  try {
    // No need for useNewUrlParser and useUnifiedTopology in MongoDB Driver 4.0+
    const conn = await mongoose.connect(process.env.MONGO_URI);
    console.log(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1); // Exit process if connection fails
  }
};

module.exports = connectDB;
