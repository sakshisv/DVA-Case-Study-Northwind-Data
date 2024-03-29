--20th Jan 2023

use Northwind_data

-- Q1. What is the overall top �N� selling food categories? The output must show the category name and the count of sales done by each category.

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
--     (hint: get month and year with �month� and �year� functions).  
--     The report should display the Category name, country, year, month & count of sales done per category per country, per month per year.

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

-- Q3. Display the �N� Most Expensive Products from the available products along with the Unit Price of each Product.

create procedure q3 (@num int)
as
begin
select top(@num) ProductName, UnitPrice
from products
order by UnitPrice desc
end

exec q3 @num = 10
exec q3 @num = 4

-- Q4. Write a query that shows the Company Name, Contact Title, City, Country of all customers in any city in Mexico or other cities
--     in Spain other than the city of Madrid & Barcelona: 

select CompanyName, ContactTitle, City, Country
from Customers
where Country in ('Mexico', 'Spain') and City not in ('Madrid')

select CompanyName, ContactTitle, City, Country
from Customers
where Country in ('Mexico', 'Spain') and City != 'Barcelona'

-- Q5. Create a SQL statement that gives the following output. (hint: you may use text functions)
--     Contactinfo
--     Nancy Davolio can be reached at x5467

select concat(ContactName, ' ', 'can be reached at', ' ', 'x', Phone) ContactInfo
from Customers
--order by ContactName

--select RIGHT(Phone, CHARINDEX('-', (REVERSE(Phone)))-1) from Customers
--where Phone = '030-0074321'

-- Q6. What are the Top 3 products purchased by customers in each country?

select g.ProductName, g.Country, g.Product_Count from
(select a.ProductName, d.Country, count(a.ProductName) Product_Count,
dense_rank() over (partition by (d.Country) order by count(a.ProductName) desc ) Rank
from products a
left join order_details b
on a.ProductID = b.ProductID
left join orders c
on b.OrderID = c.OrderID
left join Customers d
on c.CustomerID = d.CustomerID
group by a.ProductName, d.Country) g
where Rank <= 3
