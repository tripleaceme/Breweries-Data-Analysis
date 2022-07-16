create database breweries;

use breweries;

rename table international_breweries to sales;

select * from sales;

alter table sales
add column month_value int default 0 after months; 

alter table sales
add column prod_price int default 0 after quantity;

alter table sales
rename column cost to total_amount;

update sales
set prod_price = (select plant_cost*quantity)
where prod_price = 0;


-- Derive the value for the new column
select months, 
			case when months like("Jan%") then 1
			when months like("Feb%") then 2 
			when months like("Mar%") then 3 
			when months like("Apr%") then 4 
			when months like("May%") then 5 
			when months like("Jun%") then 6 
			when months like("Jul%") then 7 
			when months like("Aug%") then 8 
			when months like("Sept%") then 9
			when months like("Oct%") then 10 
			when months like("Nov%") then 11 
			when months like("Dec%") then 12 end as month_v from sales;
            
-- Update the value of the new column
update sales set month_value =             
(select 
			case when months like("Jan%") then 1
			when months like("Feb%") then 2 
			when months like("Mar%") then 3 
			when months like("Apr%") then 4 
			when months like("May%") then 5 
			when months like("Jun%") then 6 
			when months like("Jul%") then 7 
			when months like("Aug%") then 8 
			when months like("Sept%") then 9
			when months like("Oct%") then 10 
			when months like("Nov%") then 11 
			when months like("Dec%") then 12 end);
            
/*
-- Analysis Questions

PROFIT ANALYSIS
1. Within the space of the last three years, what was the profit worth of the breweries, 
inclusive of the anglophone and the francophone territories?
2. Compare the total profit between these two territories in order for the territory manager, 
Mr. Stone made a strategic decision that will aid profit maximization in 2020.
3. Country that generated the highest profit in 2019
4. Help him find the year with the highest profit.
5. Which month in the three years was the least profit generated?
6. What was the profit in December 2018?
7. Compare the profit in percentage for each of the month in 2019
8. Which particular brand generated the highest profit in Senegal?
*/

-- 1.
alter table sales add column territory varchar(100) not null default 'Unknown';

update sales
set territory = 
(select case when country = 'Ghana' then 'Anglophone' 
when  country = 'Nigeria' then 'Anglophone'
when  country = 'Togo' then 'Francophone'
when  country = 'Benin' then 'Francophone'
when  country = 'Senegal' then 'Francophone' end ct)
where territory = 'Unknown';


-- Profit by Territory
select * from (
select territory, concat('$',format(sum(profit),0)) total_profit from sales group by territory
order by sum(profit) desc) d order by territory asc  ;


-- 2. Profit breakdown by country in each territory
select * from (
select * from (
select territory,country, concat('$',format(sum(profit),0)) total_profit from sales group by territory, country
order by sum(profit) desc) d order by country asc) e order by territory asc  ;





















/*

BRAND ANALYSIS
1. Within the last two years, the brand manager wants to know the top three brands consumed in the francophone countries
2. Find out the top two choices of consumer brands in Ghana
3. Find out the details of beers consumed in the past three years in the most oil reached country in West Africa.
4. Favorites malt brand in Anglophone region between 2018 and 2019
5. Which brands sold the highest in 2019 in Nigeria?
6. Favorites brand in South-South region in Nigeria
7. Bear consumption in Nigeria
8. Level of consumption of Budweiser in the regions in Nigeria
*/

/* emp_no, first_name,last_name, birth_date,hire_date, dept_name, depr_from_date,dept_to_date, total salary.*/

/*
COUNTRIES ANALYSIS
1. Country with the highest consumption of beer.
2. Highest sales personnel of Budweiser in Senegal
3. Country with the highest profit of the fourth quarter in 2019
*/




/*
-- Stored Procdures
 Create a store procedure to pull the following informations by brands, country, region, sales person, product quantity and month
*/