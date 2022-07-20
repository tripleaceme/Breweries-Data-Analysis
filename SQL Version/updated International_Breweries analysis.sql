use brewries;
select * from sales;
select * from countries;

/* 1. Within the space of the last three years, what was the profit worth of the breweries, 
inclusive of the anglophone and the francophone territories?*/
select years, concat('$ ', format(sum(profit),2) ) profit
from sales
group by years;
/* 2. Compare the total profit between these two territories in order for the territory manager, 
Mr. Stone made a strategic decision that will aid profit maximization in 2020.*/
-- add territory column to the sales table
alter table sales add column territory_id int not null after region_id;
alter table sales add foreign key (territory_id) references territory(territory_id) on delete cascade;

create table if not exists territory(
territory_id int not null primary key,
territory_name varchar(255) not null
);
-- 2017
select territory_name, concat('$', format(sum(profit),2)) profit, years
from sales s join territory t using (territory_id)
where years =  2017
group by territory_name;

-- 2018
select territory_name, concat('$', format(sum(profit),2)) profit, years
from sales s join territory t using (territory_id)
where years =  2018
group by territory_name;

-- 2019
select territory_name, concat('$', format(sum(profit),2)) profit, years
from sales s join territory t using (territory_id)
where years =  2019
group by territory_name;

-- 3. Country that generated the highest profit in 2019
select country_name, concat('$', format(sum(profit),2)) profit
from sales join countries using(country_id)
where years = 2019
group by country_name
order by sum(profit) desc limit 1 ;
-- 4. Help him find the year with the highest profit.
select years, concat('$', format(sum(profit),2)) profit
from sales
group by years
order by sum(profit) desc limit 1;

-- 5. Which month in the three years was the least profit generated?
select * from
(
(select month, concat('$', format(sum(profit),2)) profit, years from sales
where years = 2017
group by month)
union all
(
select month, concat('$', format(sum(profit),2)) profit, years from sales
where years = 2018
group by month
)
union all
(
select month, concat('$', format(sum(profit),2)) profit, years from sales
where years = 2019
group by month
)
) a
order by profit asc limit 1;

-- 6. What was the profit in December 2018?
SELECT 
    month, years, CONCAT('$', FORMAT(SUM(profit), 2)) profit
FROM
    sales
WHERE
    month = 'december' AND years = 2018;
    
    -- 7. Compare the profit in percentage for each of the month in 2019
    set @total_profit =     (
    select sum(first_profit) t_profit
    from
    (select month, years, profit, sum(profit) first_profit from sales where years = 2019
    group by month
    order by month asc
    )b
    );
    
    select @total_profit;
    
    select month, sum(profit), ((sum(profit)/@total_profit)*100) percentage_profit from sales
    where years = 2019
    group by month 
    order by ((sum(profit)/@total_profit)*100) desc;
    
    -- 8. Which particular brand generated the highest profit in Senegal?
select brand_name, concat('$ ',format(sum(profit),2)) profit from
 sales join brand using (brand_id) join countries using(country_id)
 where country_name = 'senegal'
 group by brand_name;
 
 -- BRAND ANALYSIS
 -- 1. Within the last two years, the brand manager wants to know the top three brands consumed in the francophone countries
select brand_name, sum(quantity)
from sales join brand using(brand_id) join territory using (territory_id)
where territory_name = 'francophone' and years in (2018, 2019)
group by brand_name
order by 2 desc limit 3;

-- 2.Find out the top two choices of consumer brands in Ghana
select brand_name, sum(quantity)
from sales join brand using(brand_id) join countries using (country_id)
where country_name = 'Ghana'
group by brand_name
order by sum(quantity) desc limit 2;

select * from brand;

-- 3. Find out the details of beers consumed in the past three years in the most oil reached country in West Africa.
select brand_name,  concat('$ ', format(sum(profit),2)) profit, sum(quantity) t_quantity
from sales join brand using(brand_id) join countries using(country_id)
where country_name =  'Nigeria' and brand_name not in ('grand malt', 'beta malt')
group by brand_name;

-- 4. Favorites malt brand in Anglophone region between 2018 and 2019
select brand_name, sum(quantity)
from sales join brand using(brand_id) join territory using(territory_id)
where territory_name = 'anglophone' and years in(2018,2019) and brand_name in ('grand malt', 'beta malt')
group by brand_name
order by sum(quantity) desc limit 1;

-- 5. Which brands sold the highest in 2019 in Nigeria?
select brand_name, sum(quantity) total_quantity from
sales join brand using (brand_id)
where years = 2019 AND COUNTRY_ID = 2
group by brand_name 
order by 2 desc limit 1;

-- 6. Favorites brand in South-South region in Nigeria
select brand_name, sum(quantity) total_quantity from
sales join brand using (brand_id) join region using (region_id)
where region_name = 'southsouth' and country_id = 2
group by brand_name 
order by 2 desc limit 1;
-- 7. Beer consumption in Nigeria

select brand_name, sum(quantity) quantity
from sales join brand using(brand_id) join countries using (country_id)
where country_name = 'nigeria' and brand_name not in ('grand malt', 'beta malt')
group by brand_name;

-- 8 Level of consumption of Budweiser in the regions in Nigeria
select sum(quantity) quantity, region_name from sales join brand using (brand_id)
join region using (region_id) join countries using (country_id)
where country_name = 'nigeria' and brand_name = 'budweiser'
group by region_name;
/*
COUNTRIES ANALYSIS
1. Country with the highest consumption of beer.
2. Highest sales personnel of Budweiser in Senegal
3. Country with the highest profit of the fourth quarter in 2019
*/
-- 1. Country with the highest consumption of beer.
select sum(quantity) quantity, country_name from
sales join brand using (brand_id) join countries using (country_id)
where brand_name not in ('grand malt', 'beta malt')
group by country_name
order by 1 desc limit 1;

-- 2. Highest sales personnel of Budweiser in Senegal
select sum(quantity) , salesrep_name
from sales join brand using (brand_id) join countries using (country_id) join sales_rep using (salesrep_id)
where brand_name = 'budweiser' and country_name = 'senegal'
group by salesrep_id
order by 1 desc limit 1;

-- 3. Country with the highest profit of the fourth quarter in 2019
select country_name , concat('$ ',format(sum(profit),2)) profit
 from sales join countries using (country_id)
 where month in ('october', 'november','december') and years = 2019
 group by country_name 
 order by sum(profit) desc limit 1;