baseURL = `http://127.0.0.1:5500/`;

// Employee.js

function addNew() {
    // Collect data from form fields
    const employeeData = {
        employee_number: document.getElementById('employee-number').value,
        first_name: document.getElementById('first-name').value,
        last_name: document.getElementById('last-name').value,
        identity_number: document.getElementById('identity-number').value,
        date_of_birth: document.getElementById('date-of-birth').value,
        street_name: document.getElementById('street-name').value,
        destination_place: document.getElementById('destination-place').value,
        city_name: document.getElementById('city-name').value,
        postal_code: document.getElementById('postal-code').value,
        email_address: document.getElementById('email-address').value,
        mobile_number: document.getElementById('mobile-number').value,
        job_name: document.getElementById('job-name').value,
        salary_grade: document.getElementById('salary-grade').value,
        hired_date: document.getElementById('hired-date').value,
        employee_status: document.getElementById('employee-status').value,
        gender: document.querySelector('input[name="gender"]:checked').value
    };

    // Send POST request to backend
    fetch(`${baseURL}/api/employees`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(employeeData),
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        console.log('Employee added successfully:', data);
        // Optionally, you can clear the form or show a success message here
    })
    .catch(error => {
        console.error('Error adding employee:', error);
        // Handle errors here
    });
}
