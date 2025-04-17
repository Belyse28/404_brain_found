# 404_brain_found
# Oracle SQL Window Functions Demonstration
## Introduction

This repository demonstrates various Oracle SQL window functions through practical examples. Window functions perform calculations across a set of table rows that are somehow related to the current row, similar to aggregate functions but without grouping rows into a single output row.

#### The examples cover:

-ROW_NUMBER(), RANK(), and DENSE_RANK() for ranking data

-LAG() and LEAD() for accessing data from other rows

-Aggregate window functions (SUM, AVG, MAX, MIN)

-Percentile functions

-FIRST_VALUE and LAST_VALUE

-Practical applications like identifying above-average earners

## Code Examples

### 1. Setting up the Employees Table
```sql
-- First, ensure we have the employees table with sample data
-- If the table already exists, drop it to start fresh
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE employees';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

-- Create the employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

-- Insert sample data
INSERT ALL
    INTO Employees (employee_id, first_name, last_name, department, salary, hire_date) VALUES (1, 'John', 'Smith', 'IT', 75000.00, TO_DATE('2018-06-20', 'YYYY-MM-DD'))
    INTO Employees (employee_id, first_name, last_name, department, salary, hire_date) VALUES (2, 'Sarah', 'Jones', 'HR', 85000.00, TO_DATE('2015-03-14', 'YYYY-MM-DD'))
    INTO Employees (employee_id, first_name, last_name, department, salary, hire_date) VALUES (3, 'Michael', 'Brown', 'Finance', 95000.00, TO_DATE('2010-08-24', 'YYYY-MM-DD'))
    INTO Employees (employee_id, first_name, last_name, department, salary, hire_date) VALUES (4, 'Emily', 'Wilson', 'IT', 72000.00, TO_DATE('2020-01-10', 'YYYY-MM-DD'))
    INTO Employees (employee_id, first_name, last_name, department, salary, hire_date) VALUES (5, 'David', 'Miller', 'Marketing', 67000.00, TO_DATE('2019-11-15', 'YYYY-MM-DD'))
    INTO Employees (employee_id, first_name, last_name, department, salary, hire_date) VALUES (6, 'Jessica', 'Davis', 'HR', 82000.00, TO_DATE('2016-05-30', 'YYYY-MM-DD'))
    INTO Employees (employee_id, first_name, last_name, department, salary, hire_date) VALUES (7, 'Robert', 'Taylor', 'Finance', 92000.00, TO_DATE('2012-04-22', 'YYYY-MM-DD'))
    INTO Employees (employee_id, first_name, last_name, department, salary, hire_date) VALUES (8, 'Amanda', 'Anderson', 'Marketing', 71000.00, TO_DATE('2021-02-08', 'YYYY-MM-DD'))
    INTO Employees (employee_id, first_name, last_name, department, salary, hire_date) VALUES (9, 'Thomas', 'Johnson', 'IT', 78000.00, TO_DATE('2017-09-18', 'YYYY-MM-DD'))
    INTO Employees (employee_id, first_name, last_name, department, salary, hire_date) VALUES (10, 'Lisa', 'Clark', 'Finance', 88000.00, TO_DATE('2014-07-12', 'YYYY-MM-DD'))
SELECT * FROM dual;

COMMIT;
```

### 2. ROW_NUMBER() Examples

```sql
-- Example 1a: Assign row numbers to employees overall
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    ROW_NUMBER() OVER(ORDER BY salary DESC) as overall_salary_rank
FROM 
    employees;

-- Example 1b: Assign row numbers within each department
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) as dept_salary_rank
FROM 
    employees;
```
#### Query result1 screenshot

### 3. RANK() and DENSE_RANK() Examples

```sql

-- Example 2a: Compare RANK() vs DENSE_RANK()
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    RANK() OVER(ORDER BY salary DESC) as salary_rank,
    DENSE_RANK() OVER(ORDER BY salary DESC) as dense_salary_rank
FROM 
    employees;

-- Example 2b: RANK() and DENSE_RANK() within departments
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) as dept_salary_rank,
    DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) as dept_dense_salary_rank
FROM 
    employees;
```

Query result 2

### 4. LAG() and LEAD() Examples

```sql

-- Example 3a: Compare current salary with previous employee's salary
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    LAG(salary, 1, 0) OVER(ORDER BY employee_id) as previous_salary,
    salary - LAG(salary, 1, 0) OVER(ORDER BY employee_id) as salary_difference
FROM 
    employees;

-- Example 3b: Compare salary with next highest earner in the same department
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    LEAD(salary, 1, NULL) OVER(PARTITION BY department ORDER BY salary DESC) as next_lower_salary,
    salary - LEAD(salary, 1, 0) OVER(PARTITION BY department ORDER BY salary DESC) as salary_gap
FROM 
    employees;

-- Example 3c: Calculate year-over-year experience (days between hire dates)
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    hire_date,
    LAG(hire_date, 1) OVER(PARTITION BY department ORDER BY hire_date) as prev_hire_date,
    hire_date - LAG(hire_date, 1) OVER(PARTITION BY department ORDER BY hire_date) as days_after_prev_hire
FROM 
    employees;

```

Query relsult 3

#### 5. Aggregate Window Functions

```sql
-- Example 4a: Calculate running total of salaries
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    SUM(salary) OVER(ORDER BY employee_id) as running_total_salary
FROM 
    employees;

-- Example 4b: Calculate department statistics
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    AVG(salary) OVER(PARTITION BY department) as dept_avg_salary,
    MAX(salary) OVER(PARTITION BY department) as dept_max_salary,
    MIN(salary) OVER(PARTITION BY department) as dept_min_salary,
    COUNT(*) OVER(PARTITION BY department) as dept_employee_count
FROM 
    employees;

-- Example 4c: Calculate percentage of total department salary
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    ROUND(salary / SUM(salary) OVER(PARTITION BY department) * 100, 2) as pct_of_dept_salary
FROM 
    employees;

-- Example 4d: Calculate running averages
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    hire_date,
    salary,
    AVG(salary) OVER(PARTITION BY department ORDER BY hire_date 
                     ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as moving_avg_salary
FROM 
    employees;

```

query result 4

### 6. Salary Comparison with LAG and LEAD

This example demonstrates how to compare each employee's salary with the previous and next employee's salary using LAG() and LEAD() functions.

```sql
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    LAG(salary, 1) OVER(ORDER BY employee_id) as previous_salary,
    CASE 
        WHEN LAG(salary, 1) OVER(ORDER BY employee_id) IS NULL THEN '(null) FIRST RECORD'
        WHEN salary > LAG(salary, 1) OVER(ORDER BY employee_id) THEN 'HIGHER'
        WHEN salary < LAG(salary, 1) OVER(ORDER BY employee_id) THEN 'LOWER'
        ELSE 'EQUAL'
    END as compared_to_previous,
    LEAD(salary, 1) OVER(ORDER BY employee_id) as next_salary,
    CASE 
        WHEN LEAD(salary, 1) OVER(ORDER BY employee_id) IS NULL THEN '(null) LAST RECORD'
        WHEN salary > LEAD(salary, 1) OVER(ORDER BY employee_id) THEN 'HIGHER'
        WHEN salary < LEAD(salary, 1) OVER(ORDER BY employee_id) THEN 'LOWER'
        ELSE 'EQUAL'
    END as compared_to_next
FROM 
    employees
ORDER BY 
    employee_id;

```

query result 5

### This query shows:

Each employee's salary compared to the previous employee (using LAG)

Each employee's salary compared to the next employee (using LEAD)

Clear labels indicating whether the current salary is higher, lower, or equal to adjacent records

Special handling for the first and last records in the result set


### Conclusion: Oracle SQL Window Functions Demonstration

This comprehensive demonstration showcases the power and versatility of Oracle SQL window functions for advanced data analysis. Through practical examples, we've explored how these functions enable sophisticated calculations across related rows without collapsing the result set.
