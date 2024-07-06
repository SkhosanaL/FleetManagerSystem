USE fleetdb;

CREATE TABLE Vehicles (
    vehicle_id VARCHAR(10) PRIMARY KEY,
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    license_plate CHAR(8),
    vin VARCHAR(50),
    current_status ENUM('Available', 'In Service', 'Inactive'),
    last_service_date DATE,
    next_service_date DATE,
    odometer_reading INT,
    date_purchased DATE,
    purchase_amount DECIMAL(10, 2),
    depreciated ENUM('Yes', 'No'),
    depreciated_value DECIMAL(10, 2)
);

CREATE TABLE Employees (
    employee_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    identity_number CHAR(13),
    date_of_birth DATE,
    Job_name VARCHAR(50),
    gender ENUM('Male', 'Female'),
    street_name VARCHAR(100),
    destination_place VARCHAR(100),
    city_name VARCHAR(50),
    postal_code VARCHAR(10),
    email_address VARCHAR(100),
    mobile_number VARCHAR(15),
    salary_grade VARCHAR(10),
    hired_date DATE,
    status ENUM('Permanent', 'Contracted', 'Internship', 'Resignation', 'Retired')
);

CREATE TABLE Users (
    user_id VARCHAR(10) PRIMARY KEY,
    username VARCHAR(50),
    password VARCHAR(255),
    role VARCHAR(20),
    employee_id VARCHAR(10),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Drivers (
    driver_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    license_number VARCHAR(50),
    assigned_vehicle_id VARCHAR(10),
    status VARCHAR(20),
    employee_id VARCHAR(10),
    FOREIGN KEY (assigned_vehicle_id) REFERENCES Vehicles(vehicle_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE MaintenanceRecords (
    maintenance_id VARCHAR(10) PRIMARY KEY,
    vehicle_id VARCHAR(10),
    date_of_maintenance DATE,
    description VARCHAR(255),
    cost DECIMAL(10, 2),
    service_provider VARCHAR(100),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Trips (
    trip_id VARCHAR(10) PRIMARY KEY,
    vehicle_id VARCHAR(10),
    driver_id VARCHAR(10),
    start_date_time DATETIME,
    end_date_time DATETIME,
    starting_location VARCHAR(100),
    destination VARCHAR(100),
    trip_status VARCHAR(20),
    opening_odometer INT,
    closing_odometer INT,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE FuelLogs (
    log_id VARCHAR(10) PRIMARY KEY,
    vehicle_id VARCHAR(10),
    date DATE,
    price_per_liter DECIMAL(5, 2),
    fuel_cost DECIMAL(10, 2),
    odometer_reading INT,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Salaries (
    salary_id VARCHAR(10) PRIMARY KEY,
    employee_id VARCHAR(10),
    rate_per_hour DECIMAL(10, 2),
    hours_worked INT,
    salary_amount DECIMAL(10, 2),
    payment_date DATE,
    payment_period VARCHAR(20),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

DELIMITER //

CREATE PROCEDURE generate_unique_id_vehicle(
    OUT new_id VARCHAR(10),
    INOUT counter INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE temp_id VARCHAR(10);

    REPEAT
        SET counter = counter + 1;
        SET temp_id = CONCAT('Veh', LPAD(counter, 4, '0'));
        IF NOT EXISTS (SELECT 1 FROM Vehicles WHERE vehicle_id = temp_id) THEN
            SET done = 1;
            SET new_id = temp_id;
        END IF;
    UNTIL done END REPEAT;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE insert_vehicle(
    IN p_make VARCHAR(50),
    IN p_model VARCHAR(50),
    IN p_year INT,
    IN p_license_plate CHAR(8),
    IN p_vin VARCHAR(50),
    IN p_current_status ENUM('Available', 'In Service', 'Inactive'),
    IN p_last_service_date DATE,
    IN p_next_service_date DATE,
    IN p_odometer_reading INT,
    IN p_date_purchased DATE,
    IN p_purchase_amount DECIMAL(10, 2),
    IN p_depreciated ENUM('Yes', 'No'),
    IN p_depreciated_value DECIMAL(10, 2)
)
BEGIN
    DECLARE new_id VARCHAR(10);
    DECLARE counter INT DEFAULT 0;

    CALL generate_unique_id_vehicle(new_id, counter);
    INSERT INTO Vehicles (vehicle_id, make, model, year, license_plate, vin, current_status, last_service_date, next_service_date, odometer_reading, date_purchased, purchase_amount, depreciated, depreciated_value)
    VALUES (new_id, p_make, p_model, p_year, p_license_plate, p_vin, p_current_status, p_last_service_date, p_next_service_date, p_odometer_reading, p_date_purchased, p_purchase_amount, p_depreciated, p_depreciated_value);
END //

DELIMITER ;
/*insert_vehicle('Toyota', 'Corolla', 2019, 'ABC12345', '1HGCM82633A123456', 'Available', '2023-01-15', '2023-07-15', 50000, '2019-01-01', 200000.00, 'No', 0.00);*/

DELIMITER ;

DELIMITER //

CREATE PROCEDURE generate_unique_id_employee(
    OUT new_id VARCHAR(10),
    INOUT counter INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE temp_id VARCHAR(10);

    REPEAT
        SET counter = counter + 1;
        SET temp_id = CONCAT('Emp', LPAD(counter, 4, '0'));
        IF NOT EXISTS (SELECT 1 FROM Employees WHERE employee_id = temp_id) THEN
            SET done = 1;
            SET new_id = temp_id;
        END IF;
    UNTIL done END REPEAT;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE insert_employee(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_identity_number CHAR(13),
    IN p_date_of_birth DATE,
    IN p_gender ENUM('Male', 'Female'),
    IN p_street_name VARCHAR(100),
    IN p_destination_place VARCHAR(100),
    IN p_city_name VARCHAR(50),
    IN p_postal_code VARCHAR(10),
    IN p_email_address VARCHAR(100),
    IN p_mobile_number VARCHAR(15),
    IN p_salary_grade VARCHAR(10),
    IN p_Job_name VARCHAR(50),
    IN p_hired_date DATE,
    IN p_status ENUM('Permanent', 'Contracted', 'Internship', 'Resignation', 'Retired')
)
BEGIN
    DECLARE new_id VARCHAR(10);
    DECLARE counter INT;

    CALL generate_unique_id_employee(new_id, counter);
    INSERT INTO Employees (employee_id, first_name, last_name, identity_number, date_of_birth, gender, street_name, destination_place, city_name, postal_code, email_address, mobile_number,  Job_name, salary_grade, hired_date, status)
    VALUES (new_id, p_first_name, p_last_name, p_identity_number, p_date_of_birth, p_gender, p_street_name, p_destination_place, p_city_name, p_postal_code, p_email_address, p_mobile_number, p_salary_grade, p_Job_name, p_hired_date, p_status);
END //
DELIMITER ;

DELIMITER //

CREATE PROCEDURE generate_unique_id_driver(
    OUT new_id VARCHAR(7),
    INOUT counter INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE temp_id VARCHAR(7);

    REPEAT
        SET counter = counter + 1;
        SET temp_id = CONCAT('Drv', LPAD(counter, 4, '0'));
        IF NOT EXISTS (SELECT 1 FROM Drivers WHERE driver_id = temp_id) THEN
            SET done = 1;
            SET new_id = temp_id;
        END IF;
    UNTIL done END REPEAT;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE InsertDriver(
    IN name VARCHAR(100),
    IN license_number VARCHAR(50),
    IN contact_info VARCHAR(100),
    IN assigned_vehicle_id INT,
    IN status VARCHAR(20),
    IN employee_id INT
)
BEGIN
    INSERT INTO Drivers (name, license_number, contact_info, assigned_vehicle_id, status, employee_id)
    VALUES (name, license_number, contact_info, assigned_vehicle_id, status, employee_id);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE generate_unique_id_fuel_log(
    OUT new_id VARCHAR(7),
    INOUT counter INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE temp_id VARCHAR(7);

    REPEAT
        SET counter = counter + 1;
        SET temp_id = CONCAT('Fuel', LPAD(counter, 4, '0'));
        IF NOT EXISTS (SELECT 1 FROM FuelLogs WHERE fuel_log_id = temp_id) THEN
            SET done = 1;
            SET new_id = temp_id;
        END IF;
    UNTIL done END REPEAT;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE InsertFuelLog(
    IN vehicle_id INT,
    IN date DATE,
    IN fuel_amount DECIMAL(5, 2),
    IN cost DECIMAL(10, 2),
    IN odometer_reading INT
)
BEGIN
    INSERT INTO FuelLogs (vehicle_id, date, fuel_amount, cost, odometer_reading)
    VALUES (vehicle_id, date, fuel_amount, cost, odometer_reading);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE generate_unique_id_maintenance_record(
    OUT new_id VARCHAR(7),
    INOUT counter INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE temp_id VARCHAR(7);

    REPEAT
        SET counter = counter + 1;
        SET temp_id = CONCAT('Main', LPAD(counter, 4, '0'));
        IF NOT EXISTS (SELECT 1 FROM MaintenanceRecords WHERE maintenance_record_id = temp_id) THEN
            SET done = 1;
            SET new_id = temp_id;
        END IF;
    UNTIL done END REPEAT;
END //

DELIMITER ;
DELIMITER //
CREATE PROCEDURE InsertMaintenanceRecord(
    IN vehicle_id INT,
    IN date_of_maintenance DATE,
    IN description VARCHAR(255),
    IN cost DECIMAL(10, 2),
    IN service_provider VARCHAR(100)
)
BEGIN
    INSERT INTO MaintenanceRecords (vehicle_id, date_of_maintenance, description, cost, service_provider)
    VALUES (vehicle_id, date_of_maintenance, description, cost, service_provider);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE generate_unique_id_trip(
    OUT new_id VARCHAR(7),
    INOUT counter INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE temp_id VARCHAR(7);

    REPEAT
        SET counter = counter + 1;
        SET temp_id = CONCAT('Trip', LPAD(counter, 4, '0'));
        IF NOT EXISTS (SELECT 1 FROM Trips WHERE trip_id = temp_id) THEN
            SET done = 1;
            SET new_id = temp_id;
        END IF;
    UNTIL done END REPEAT;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE InsertTrip(
    IN vehicle_id INT,
    IN driver_id INT,
    IN start_date_time DATETIME,
    IN end_date_time DATETIME,
    IN starting_location VARCHAR(100),
    IN destination VARCHAR(100),
    IN trip_status VARCHAR(20)
)
BEGIN
    INSERT INTO Trips (vehicle_id, driver_id, start_date_time, end_date_time, starting_location, destination, trip_status)
    VALUES (vehicle_id, driver_id, start_date_time, end_date_time, starting_location, destination, trip_status);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE generate_unique_id_user(
    OUT new_id VARCHAR(7),
    INOUT counter INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE temp_id VARCHAR(7);

    REPEAT
        SET counter = counter + 1;
        SET temp_id = CONCAT('Usr', LPAD(counter, 4, '0'));
        IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = temp_id) THEN
            SET done = 1;
            SET new_id = temp_id;
        END IF;
    UNTIL done END REPEAT;
END //

DELIMITER ;
DELIMITER //
CREATE PROCEDURE InsertUser(
    IN username VARCHAR(50),
    IN password VARCHAR(255),
    IN role VARCHAR(20),
    IN employee_id INT
)
BEGIN
    INSERT INTO Users (username, password, role, employee_id)
    VALUES (username, password, role, employee_id);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE generate_unique_id_salary(
    OUT new_id VARCHAR(7),
    INOUT counter INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE temp_id VARCHAR(7);

    REPEAT
        SET counter = counter + 1;
        SET temp_id = CONCAT('Sal', LPAD(counter, 4, '0'));
        IF NOT EXISTS (SELECT 1 FROM Salaries WHERE salary_id = temp_id) THEN
            SET done = 1;
            SET new_id = temp_id;
        END IF;
    UNTIL done END REPEAT;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE InsertSalary(
    IN employee_id INT,
    IN salary_amount DECIMAL(10, 2),
    IN payment_date DATE,
    IN payment_period VARCHAR(20)
)
BEGIN
    INSERT INTO Salaries (employee_id, salary_amount, payment_date, payment_period)
    VALUES (employee_id, salary_amount, payment_date, payment_period);
END //

DELIMITER ;

