const Employee = require('../models/Employee');

const createEmployee = async (req, res) => {
    try {
        // Generate a new employee_id using the stored procedure
        const employee_id = await Employee.generateEmployeeId();

        // Create new employee using Sequelize model and generated employee_id
        const newEmployee = await Employee.create({
            employee_id,
            first_name: req.body.first_name,
            last_name: req.body.last_name,
            identity_number: req.body.identity_number,
            date_of_birth: req.body.date_of_birth,
            gender: req.body.gender,
            street_name: req.body.street_name,
            destination_place: req.body.destination_place,
            city_name: req.body.city_name,
            postal_code: req.body.postal_code,
            email_address: req.body.email_address,
            mobile_number: req.body.mobile_number,
            job_name: req.body.job_name,
            salary_grade: req.body.salary_grade,
            hired_date: req.body.hired_date,
            status: req.body.employee_status
        });

        // Respond with the newly created employee object
        res.status(201).json(newEmployee);
    } catch (error) {
        console.error('Error creating employee:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

module.exports = {
    createEmployee
};
