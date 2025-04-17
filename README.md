# 🧠 404_brain_found
# 🚀 Oracle SQL Window Functions Demonstration
# 👤 Student Information
 
**Name:** UMWALI Belyse  

**ID:** 27229

**Name:** MUVUNYI Holiness

**ID:** 27137

## 📖 Introduction

This repository demonstrates various Oracle SQL window functions through practical examples. Window functions perform calculations across a set of table rows that are somehow related to the current row, similar to aggregate functions but without grouping rows into a single output row.

#### 📋 The examples cover:
- `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()` for ranking data 👑
- `LAG()` and `LEAD()` for accessing data from other rows 🔄
- Aggregate window functions (`SUM`, `AVG`, `MAX`, `MIN`) ➕
- Percentile functions 📊
- `FIRST_VALUE` and `LAST_VALUE` 🏁
- Practical applications like identifying above-average earners 💰

---

## 💻 Code Examples

### 1. 🏗️ Setting up the Employees Table
```sql
-- First, ensure we have the employees table with sample data
-- If the table already exists, drop it to start fresh
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE employees';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

```
### Create the employees table

``` sql
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);
```
### Insert sample data

``` sql

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

### 2. 🔢 ROW_NUMBER() Examples

##### Example 1a: Assign row numbers to employees overall

```sql

SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    ROW_NUMBER() OVER(ORDER BY salary DESC) as overall_salary_rank
FROM 
    employees;
```
### Example 1b: Assign row numbers within each department

```sql
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

![1](https://github.com/user-attachments/assets/ad2f2cf1-ae7d-49f4-9330-6e518123c47d)

#### 3. 🥇 RANK() and DENSE_RANK() Examples
**Example 2a:** Compare RANK() vs DENSE_RANK()

```sql
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
```
### Example 2b: RANK() and DENSE_RANK() within departments
```sql
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

Query result 2 screenshot

![2](https://github.com/user-attachments/assets/6fc9e1bb-678d-46ce-bac4-2ea27f4e894c)

### 4. 🔄 LAG() and LEAD() Examples
#### Example 3a: Compare with previous salary

```sql 
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
```
### Example 3b: Compare salary with next highest earner in the same department

```sql
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
```
#### Example 3c: Calculate year-over-year experience (days between hire dates)
```sql
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

Query relsult 3 screenshot

![3](https://github.com/user-attachments/assets/0ef501d0-8621-45b0-85c3-3339222ee588)

### 5. 🧮 Aggregate Window Functions
#### Example 4a: Running total of salaries


```sql
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    SUM(salary) OVER(ORDER BY employee_id) as running_total_salary
FROM 
    employees;
```
### Example 4b: Calculate department statistics
```sql
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
```
### Example 4c: Calculate percentage of total department salary
```sql
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    ROUND(salary / SUM(salary) OVER(PARTITION BY department) * 100, 2) as pct_of_dept_salary
FROM 
    employees;
```
#### Example 4d: Calculate running averages
```sql
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

query result 4 screenshot

![4](https://github.com/user-attachments/assets/047d36dc-8b09-4839-968a-cb5042b24121)

### 6. 📈 Salary Comparison with LAG and LEAD

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

query result 5 screenshot

![5](https://github.com/user-attachments/assets/11a44492-cf12-4784-9ed3-6f16f7599c18)





## 🎯 Conclusion

### ✨ Key Features
| Feature | Description   |
|---------|--------------------|
| **👑 Ranking** | `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()` for ordered data  |
| **🔄 Comparison** | `LAG()` and `LEAD()` for row-to-row analysis   |
| **➕ Aggregates** | `SUM()`, `AVG()`, `MAX()`, `MIN()` over windows   |
| **📊 Analysis** | `PERCENT_RANK()` and `NTILE()` for percentiles   |

### 💡 Practical Benefits
- ↔️ Compare values across related records
- 🏦 Calculate running totals and moving averages
- 🏢 Analyze by categories (departments, time periods)
- 🏆 Identify top performers and outliers

### 🏭 Common Use Cases
| Use Case | Application | 
|----------|-------------|
| 💰 Compensation | Salary analysis and benchmarking  |
| 💰 Performance | Department metrics and KPIs   |
| 👥 HR Analytics | Employee ranking and evaluation  |
| 📅 Business Intel | Trend analysis over time   |

Window functions provide powerful data analysis capabilities while maintaining query efficiency. These examples can be adapted for various business intelligence and reporting needs. 🚀
