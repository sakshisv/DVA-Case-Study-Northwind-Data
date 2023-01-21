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

select * from (SELECT a.CategoryID,  
         MAX(a.CategoryName) category, 
         SUM(c.UnitPrice) sales,
         ROW_NUMBER() OVER (PARTITION BY MAX(a.CategoryName) ORDER BY SUM(c.UnitPrice) DESC) rn
from Categories a
left join products b
on a.CategoryID = b.CategoryID
left join order_details c
on b.ProductID = c.ProductID
left join orders d
on c.OrderID = d.OrderID
left join Customers e
on d.CustomerID = e.CustomerID
group by a.CategoryID, a.CategoryName, e.Country, d.OrderDate, c.UnitPrice) g
where rn <=3
order by CategoryID

select g.CategoryName, g.Country, g.Year, g.Month, g.Count from
(select a.CategoryName, e.Country, YEAR(d.OrderDate) Year, MONTH(d.OrderDate) Month, COUNT(c.UnitPrice) Count,
ROW_NUMBER() OVER (PARTITION BY (a.CategoryName) ORDER BY SUM(c.UnitPrice) DESC) rn
from Categories a
left join products b
on a.CategoryID = b.CategoryID
left join order_details c
on b.ProductID = c.ProductID
left join orders d
on c.OrderID = d.OrderID
left join Customers e
on d.CustomerID = e.CustomerID
group by a.CategoryID, a.CategoryName, e.Country, d.OrderDate, c.UnitPrice) g
where rn <=3

-- Q3. Display the ‘N’ Most Expensive Products from the available products along with the Unit Price of each Product.



select * from order_details
select * from Categories
select * from products
select * from Customers
select * from orders