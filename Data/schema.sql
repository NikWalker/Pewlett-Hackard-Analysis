-- Creating tables for PH-EmployeeDB
Create Table departments(dept_no VARCHAR(4) NOT NULL,
						dept_name VARCHAR(40) NOT NULL,
						PRIMARY KEY (dept_no),
						 UNIQUE (dept_name));
	
CREATE TABLE employees (emp_no INT NOT NULL,
					   birth_date DATE NOT NULL,
					   first_name VARCHAR NOT NULL,
					   last_name VARCHAR NOT NULL,
					   gender VARCHAR NOT NULL,
					   hire_date DATE NOT NULL,
					   PRIMARY KEY (emp_no));
					   
CREATE TABLE dept_manager (
	dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no,dept_no));
	
CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary VARCHAR NOT NULL, 
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no));
	
CREATE TABLE dept_emp (emp_no INT NOT NULL,
					  dept_no VARCHAR NOT NULL,
					  from_date DATE NOT NULL,
					   to_date DATE NOT NULL,
					   FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
					   FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
					   PRIMARY KEY (dept_no, emp_no));
					   
CREATE TABLE titles (emp_no INT NOT NULL,
					title VARCHAR NOT NULL,
					from_date DATE NOT NULL,
					to_date DATE NOT NULL,
					FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
					PRIMARY KEY (emp_no,title, from_date));	

--creating table from query parameters
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
	--deleted above
SELECT * FROM retirement_info;	

--Create new table for retiring employees including emp#
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--elegible retiries that still work at company 
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp as de
ON ri.emp_no= de.emp_no
WHERE de.to_date = ('9999-01-01');

--Employee count by department number
SELECT COUNT (ce.emp_no), dept_no
INTO dept_retirement
FROM current_emp AS ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM dept_retirement


--7.3.5 list 1
SELECT e.emp_no, e.first_name, e.last_name,
		e.gender, s.salary, de.to_date
--INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31');
	AND (de.to_date = '9999-01-01');

--list 2:  managers per department
SELECT dm.dept_no,
		d.dept_name,
		dm.emp_no,
		ce.last_name,
		ce.first_name,
		dm.from_date,
		dm.to_date
INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments as d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp as ce
		ON (dm.emp_no = ce.emp_no);
			
-- list 3. department info		
SELECT ce.emp_no,
		ce.first_name,
		ce.last_name,
		d.dept_name
INTO dept_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de
	ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
	ON (de.dept_no = d.dept_no);			