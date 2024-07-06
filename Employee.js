const { Sequelize, DataTypes, Op } = require('sequelize');
const sequelize = require('../config/db.config');

const Employee = sequelize.define('Employee', {
    employee_id: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false,
        unique: true
    },
    first_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    last_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    identity_number: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true
    },
    date_of_birth: {
        type: DataTypes.DATE,
        allowNull: false
    },
    gender: {
        type: DataTypes.ENUM('Male', 'Female'),
        allowNull: false
    },
    street_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    destination_place: {
        type: DataTypes.STRING,
        allowNull: false
    },
    city_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    postal_code: {
        type: DataTypes.STRING,
        allowNull: false
    },
    email_address: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true
    },
    mobile_number: {
        type: DataTypes.STRING,
        allowNull: false
    },
    job_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    salary_grade: {
        type: DataTypes.STRING,
        allowNull: false
    },
    hired_date: {
        type: DataTypes.DATE,
        allowNull: false
    },
    status: {
        type: DataTypes.ENUM('Permanent', 'Contracted', 'Internship', 'Resignation', 'Retired'),
        allowNull: false
    }
}, {
    timestamps: false,
    tableName: 'Employees', // Make sure this matches your actual table name
    // Define a method to call the stored procedure for generating employee_id
    generateEmployeeId: async function() {
        try {
            const [result, metadata] = await sequelize.query('CALL generate_unique_id_employee();');
            if (result && result.length > 0 && result[0][0]) {
                return result[0][0].employee_id;
            }
            throw new Error('Unable to generate employee_id');
        } catch (error) {
            console.error('Error generating employee_id:', error);
            throw error;
        }
    }
});

module.exports = Employee;
