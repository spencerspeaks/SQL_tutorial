select *
from "account_table";

select "occurred_at"
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
