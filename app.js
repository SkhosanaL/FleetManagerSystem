require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const sequelize = require('./config/db.config'); // Assuming your Sequelize configuration is in 'db.config.js'

const authRoutes = require('./routes/auth.routes'); // Example routes, adjust as per your project structure
const adminRoutes = require('./routes/admin.routes');
const driverRoutes = require('./routes/driver.routes');
const employeeRoutes = require('./routes/employee.routes');

const app = express();

// Middleware
app.use(cors()); // Enable CORS
app.use(bodyParser.json()); // Parse JSON request bodies
app.use(express.static('public')); // Serve static files from 'public' directory

// Routes
app.use('/api/auth', authRoutes); // Mount auth routes
app.use('/api/admin', adminRoutes); // Mount admin routes
app.use('/api/driver', driverRoutes); // Mount driver routes
app.use('/api/employees', employeeRoutes); // Mount employee routes

// Database synchronization with Sequelize
sequelize.sync()
  .then(() => {
    console.log('Database synchronized successfully');
  })
  .catch((error) => {
    console.error('Unable to synchronize the database:', error);
  });

// Start the server
const PORT = process.env.PORT || 3000; // Use PORT from environment variables or default to 3000
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
