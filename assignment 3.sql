select * from luxdevteaching.customers;
select * from luxdevteaching.books;
select * from luxdevteaching.orders;

--SQL ASSIGNMENT
--list customers with their full name and city
select concat(first_name ,' ',last_name) as full_name,city 
from luxdevteaching.customers;

--show all books priced above 2000
select * from luxdevteaching.books 
where price > 2000;

--list customers who live in nairobi
select first_name,last_name,city 
from luxdevteaching.customers
where city = 'Nairobi';

--retrieve all book titles that were published in 2023
select title 
from luxdevteaching.books
where extract (year from published_date) ='2023';

--show all orders placed after march 1 st 2025
select * from luxdevteaching.orders
where order_date >'2025-03-01';

--list all books ordered ,sorted by price (descending)
select distinct title,price from luxdevteaching.books 
join luxdevteaching.orders on luxdevteaching.books.book_id=luxdevteaching.orders.book_id 
order by price desc ;

--show all customers whose names start with 'J'
select * from luxdevteaching.customers 
where first_name like 'J%';

--list books with prices between 1500 and 3000
select * from luxdevteaching.books 
where price between 1500 and 3000;

--count the number of customers in each city
select count(*) as customer_count , city
from luxdevteaching.customers 
group by city ;

--show the total number of orders per customer
select count(*) as total_orders , customer_id
from luxdevteaching.orders 
group by customer_id;

--find the average price of books in the store
select avg(price) as average_price
from luxdevteaching.books ;

--list the book title and total quantity ordered for each book
select sum (quantities) as total_quantity ,title
from luxdevteaching.books 
join luxdevteaching.orders on luxdevteaching.orders.book_id = luxdevteaching.books.book_id
group by title;

--Show customers who have placed more orders than customer with ID = 1.
select customer_id,first_name,last_name
from luxdevteaching.customers 
where customer_id in (
select customer_id 
from luxdevteaching.orders 
group by customer_id 
having count (*)> (
select count (*)
from luxdevteaching.orders
where customer_id= 1)
);

-- List books that are more expensive than the average book price
select title, price
from luxdevteaching.books
where price >(select avg(price)from luxdevteaching.books);

--Show each customer and the number of orders they placed using a subquery in SELECT.
select concat(first_name ,' ',last_name) as full_name,
(select count (*) from luxdevteaching.orders
where luxdevteaching.customers.customer_id=luxdevteaching.orders.customer_id) as total_orders
from luxdevteaching.customers;

--Show full name of each customer and the titles of books they ordered
select concat (first_name ,' ',last_name) as full_name,title
from luxdevteaching.customers 
inner join luxdevteaching.orders on luxdevteaching.customers.customer_id = luxdevteaching.orders.customer_id
inner join luxdevteaching.books on luxdevteaching.books.book_id = luxdevteaching.orders.book_id;

--. List all orders including book title, quantity, and total cost (price × quantity).
select order_id,title,quantities,(price* quantities) as total_cost
from luxdevteaching.orders 
inner join luxdevteaching.books on luxdevteaching.books.book_id = luxdevteaching.orders.book_id;

--Show customers who haven't placed any orders (LEFT JOIN).
select concat (first_name ,' ',last_name) as full_name
from luxdevteaching.customers 
left join luxdevteaching.orders on luxdevteaching.customers.customer_id = luxdevteaching.orders.customer_id
where order_id is null;

--List all books and the names of customers who ordered them, if any (LEFT JOIN).
select concat (first_name ,' ',last_name) as full_name,title
from luxdevteaching.books 
left join luxdevteaching.orders on luxdevteaching.books.book_id = luxdevteaching.orders.book_id
left join luxdevteaching.customers on luxdevteaching.orders.customer_id = luxdevteaching.customers.customer_id;

--Show customers who live in the same city (SELF JOIN).
select A.first_name as customer1, B.first_name as customer2,a.city
from luxdevteaching.customers  A 
join luxdevteaching.customers B on a.city =b.city and a.customer_id != b.customer_id;

--. Show all customers who placed more than 2 orders for books priced over 2000.
select concat (first_name ,' ',last_name) as full_name
from luxdevteaching.customers 
join luxdevteaching.orders on luxdevteaching.customers.customer_id = luxdevteaching.orders.customer_id
join luxdevteaching.books on luxdevteaching.orders.book_id = luxdevteaching.books.book_id
where price > 2000
group by luxdevteaching.customers.customer_id 
having count (luxdevteaching.orders.order_id) > 2;


--List customers who ordered the same book more than once.
select concat (first_name ,' ',last_name) as full_name  
from luxdevteaching.orders 
join  luxdevteaching.customers on luxdevteaching.orders.customer_id = luxdevteaching.customers.customer_id
Join luxdevteaching.books on luxdevteaching.orders.book_id = luxdevteaching.books.book_id
GROUP BY luxdevteaching.orders.customer_id, luxdevteaching.orders.book_id,luxdevteaching.customers.first_name,luxdevteaching.customers.last_name
HAVING COUNT(*) > 1;

--Show each customer's full name, total quantity of books ordered, and total amount spent.
select concat (first_name ,' ',last_name) as full_name,sum(quantities) as total_quantity ,sum (quantities*price) as total_spent
from luxdevteaching.customers 
join luxdevteaching.orders on luxdevteaching.customers.customer_id = luxdevteaching.orders.customer_id
join luxdevteaching.books on luxdevteaching.orders.book_id = luxdevteaching.books.book_id
group by luxdevteaching.customers.customer_id;

-- List books that have never been ordered
select title 
from luxdevteaching.books 
left join luxdevteaching.orders on luxdevteaching.books.book_id = luxdevteaching.orders.book_id
where luxdevteaching.orders.book_id is null;

--. Find the customer who has spent the most in total (JOIN + GROUP BY + ORDER BY + LIMIT)
select concat (first_name ,' ',last_name) as full_name, sum (quantities*price) as total_spent
from luxdevteaching.customers 
join luxdevteaching.orders on luxdevteaching.customers.customer_id = luxdevteaching.orders.customer_id
join luxdevteaching.books on luxdevteaching.orders.book_id = luxdevteaching.books.book_id
group by luxdevteaching.customers.customer_id 
order by total_spent desc
limit 1;

--. Write a query that shows, for each book, the number of different customers who have ordered it
select count (distinct customer_id) as unique_customers,title
from luxdevteaching.books 
join luxdevteaching.orders on luxdevteaching.books.book_id = luxdevteaching.orders.book_id
group by luxdevteaching.books.book_id;

--. Using a subquery, list books whose total order quantity is above the average order quantity
select title 
from luxdevteaching.books 
where book_id IN (
    select book_id
    from luxdevteaching.orders
    group by  book_id
    having sum(quantities) > (
        select avg(total_quantity)
        from (
            select sum(quantities) AS total_quantity
            from luxdevteaching.orders
            group by book_id
        ) as subquery
    )
);

--. Show the top 3 customers with the highest number of orders and the total amount they spent.
select concat (first_name ,' ',last_name) as full_name,count(order_id)as total_orders,sum(quantities*price) as total_spent
from luxdevteaching.customers
join luxdevteaching.orders on luxdevteaching.customers.customer_id = luxdevteaching.orders.customer_id
join luxdevteaching.books on luxdevteaching.orders.book_id = luxdevteaching.books.book_id
group by luxdevteaching.customers.customer_id 
order by total_orders desc
limit 3;





