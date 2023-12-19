/* 1. Display the first promotion year for each employee. */
select first_name, last_name, min(end_date) as prom_date 
from hr.employees emp 
left join 
hr.job_history jh
on emp.employee_id = jh.employee_id
group by first_name, last_name;

/* 2. Display location, city and department name of employees who have been promoted more than
once. */

select first_name,
city,
department_name 
from hr.employees e
left join hr.departments d on e.department_id = d.department_id
left join hr.locations l on l.location_id = d.location_id
where e.employee_id in (select employee_id from hr.job_history jh
group by jh.employee_id having count(*) > 1);

/*3. Display minimum and maximum “hire_date” of employees work in IT and HR departments. */

select min(hire_date), max(hire_date), 'HR' dep from hr.employees e
where department_id = 40
union all
select min(hire_date), max(hire_date), 'IT' dep from hr.employees e
where department_id = 60;


/* 4. Find difference between current date and hire dates of employees after sorting them by hire
date, then show difference in days, months and years. */

select 
round(sysdate - hire_date, 2) as day_dif,
round(months_between (sysdate, hire_date), 2) as month_dif,
extract(year from sysdate) - extract(year from hire_date) as year_dif
from hr.employees 
order by hire_date;

/* 5. Find which departments used to hire earliest/latest. */

select 
department_id, 
min(hire_date) 
from hr.employees e
group by department_id
having min(hire_date) = (select min(hire_date) from hr.employees)

union all

select department_id, 
max(hire_date) from hr.employees e
group by department_id
having max(hire_date) = (select max(hire_date)
from hr.employees);



/* 6. Find the number of departments with no employee for each city. */

select d.department_id,
e.employee_id,
l.city 
from hr.departments d
left join hr.employees e on d.department_id = e.department_id
left join hr.locations l on d.location_id = l.location_id
where e.employee_id is null;


/* 7. Create a category called “seasons” and find in which season most employees were hired. */

select count(*),
f.fesil
from (select first_name, hire_date, case
when to_char(hire_date, 'MM') in ('01', '02', '12') then 'winter'
when to_char(hire_date, 'MM') in ('03', '04', '05') then 'spring'
when to_char(hire_date, 'MM') in ('06', '07', '08') then 'summer'
when to_char(hire_date, 'MM') in ('09', '10', '11') then 'fall'
else 'error' end fesil
from hr.employees) f
group by f.fesil;


/* 8. Find the cities of employees with average salary more than 5000. */

select l.city,
avg(salary) 
from
hr.employees e
left join hr.departments d on d.department_id = e.department_id
left join hr.locations l on l.location_id = d.location_id
group by l.city 
having avg(salary) > 5000;




########################################################################
########################################################################
########################################################################




/*1. Display last name, job title of employees who have commission percentage and belongs to
department 30. */

select e.last_name, 
j.job_title
from hr.employees e
join jobs j
on e.job_id = j.job_id
where commission_pct is not null 
and
e.department_id = 30 ;


/*2. Display department name, manager name, and salary of the manager for all managers whose
experience is more than 5 years. */

select d.department_name,
e.first_name,
e.salary,
e.hire_date
from hr.departments d 
join hr.employees e
on e.employee_id = d.manager_id
where extract(year from SYSDATE) - extract(year from  e.hire_date) > 5;


/*3. Display employee name if the employee joined before his manager. */

select e.first_name as employee,
m.first_name as manager
from hr.employees e
inner join hr.employees m
on e.manager_id = m.employee_id
where e.hire_date < m.hire_date;

/* 4. Display employee name, job title for the jobs, employee did in the past where the job was
done less than six months. */

select e.last_name, js.job_title
from employees e
inner join job_history j on e.employee_id = j.employee_id
inner join jobs js on j.job_id = js.job_id
where j.end_date - j.start_date < 6;


/* 5. Display department name, average salary and number of employees with commission within
the department. */

select
  departments.department_name,
  avg(employees.salary) as average_salary,
  count(employees.commission_pct) as commission_count
from departments
join employees on departments.department_id = employees.department_id
where employees.commission_pct is not null
group by departments.department_name ;

/* 6. Display employee name and country in which he is working. */

select first_name || ' ' || last_name 
as Employee_name, 
country_name 
from employees 
join departments 
using(department_id) 
join locations 
using( location_id) 
join countries
using ( country_id);