select *
from "account_table";

select *
from "orders_table";

select *
from "sales_rep";

select *
from web_events;

select *
from regions_table;



select *
from "account_table" "acct_table"
join "orders_table" "ord_table"
on acct_table.id = ord_table.account_id
join "sales_rep" "sales_table"
on acct_table.sales_rep = sales_table.id
join "regions_table" "reg_table"
on sales_table.region_id = reg_table.id
join "web_events" "web_table"
on acct_table.id = web_table.id;



------
-- Companies that made the highest total sales in the last three years ----
-- Which channel generated the least total_amt_usd and in what year
-- POC responsible for highest direct sales and what companies did they sell for
-- in 2017 what day made the highest sales and which company had the sales 



-- Companies that made the highest total sales in the last five years ----

select distinct("occurred_at")
from "orders_table";

select distinct("year_info") 
from
(select EXTRACT(YEAR FROM "occurred_at") as "year_info"
from "orders_table") as "table_one";


select *
from 
(select *, EXTRACT(YEAR FROM "occurred_at") as "year_info"
from "orders_table") as "t1"
where "year_info" in ('2017', '2016', '2015');



select *
from 
(select *, EXTRACT(YEAR FROM "occurred_at") as "year_info"
from "orders_table") as "t1"
where "year_info" >= '2015' and "year_info" <= '2017';

----- Answer to question ------------------
select "company_name", "year_info", sum("total_sales") as "highest_sales"
from

(select *, extract(YEAR from "date_data") as "year_info"
from
(select acct_table.name as "company_name", ord_table.occurred_at as "date_data",
ord_table.total_amt_usd as "total_sales"
from "account_table" "acct_table"
join "orders_table" "ord_table"
on acct_table.id = ord_table.account_id) as "table_one") as "table_two"

where "year_info" >= 2015 and "year_info" <= 2017
group by "company_name", "year_info"
order by "highest_sales" desc;
-------------------------



select *,
case when "MONTH_info" = 1 then 'jan'
     when "MONTH_info" = 2 then 'feb'
	 when "MONTH_info"  = 3 then 'march'
	else 'Dec' end as "Months"
from
(select EXTRACT(MONTH FROM "occurred_at") as "MONTH_info"
from "orders_table") as "table_one";


select *, EXTRACT(DOW FROM "occurred_at") as "week_day"
from "orders_table";


select acct_table.name, ord_table.occurred_at, ord_table.total_amt_usd 
from "account_table" "acct_table"
join "orders_table" "ord_table"
on acct_table.id = ord_table.account_id
where ord_table.occurred_at between '2016-01-01' and '2016-12-26'
group by acct_table.name, ord_table.occurred_at, ord_table.total_amt_usd



----- Which channel generated the least total_amt_usd and in what year

select *
from "orders_table" "ord_table"
join "web_events" "web_table"
on ord_table.account_id = web_table.account_id


select distinct ("years") as "year_info"
from
(select *, extract (year from "occurred_at") as "years"
from "web_events") as "table_one"


select "web_channel", "year_info", sum("total_amt") as "amount_gen"
from
(select *, extract (year from "date_info") as "year_info"
from
(select ord_table.total_amt_usd as "total_amt", web_table.channel as "web_channel", 
 web_table.occurred_at as "date_info"
from "orders_table" "ord_table"
join "web_events" "web_table"
on ord_table.account_id = web_table.account_id) as table_one) as table_two
 where "year_info" >= 2015 and  "year_info" <= 2017
group by "web_channel", "year_info"
order by "amount_gen" asc; 

-- POC responsible for highest direct sales and what companies did they sell for

select "primary_contact", "company_name", sum(highest_sales) as "HDS" 
from
(select acct_table.primary_poc as "primary_contact", acct_table.name as "company_name",
ord_table.total_amt_usd as "highest_sales"
from "account_table" "acct_table" 
join "orders_table" "ord_table"
on acct_table.id = ord_table.account_id) as table_one
group by "primary_contact", "company_name"
order by "HDS" desc;



-- in 2017 what day made the highest sales and which company had the sales
select "day_info", "company_name", sum("sales_total") as "sum_sales"
from
(select *, extract (dow from "occured_at") as "day_info"
from
(select *, extract (year from "occured_at") as "year_info"
from
(select o.total_amt_usd "sales_total", a.name "company_name", o.occurred_at "occured_at"
from "orders_table" o
join "account_table" a
on o.account_id = a.id) as "table_one") as "table_two") as "table_three"
where "year_info" = 2016
group by "day_info", "company_name"
order by "sum_sales" desc;