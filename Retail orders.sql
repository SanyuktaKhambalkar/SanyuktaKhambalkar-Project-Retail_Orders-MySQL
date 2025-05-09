create database dbconnection;
use dbconnection;
drop table dbconnection.`df_orders`;

create table df_orders(
	order_id int primary key
	,order_date date
	,ship_mode varchar(20)
	,segment varchar(20)
	,country varchar(20)
	,city varchar(20)
	,state varchar(20)
	,postal_code varchar(20)
	,region varchar(20)
	,category varchar(20)
	,sub_category varchar(20)
	,product_id varchar(50)
	,quantity int
	,discount decimal(7,2)
	,sale_price decimal(7,2)
	,profit decimal(7,2));
    
 select * from df_orders;
 describe df_orders;
 
 
 
 
 # 1)find top 10 highest revenue generating products.
select product_id, sum(sale_price * quantity) as sale
from df_orders
group by product_id
order by sale desc
limit 10;




 
 
 #2) find top 5 highest selling  products in each region.
with cte as(
select region, product_id , sum(sale_price * quantity) as sales
from df_orders
group by region, product_id)
select* from (
select *, row_number() over (partition by region order by sales desc) as rn
from cte) A
where rn <= 5;

 
 
 

 #3) find month over month growth comparison for 2022 and 2023 sales eg: jan 2022 vs jan 2023
 with cte as(
 select year(order_date) as year, month(`order_date`) as month, sum(sale_price * quantity) as sales
 from df_orders
 group by month, year
 )
 select month,
	sum(case when year=2022 then sales else 0 end) as sales_2022,
    sum(case when year=2023 then sales else 0 end) as sales_2023
from cte
group by month
order by month;





#4)find for each category which month had highest sales
with cte as (
select category, date_format(order_date,'%Y-%m') as order_year_month, sum(sale_price*quantity) as sales
from df_orders
group by category, order_year_month
)
select* from (
select *, row_number() over (partition by category order by sales desc) as rn
from cte) A
where rn = 1;


 
 
 

 #5) which subcategory had highest growth by profit in 2023 compare to 2022
 
  with cte as(
 select sub_category, sum(profit) as total_profit , year(order_date) as year
 from df_orders
 group by sub_category, year
  ),
  cte2 as(
 select sub_category,
	sum(case when year=2022 then total_profit else 0 end) as total_profit_2022,
    sum(case when year=2023 then total_profit else 0 end) as total_profit_2023
from cte
group by  sub_category)
select *, (total_profit_2023-total_profit_2022) as profit_growth
from cte2
order by (total_profit_2023-total_profit_2022) desc
limit 1 ;
 
 
