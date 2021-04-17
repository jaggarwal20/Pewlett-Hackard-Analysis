CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

select* from departments

CREATE TABLE employees (
	     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

select * from employees;

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);

select * from dept_emp

CREATE TABLE titles(
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

SELECT emp_no,first_name, last_name
FROM employees;

SELECT title, from_date, to_date
FROM titles;

-- merge tables 
SELECT e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, l.title, l.from_date, l.to_date
INTO employee_titles
FROM employees as e
JOIN titles as l on e.emp_no = l.emp_no;

-- employees able to retire and their titles
SELECT emp_no, first_name, last_name, title, from_date, to_date
INTO retirement_titles
FROM employee_titles
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY emp_no ASC;

select * from retirement_titles;

-- Use Dictinct with Orderby to remove duplicate rows and pull latest title
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title

INTO unique_titles
FROM retirement_titles
ORDER BY emp_no ASC, to_date DESC;

select * FROM latest_retirement_titles;

-- number of employees about to retire by job title
select count(distinct(title))
FROM unique_titles

-- create a table to hold count of distinct titles
SELECT COUNT(title),
title

INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count(title) DESC;

select * FROM retiring_titles;

select emp_no, first_name, last_name, birth_date
from employees;

select from_date, to_date
from dept_emp;

select title
from titles;

SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, d.from_date, d.to_date, l.title
INTO employee_mentors
FROM employees as e
JOIN dept_emp as d on e.emp_no = d.emp_no
JOIN titles as l on e.emp_no = l.emp_no;

SELECT * 
INTO mentorship_elegibility
FROM employee_mentors
WHERE birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER BY emp_no;