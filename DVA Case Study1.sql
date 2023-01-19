--20th Jan 2023

use Northwind_data

-- Q1. What is the overall top ‘N’ selling food categories? The output must show the category name and the count of sales done by each category.

create procedure q1 (@num int)
as
begin
select top(@num) a.CategoryName, count(c.UnitPrice) 'Count'
from Categories a
left join products b
on a.CategoryID = b.CategoryID
left join order_details c
on b.ProductID = c.ProductID
group by a.CategoryName
end

exec q1 @num = 3

-- Q2. Write a query that produces a report of sales by month for all the top 3 categories.
-- (hint: get month and year with “month” and “year” functions).  
-- The report should display the Category name, country, year, month & count of sales done per category per country, per month per year.



select * from order_details
select * from Categories
select * from products