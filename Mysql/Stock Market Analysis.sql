-- Create the Assignment schema 

create schema stock_Price;
use stock_Price;

create table bajaj(date varchar(15),close_price float);
create table Eicher(date varchar(15),close_price float);
create table Hero(date varchar(15),close_price float);
create table Infosys(date varchar(15),close_price float);
create table TCS(date varchar(15),close_price float);
create table TVS(date varchar(15),close_price float);


-- Task-1
--  Create table with moving verage for 20 and 50 days--    

create table bajaj1 as
select str_to_date(date, "%d-%M-%Y")as date, close_price, 
avg(close_price) over (order by str_to_date(date,"%d-%M-%Y") rows between 19 preceding and current row) as `20 Day MA`,
avg(close_price) over (order by str_to_date(date,"%d-%M-%Y") rows between 49 preceding and current row) as `50 Day MA`
from bajaj;

create table eicher1
as
select str_to_date(date,"%d-%M-%Y") as Date, close_price,
avg(close_price) over (order by str_to_date(date,"%d-%M-%Y") rows between 19 preceding and current row) as `20 Day MA`,
avg(close_price) over (order by str_to_date(date,"%d-%M-%Y") rows between 49 preceding and current row) as `50 Day MA`
from eicher;

create table hero1
as
select str_to_date(date,"%d-%M-%Y") as Date, close_price,
avg(close_price) over (order by str_to_date(date,"%d-%M-%Y") rows between 19 preceding and current row) as `20 Day MA`,
avg(close_price) over (order by str_to_date(date,"%d-%M-%Y") rows between 49 preceding and current row) as `50 Day MA`
from hero;

create table infosys1
as
select str_to_date(date,"%d-%M-%Y") as Date, close_price,
avg(close_price) over (order by str_to_date(date,"%d-%M-%Y") rows between 19 preceding and current row) as `20 Day MA`,
avg(close_price) over (order by str_to_date(date,"%d-%M-%Y") rows between 49 preceding and current row) as `50 Day MA`
from infosys;

create table TCS1
as
select str_to_date(date,"%d-%M-%Y") as Date, close_price,
avg(close_price) over (order by str_to_date(date,"%d-%M-%Y") rows between 19 preceding and current row) as `20 Day MA`,
avg(close_price) over (order by str_to_date(date,"%d-%M-%Y") rows between 49 preceding and current row) as `50 Day MA`
from TCS;


create table TVS1
as
select str_to_date(date,"%d-%M-%Y") as Date, close_price,
avg(close_price) over (order by str_to_date(date,"%d-%M-%Y") rows between 19 preceding and current row) as `20 Day MA`,
avg(close_price) over (order by str_to_date(date,"%d-%M-%Y") rows between 49 preceding and current row) as `50 Day MA`
from TVS;




-- Task-2
-- Creating Master Table

create table Master_Table as 
select b.date as Date, 
b.Close_Price as Bajaj, 
tc.Close_Price as TCS,
tv.Close_Price as TVS,
i.Close_Price as Infosys,
e.Close_Price as Eicher,
h.Close_Price as Hero
from bajaj1 b 
inner join tcs1 tc on tc.date = b.date
inner join tvs1 tv on tv.date = tc.date
inner join infosys1 i on i.date = tv.date
inner join eicher1 e on e.date = i.date
inner join hero1 h on h.date = e.date; 

select * from master_table;






-- Task-3
-- Create Table For Generating Sell and Buy Signal

create table bajaj2 as 
SELECT Date, Close_Price,
case 
        WHEN `20 Day MA` > `50 Day MA` AND LAG(`20 Day MA`) over() < LAG(`50 Day MA`) over() THEN 'BUY'
		WHEN `20 Day MA` < `50 Day MA` AND LAG(`20 Day MA`) over() > LAG(`50 Day MA`) over() THEN 'SELL'
		ELSE 'HOLD' 
end as 'Signal'
FROM bajaj1; 


create table eicher2 as 
SELECT Date, Close_Price,
case 
        WHEN `20 Day MA` > `50 Day MA` AND LAG(`20 Day MA`) over() < LAG(`50 Day MA`) over() THEN 'BUY'
		WHEN `20 Day MA` < `50 Day MA` AND LAG(`20 Day MA`) over() > LAG(`50 Day MA`) over() THEN 'SELL'
		ELSE 'HOLD' 
end as 'Signal'
FROM eicher1; 


create table hero2 as 
SELECT Date, Close_Price,
case 
        WHEN `20 Day MA` > `50 Day MA` AND LAG(`20 Day MA`) over() < LAG(`50 Day MA`) over() THEN 'BUY'
		WHEN `20 Day MA` < `50 Day MA` AND LAG(`20 Day MA`) over() > LAG(`50 Day MA`) over() THEN 'SELL'
		ELSE 'HOLD' 
end as 'Signal'
FROM hero1; 


create table infosys2 as 
SELECT Date, Close_Price,
case 
        WHEN `20 Day MA` > `50 Day MA` AND LAG(`20 Day MA`) over() < LAG(`50 Day MA`) over() THEN 'BUY'
		WHEN `20 Day MA` < `50 Day MA` AND LAG(`20 Day MA`) over() > LAG(`50 Day MA`) over() THEN 'SELL'
		ELSE 'HOLD' 
end as 'Signal'
FROM infosys1; 


create table tcs2 as 
SELECT Date, Close_Price,
case 
        WHEN `20 Day MA` > `50 Day MA` AND LAG(`20 Day MA`) over() < LAG(`50 Day MA`) over() THEN 'BUY'
		WHEN `20 Day MA` < `50 Day MA` AND LAG(`20 Day MA`) over() > LAG(`50 Day MA`) over() THEN 'SELL'
		ELSE 'HOLD' 
end as 'Signal'
FROM tcs1; 


create table tvs2 as 
SELECT Date, Close_Price,
case 
        WHEN `20 Day MA` > `50 Day MA` AND LAG(`20 Day MA`) over() < LAG(`50 Day MA`) over() THEN 'BUY'
		WHEN `20 Day MA` < `50 Day MA` AND LAG(`20 Day MA`) over() > LAG(`50 Day MA`) over() THEN 'SELL'
		ELSE 'HOLD' 
end as 'Signal'
FROM tvs1; 



-- Task-4
-- User Defined Function for geting signal for bajaj2 table
delimiter $$
create function signal_of_day ( given_date varchar(10) )
returns varchar(4)
deterministic
begin
declare signal_value varchar(4);
select `Signal` into signal_value from bajaj2 where date=STR_TO_DATE(given_date, "%Y-%m-%d");
return signal_value;
end$$ 
delimiter ;

select signal_of_day ('2015-05-18') as `Signal`; -- Buy
select signal_of_day ('2015-08-24') as `Signal`; -- Sell
select signal_of_day ('2015-10-12') as `Signal`; -- Hold
