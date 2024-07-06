// employee.routes.js

const express = require('express');
const router = express.Router();
const Employee = require('../models/Employee'); // Assuming your Sequelize model

// POST /api/employees - Create a new employee
router.post('/', async (req, res) => {
    try {
        const newEmployee = await Employee.create(req.body);
        res.status(201).json(newEmployee);
    } catch (error) {
        console.error('Error creating employee:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

module.exports = router;
