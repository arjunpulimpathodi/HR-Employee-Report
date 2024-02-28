CREATE DATABASE projects;
USE projects;

SELECT * FROM hr;

ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

SELECT * FROM hr;

DESCRIBE hr;
SELECT birthdate FROM hr;
SET sql_safe_updates=0;
UPDATE hr 
SET birthdate = CASE 
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
    WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
    ELSE NULL
END;
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;
SELECT birthdate FROM hr;

UPDATE hr 
SET hire_date = CASE 
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
    WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
    ELSE NULL
END;
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;
SELECT hire_date FROM hr;

SELECT termdate FROM hr;
UPDATE hr
SET termdate = NULL
WHERE termdate = '';

UPDATE hr
SET termdate = NULL
WHERE termdate = '';

UPDATE hr
SET termdate = DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s'))
WHERE termdate IS NOT NULL;
ALTER TABLE hr
MODIFY COLUMN termdate DATE;
SELECT termdate FROM hr;
describe hr;

ALTER TABLE hr ADD COLUMN age INT;
SELECT * FROM hr; 

UPDATE hr 
SET age = timestampdiff(YEAR,birthdate,CURDATE());
SELECT birthdate,age FROM hr;

SELECT 
	MIN(age) AS youngest,
    MAX(age) AS oldest
FROM hr;

SELECT count(*) 
FROM hr
WHERE age<18;


-- The Analysis of Data Set
-- 1. Gender Breakdown

select gender, count(*) AS count
FROM hr
group by gender;

-- 2. Ethinicity

select race, count(*) AS count
FROM hr
group by race
order by count(*) desc;

-- 3. Age Distribution
select
	min(age) as youngest,
    max(age) as oldest
from hr;

select 
	case
		when age>=18 and age<=24 then '18-24'
        when age>=25 and age<=34 then '25-34'
        when age>=35 and age<=44 then '35-44'
        when age>=45 and age<=54 then '45-54'
        when age>=55 and age<=64 then '55-64'
        else '65+'
	end as age_group,
    count(*) as count
from hr
group by age_group
order by age_group;

select 
	case
		when age>=18 and age<=24 then '18-24'
        when age>=25 and age<=34 then '25-34'
        when age>=35 and age<=44 then '35-44'
        when age>=45 and age<=54 then '45-54'
        when age>=55 and age<=64 then '55-64'
        else '65+'
	end as age_group,gender,
    count(*) as count
from hr
group by age_group,gender
order by age_group,gender;

-- 4. Work Location
select location, count(*) as count
from hr
group by location;

-- 5. average length of employment 
select
	round(avg(datediff(termdate,hire_date))/365) as avg_length_employment
    from hr;
    
-- 6. gender distribution across various jobs and departments
select department,gender,count(*) as count
from hr
group by department,gender
order by department;

-- 7. distribution of job titles
select jobtitle,count(*) as count 
from hr
group by jobtitle
order by jobtitle desc;

-- 8 department turn over rate
SELECT 
    department,
    total_count,
    terminated_count,
    terminated_count / total_count AS termination_rate
FROM (
    SELECT 
        department,
        COUNT(*) AS total_count,
        SUM(CASE WHEN termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
    FROM 
        hr
    GROUP BY 
        department
) AS subquery
ORDER BY 
    termination_rate DESC;
    
-- 9. distribution of employees across locations by city and state

select location_state, count(*) as count
from hr
group by location_state
order by count desc;

-- 10. employee count changing over time based on hire and term dates
select
	year,
    hires,
    terminations,
    hires-terminations as net_change,
    round((hires-terminations)/hires*100,2) as net_change_percent
from (
		select year (hire_date) as year,
        count(*) as hires,
        sum(case when termdate <= curdate() then 1 else 0 end) as terminations
        from hr
        where age>=1
        group by year(hire_date)
        ) as subquery
order by year asc;

-- 11. tenure distribution of each dept
select department, round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from hr
where termdate<=curdate()
group by department;






