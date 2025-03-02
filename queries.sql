--Questiion 1
with tot_spend as (
	select customer_id, sum(amount) as tot from statements where transaction_type='Debit' group by 1
)

select customer_id from tot_spend qualify row_number() over(order by tot desc) <= 10

-----------------------------------------------------------------------------------------------------------------------------

--Question 3
with last6 as 
(
	select customer_id, sum(amount) as last6_spend from statements 
	where extract(date from transaction_date) between (select max(extract(date from transaction_date)) from statements) and 
	(select max(extract(date from transaction_date)) from statements)-180 group by 1
),

prev6 as 
(
	select customer_id, sum(amount) as prev6_spend from statements 
	where extract(date from transaction_date) between (select max(extract(date from transaction_date)) from statements)-180 
	and (select max(extract(date from transaction_date)) from statements)-360 group by 1
)

select a.customer_id from a left join last6 as a left join prev6 as b using(customer_id) 
where ((last6_spend-prev6_spend)*100)/prev6_spend>50

----------------------------------------------------------------------------------------------------------------------------

--Question4

select (count(distinct customer_id)/(select count(distinct customer_id) from statements)-1)*100 as inactive_perc from 
statements where extract(date from transaction_date)>=(select max(extract(date from transaction_date)) from statements)-180

----------------------------------------------------------------------------------------------------------------------------
--Quesiton5

with states as 
(
	select split_part(transaction_location,',',2) as state, count(DISTINCT id) as n_tran from statements group by 1
)

select state from states qualify row_number() over(order by n_tran desc)=1

with cities as 
(
	select split_part(transaction_location,',',1) as city, count(DISTINCT id) as n_tran from statements group by 1
)

select city from cities qualify row_number() over(order by n_tran desc)=1

-----------------------------------------------------------------------------------------------------------------------------

