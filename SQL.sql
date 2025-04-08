use project;
create database project;


    ---- 1.No of Invoice by Accnt Exec ----
    select Account_Executive,
    count(case when income_class = 'Cross sell' then 1 end) as 'Cross Sell',
    count(case when income_class = 'New' then 1 end) as 'New',
    count(case when income_class = 'Renewal' then 1 end) as 'Renewal',
    count(invoice_number) as Number_of_invoices
    from invoice 
    group by Account_Executive
    order by Number_of_invoices desc;
    
    ----- 2.Yearly Meeting Count ------
    select right(meeting_date,4) as Year,count(meeting_date) as metting_count from meetings
    group by year 
    order by year;
    
----- 3.1.Cross sell -- Target,Ahieve,New ---
select 'cross sell' as stage,
coalesce(invoice.total_cross,0 ) as invoice,
coalesce(unified.total_cross,0)  as achievement,
coalesce(budget.Cross_sell_budget,0) as Target
from 
(select sum(Amount) as total_cross from invoice where income_class = 'Cross sell') as invoice
cross join
(select sum(Amount) as total_cross from (select income_class, sum(Amount) as Amount from brokerage group by income_class union all
select income_class, sum(Amount) as Amount from fees group by income_class) as unified
    where income_class = 'Cross sell') as unified cross join    (SELECT SUM(`Cross_sell_bugdet`) AS cross_sell_budget 
     FROM `individual budget`) AS budget;
    
 ------ 3.2.New-Target,Achive,new -----
 select 'New' as stage,
coalesce(invoice.total_new,0 ) as invoice,
coalesce(unified.total_new,0)  as achievement,
coalesce(budget.new_budget,0) as Target
from 
(select sum(Amount) as total_new from invoice where income_class = 'new') as invoice
cross join
(select sum(Amount) as total_new from (select income_class, sum(Amount) as Amount from brokerage group by income_class union all
select income_class, sum(Amount) as Amount from fees group by income_class) as unified
    where income_class = 'new') as unified cross join    (SELECT SUM(`New_budget`) AS New_budget 
     FROM `individual budget`) AS budget;
     
	----- 3.3.Renewal--Invoice,achievement,target -----
    select 'Renewal' as stage,
coalesce(invoice.total_renewal,0 ) as invoice,
coalesce(unified.total_renewal,0)  as achievement,
coalesce(budget.renewal_Budget,0) as Target
from 
(select sum(Amount) as total_renewal from invoice where income_class = 'renewal') as invoice
cross join
(select sum(Amount) as total_renewal from (select income_class, sum(Amount) as Amount from brokerage group by income_class union all
select income_class, sum(Amount) as Amount from fees group by income_class) as unified
    where income_class = 'renewal') as unified cross join    (SELECT SUM(`renewal_budget`) AS Renewal_budget
     FROM `individual budget`) AS budget;
     
      --- 4.Stage Funnel by Revenue --- 
      select stage,sum(revenue_amount) from opportunity group by stage;
      
      ---- 5.No of meeting By Account Exe ----
      select Account_Executive,count(meeting_date) as meeting_count from meetings group by Account_Executive;
      
      ----- 6.-Top Open Opportunity ----
      select opportunity_name,stage,revenue_amount from opportunity 
      where stage not in ('Negotiate')  order by revenue_amount desc ;

