-- =============================================
-- DATABASE SETUP
-- =============================================

-- 1. Create employees table (if not exists)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE employees';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

-- 2. Insert sample data
INSERT ALL
    INTO employees VALUES (1, 'John', 'Smith', 'IT', 75000.00, TO_DATE('2018-06-20', 'YYYY-MM-DD'))
    INTO employees VALUES (2, 'Sarah', 'Jones', 'HR', 85000.00, TO_DATE('2015-03-14', 'YYYY-MM-DD'))
    INTO employees VALUES (3, 'Michael', 'Brown', 'Finance', 95000.00, TO_DATE('2010-08-24', 'YYYY-MM-DD'))
    INTO employees VALUES (4, 'Emily', 'Wilson', 'IT', 72000.00, TO_DATE('2020-01-10', 'YYYY-MM-DD'))
    INTO employees VALUES (5, 'David', 'Miller', 'Marketing', 67000.00, TO_DATE('2019-11-15', 'YYYY-MM-DD'))
    INTO employees VALUES (6, 'Jessica', 'Davis', 'HR', 82000.00, TO_DATE('2016-05-30', 'YYYY-MM-DD'))
    INTO employees VALUES (7, 'Robert', 'Taylor', 'Finance', 92000.00, TO_DATE('2012-04-22', 'YYYY-MM-DD'))
    INTO employees VALUES (8, 'Amanda', 'Anderson', 'Marketing', 71000.00, TO_DATE('2021-02-08', 'YYYY-MM-DD'))
    INTO employees VALUES (9, 'Thomas', 'Johnson', 'IT', 78000.00, TO_DATE('2017-09-18', 'YYYY-MM-DD'))
    INTO employees VALUES (10, 'Lisa', 'Clark', 'Finance', 88000.00, TO_DATE('2014-07-12', 'YYYY-MM-DD'))
SELECT * FROM dual;

COMMIT;

-- =============================================
-- QUERY SOLUTIONS
-- =============================================

-- 1. Compare Values with Previous/Next Records
SELECT 
    employee_id,
    first_name || ' ' || last_name AS employee_name,
    department,
    salary,
    LAG(salary, 1) OVER(ORDER BY employee_id) as previous_salary,
    CASE 
        WHEN LAG(salary, 1) OVER(ORDER BY employee_id) IS NULL THEN 'FIRST RECORD'
        WHEN salary > LAG(salary, 1) OVER(ORDER BY employee_id) THEN 'HIGHER'
        WHEN salary < LAG(salary, 1) OVER(ORDER BY employee_id) THEN 'LOWER'
        ELSE 'EQUAL'
    END as comparison_with_previous,
    LEAD(salary, 1) OVER(ORDER BY employee_id) as next_salary,
    CASE 
        WHEN LEAD(salary, 1) OVER(ORDER BY employee_id) IS NULL THEN 'LAST RECORD'
        WHEN salary > LEAD(salary, 1) OVER(ORDER BY employee_id) THEN 'HIGHER'
        WHEN salary < LEAD(salary, 1) OVER(ORDER BY employee_id) THEN 'LOWER'
        ELSE 'EQUAL'
    END as comparison_with_next
FROM employees
ORDER BY employee_id;

-- 2. Ranking Data within Categories
-- 2a. RANK() vs DENSE_RANK() demonstration
SELECT 
    employee_id,
    first_name || ' ' || last_name AS employee_name,
    department,
    salary,
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) as rank,
    DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) as dense_rank,
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) as row_num
FROM employees;

-- 2b. Explanation query showing difference
SELECT 
    department,
    salary,
    RANK() OVER(ORDER BY salary DESC) as rank,
    DENSE_RANK() OVER(ORDER BY salary DESC) as dense_rank,
    'RANK leaves gaps after ties, DENSE_RANK does not' as explanation
FROM employees
WHERE department = 'Finance';

-- 3. Identifying Top Records (Top 3 per department)
WITH ranked_salaries AS (
    SELECT 
        employee_id,
        first_name || ' ' || last_name AS employee_name,
        department,
        salary,
        DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) as salary_rank
    FROM employees
)
SELECT 
    employee_id,
    employee_name,
    department,
    salary,
    salary_rank
FROM ranked_salaries
WHERE salary_rank <= 3
ORDER BY department, salary_rank;

-- 4. Finding Earliest Records (First 2 hires per department)
WITH hire_sequence AS (
    SELECT 
        employee_id,
        first_name || ' ' || last_name AS employee_name,
        department,
        hire_date,
        ROW_NUMBER() OVER(PARTITION BY department ORDER BY hire_date) as hire_order
    FROM employees
)
SELECT 
    employee_id,
    employee_name,
    department,
    hire_date,
    hire_order,
    'First ' || hire_order || ' in department' as position
FROM hire_sequence
WHERE hire_order <= 2
ORDER BY department, hire_order;

-- 5. Aggregation with Window Functions
SELECT 
    employee_id,
    first_name || ' ' || last_name AS employee_name,
    department,
    salary,
    MAX(salary) OVER(PARTITION BY department) as dept_max_salary,
    MAX(salary) OVER() as overall_max_salary,
    ROUND((salary / MAX(salary) OVER(PARTITION BY department)) * 100, 2) as pct_of_dept_max,
    ROUND((salary / MAX(salary) OVER()) * 100, 2) as pct_of_overall_max,
    'PARTITION BY creates category-level aggregation' as explanation
FROM employees
ORDER BY department, salary DESC;

-- =============================================
-- ADDITIONAL DEMONSTRATION QUERIES
-- =============================================

-- Running salary totals by department
SELECT 
    employee_id,
    department,
    salary,
    SUM(salary) OVER(PARTITION BY department ORDER BY employee_id) as running_dept_total,
    SUM(salary) OVER(ORDER BY employee_id) as running_overall_total
FROM employees;

-- Salary percentiles
SELECT 
    employee_id,
    first_name || ' ' || last_name AS employee_name,
    salary,
    ROUND(PERCENT_RANK() OVER(ORDER BY salary) * 100, 2) as percentile,
    NTILE(4) OVER(ORDER BY salary) as quartile
FROM employees;