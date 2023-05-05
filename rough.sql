select account_table.id, account_table.name, orders_table.total, orders_table.account_id, web_events.account_id, web_events.occurred_at, sales_rep.name
from account_table
join orders_table
on account_table.id = orders_table.account_id
join web_events
on account_table.id = web_events.account_id
join sales_rep
on account_table.primary_poc = salesrep.name
group by account_table.id, account_table.name, orders_table.total, orders_table.account_id, web_events.account_id, web_events.occurred_at, sales_rep.name 
