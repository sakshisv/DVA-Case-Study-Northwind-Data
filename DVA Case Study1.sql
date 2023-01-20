--20th Jan 2023

use Northwind_data

-- Q1. What is the overall top ‘N’ selling food categories? The output must show the category name and the count of sales done by each category.

create procedure q1 (@num int)
as
begin
select top(@num) a.CategoryName, count(b.UnitPrice) 'Count'
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


--select g.CategoryName, g.Country, g.Year, g.Month, g.Count from
--(
select a.CategoryName, e.Country, YEAR(d.OrderDate) 'Year', MONTH(d.OrderDate) 'Month', count(c.UnitPrice) 'Count',
ROW_NUMBER() over (partition by a.CategoryName order by e.Country ASC) 'Rank'
from Categories a
left join products b
on a.CategoryID = b.CategoryID
left join order_details c
on b.ProductID = c.ProductID
left join orders d
on c.OrderID = d.OrderID
left join Customers e
on d.CustomerID = e.CustomerID
group by a.CategoryName, e.Country, d.OrderDate
--where Rank = 3



select * from order_details
select * from Categories
select * from products
select * from Customers
select * from orders