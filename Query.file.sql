-- Departments Table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

-- Employees Table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary NUMERIC(10,2),
    department_id INTEGER REFERENCES departments(department_id),
    hire_date DATE
);

-- Sample Data for Departments
INSERT INTO departments (department_name, location) VALUES
('Engineering', 'Gurgaon'),
('Sales', 'Delhi'),
('Marketing', 'Mumbai'),
('HR', 'Bangalore');


-- Sample Data for Employees
INSERT INTO employees (first_name, last_name, email, salary, department_id, hire_date) VALUES
('Aarav', 'Sharma', 'aarav.sharma@company.com', 85000, 1, '2023-01-15'),
('Priya', 'Verma', 'priya.verma@company.com', 72000, 2, '2022-11-20'),
('Rohan', 'Mehta', 'rohan.mehta@company.com', 95000, 1, '2023-03-10'),
('Sneha', 'Kapoor', 'sneha.kapoor@company.com', 68000, 3, '2024-01-05'),
('Vikram', 'Singh', 'vikram.singh@company.com', 78000, 2, '2022-08-12'),
('Ananya', 'Gupta', 'ananya.gupta@company.com', 82000, 1, '2023-06-22'),
('Karan', 'Malhotra', 'karan.malhotra@company.com', 55000, 4, '2024-02-01'),
('Isha', 'Bhatia', 'isha.bhatia@company.com', 91000, 3, '2023-09-18');


SELECT * FROM employees;--data of all employees

SELECT first_name, last_name, salary FROM employees;

SELECT first_name, last_name, salary
FROM employees
WHERE salary > 80000;


SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date > '2023-01-01';


SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC;



SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 3;



SELECT COUNT(*) AS total_employees FROM employees;
