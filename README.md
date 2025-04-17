# 404_brain_found
##Exploring SQL Window Functions

##Explanation: LAG() retrieves the previous employee's salary within each department when ordered by hire date. LEAD() retrieves the next employee's salary. The CASE statement compares these values and labels them as HIGHER, LOWER, or EQUAL.
'''sql
SELECT 
    employee_id, 
    name, 
    department, 
    salary,
    LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) AS previous_salary,
    CASE 
        WHEN salary > LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) THEN 'HIGHER'
        WHEN salary < LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) THEN 'LOWER'
        WHEN salary = LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) THEN 'EQUAL'
        ELSE 'FIRST RECORD'
    END AS comparison_with_previous
FROM employees
ORDER BY department, hire_date;

-- Using LEAD() to compare with next records
SELECT 
    employee_id, 
    name, 
    department, 
    salary,
    LEAD(salary) OVER(PARTITION BY department ORDER BY hire_date) AS next_salary,
    CASE 
        WHEN salary > LEAD(salary) OVER(PARTITION BY department ORDER BY hire_date) THEN 'HIGHER'
        WHEN salary < LEAD(salary) OVER(PARTITION BY department ORDER BY hire_date) THEN 'LOWER'
        WHEN salary = LEAD(salary) OVER(PARTITION BY department ORDER BY hire_date) THEN 'EQUAL'
        ELSE 'LAST RECORD'
    END AS comparison_with_next
FROM employees
ORDER BY department, hire_date;
'''
## Explanation of the difference:
RANK(): Assigns ranks to rows with gaps for ties. For example, if two employees have the same salary and are ranked 2nd, the next employee would be ranked 4th.
DENSE_RANK(): Assigns ranks to rows without gaps for ties. For example, if two employees have the same salary and are ranked 2nd, the next employee would be ranked 3rd.
-- 2. Ranking Data within a Category
-- Demonstrate both RANK() and DENSE_RANK()
SELECT 
    employee_id,
    name,
    department,
    salary,
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS salary_rank,
    DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS salary_dense_rank
FROM employees
ORDER BY department, salary DESC;

## Explanation: This query uses DENSE_RANK() to handle duplicate salaries appropriately. If two employees have the same salary and are both ranked 2nd, then both will be included in the results, and the next highest paid employee would still be considered the 3rd-highest.
-- 3. Identifying Top Records
-- Fetch top 3 highest paid employees in each department
WITH ranked_employees AS (
    SELECT 
        employee_id,
        name,
        department,
        salary,
        DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS salary_rank
    FROM employees
)
SELECT 
    employee_id,
    name,
    department,
    salary
FROM ranked_employees
WHERE salary_rank <= 3
ORDER BY department, salary_rank;

## Explanation: This query uses ROW_NUMBER() to assign a sequential number to each employee within their department, ordered by hire date. We then filter to show only the first two employees hired in each department. ROW_NUMBER() ensures that even if two employees were hired on the same day, they would still be assigned different values.

-- 4. Finding the Earliest Records
-- Retrieve the first 2 employees hired in each department
WITH ranked_by_hire_date AS (
    SELECT 
        employee_id,
        name,
        department,
        hire_date,
        ROW_NUMBER() OVER(PARTITION BY department ORDER BY hire_date) AS hire_order
    FROM employees
)
SELECT 
    employee_id,
    name,
    department,
    hire_date
FROM ranked_by_hire_date
WHERE hire_order <= 2
ORDER BY department, hire_order;

## Explanation: This query demonstrates using window functions with aggregation. The first MAX() calculates the maximum salary within each department (category-level calculation), while the second MAX() calculates the maximum salary across all employees (overall calculation). The PARTITION BY clause differentiates between these two levels of aggregation.

-- 5. Aggregation with Window Functions
-- Calculate maximum salary within each department and overall
SELECT 
    employee_id,
    name,
    department,
    salary,
    MAX(salary) OVER(PARTITION BY department) AS max_salary_in_department,
    MAX(salary) OVER() AS max_salary_overall
FROM employees
ORDER BY department, salary DESC;

-- Using PARTITION BY explicitly to differentiate between category-level and overall calculations
SELECT DISTINCT
    department,
    MAX(salary) OVER(PARTITION BY department) AS category_level_max,
    MAX(salary) OVER() AS overall_max  
FROM employees
ORDER BY department;
