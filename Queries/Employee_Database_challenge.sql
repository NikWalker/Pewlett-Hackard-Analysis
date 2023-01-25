--Create retirement titles table, from empoyees and titles table 
SELECT emp.emp_no, emp.first_name, emp.last_name,
	ti.title, ti.from_date, ti.to_date
INTO retirement_titles 
FROM employees as emp
LEFT JOIN titles as ti
ON emp.emp_no = ti.emp_no
WHERE emp.birth_date BETWEEN '01-01-1952' AND '12-31-1955'
ORDER BY emp.emp_no; 

SELECT * FROM retirement_titles;

--dropped table to recreate
DROP TABLE retirement_titles CASCADE;

-- Use Dictinct with Orderby to remove duplicate rows
-- Create unique titles table
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles as rt
WHERE rt.to_date = '9999-01-01'
ORDER BY rt.emp_no, rt.to_date DESC;

SELECT * FROM unique_titles;

--get number of employees by their most recent job title who are about to retire.
--Create retiring titles table 
SELECT COUNT(ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY count DESC;

SELECT * FROM retiring_titles;

-- create a Mentorship Eligibility table that holds the employees 
--who are eligible to participate in a mentorship program

SELECT DISTINCT ON (emp.emp_no) emp.emp_no, 
    emp.first_name, emp.last_name, 
    emp.birth_date, de.from_date,
    de.to_date, ti.title
INTO mentorship_eligibilty 
FROM employees AS emp
LEFT JOIN dept_emp AS de
ON emp.emp_no = de.emp_no
LEFT JOIN titles as ti
ON emp.emp_no = ti.emp_no
WHERE (de.to_date = '9999-01-01') AND (emp.birth_date BETWEEN '01-01-1965' AND '12-31-1965')
GROUP BY de.to_date, emp.birth_date, emp.emp_no, de.from_date, ti.title
ORDER BY emp.emp_no;

DROP TABLE mentorship_eligibilty CASCADE;
SELECT * FROM mentorship_eligibilty;