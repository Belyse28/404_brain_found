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

##  🔍 Instruction Implementation
2. 🔄 Compare Values with Previous/Next Records
   
Requirement: Use LAG()/LEAD() to compare salary values between records

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

### Output Analysis:

#### Query result1 screenshot

![1](https://github.com/user-attachments/assets/e778f393-c03c-4c9d-a492-4bd5fb020e36)

-First record shows NULL for previous salary (no preceding record)

-Last record shows NULL for next salary (no following record)

-Clear comparison labels (HIGHER/LOWER/EQUAL)

-Demonstrates sequential record analysis

### Key Learning:

Window functions enable row-to-row comparisons without self-joins.

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

![2](https://github.com/user-attachments/assets/305eab78-c98b-4e0d-b394-222838ae11cc)


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


###  Analysis:

_ ``LAG()`` accesses the previous row's salary value

_ Defaults to 0 when no previous record exists (first row)

_ Calculates absolute difference between current and previous salary

_ Useful for tracking salary progression across employees

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
###  Analysis:
- LEAD() looks ahead to the next salary in department

- NULL appears for the lowest earner in each department

- Shows the salary gap between current and next employee

-PARTITION BY ensures comparisons stay within departments

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

![3](https://github.com/user-attachments/assets/1dfdd109-7771-42bc-b2af-93186bd38f2b)

## EX
Calculates days between consecutive hires in each department

First hire in each department shows NULL (no previous hire)

Reveals hiring patterns and gaps in recruitment

Date arithmetic automatically handles Oracle date subtraction

## Key Technical Notes:

- Window frame: PARTITION BY department creates department-specific sequences

- ORDER BY in OVER() clause determines comparison order

- Default offset of 1 compares immediate neighbors

- NULL handling shows dataset boundaries clearly


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

### Analysis:

- Calculates cumulative sum of salaries

- Ordered by employee_id for sequential accumulation

- Each row shows total salaries up to that point

- Useful for payroll budgeting and cash flow analysis
  
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
### Analysis:

- Computes multiple aggregates in single pass

- PARTITION BY creates department-specific calculations

- Shows how individual salaries compare to department metrics

- COUNT() provides workforce distribution insights

  
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

## Analysis:

- Calculates relative salary contribution

- Shows employee's share of department payroll

- Helps identify high/low impact positions

- ROUND() ensures clean percentage formatting


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
### Composite Output Analysis:

query result 4 screenshot

![4](https://github.com/user-attachments/assets/e806f763-3ddc-4697-b74f-eac5e85d9c10)

### Key Insights from All Aggregate Examples:

#### Multi-level Analysis:

Department-level vs company-wide metrics

Individual vs group comparisons

### Performance Benefits:

Single-pass calculation for multiple aggregates

More efficient than multiple subqueries

### Business Applications:

Payroll budgeting (running totals)

Compensation benchmarking (department averages)

Workforce planning (salary distributions)

### Technical Features:

-PARTITION BY for group-wise calculations

-ORDER BY for sequential processing

-Window frames for moving calculations

-Arithmetic operations within window functions


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
###  Output Analysis:

query result 5 screenshot

![5](https://github.com/user-attachments/assets/29659686-fc81-41c3-9cd0-7cec9616b4ca)

### Technical Breakdown:

#### 1.LAG() Function:

-Accesses the previous employee's salary

-Returns NULL for first record (marked as 'FIRST RECORD')

-Offset of 1 compares immediate predecessor

#### 2.LEAD() Function:

-Accesses the next employee's salary

-Returns NULL for last record (marked as 'LAST RECORD')

-Provides forward-looking comparison

#### 3.CASE Statements:

-Clear labeling of salary changes (HIGHER/LOWER/EQUAL)

-Special handling for boundary conditions

-Human-readable output format

#### 4.Sorting:

-ORDER BY employee_id ensures sequential comparison

-Maintains consistent record order

#### Business Insights:

-Identifies salary progression patterns

-Flags significant pay jumps/drops between employees

-Helps detect potential pay parity issues

-Useful for compensation benchmarking

### Common Use Cases:

#### 1.HR Analytics:

-Review salary changes across employee numbers

-Identify outlier compensation cases

### 2.Payroll Audits:

-Verify gradual salary increments

-Detect abrupt pay changes

### 3.Workforce Planning:

-Analyze compensation distribution

-Compare pay scales across departments




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
