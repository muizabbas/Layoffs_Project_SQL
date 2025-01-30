-- Exploratory Data Analysis (EDA) Project

-- Max and Min

select max(total_laid_off), max(percentage_laid_off)
from layoff_staging2;

select *
from layoff_staging2
where percentage_laid_off = 1;

-- Sum of total laid off by company

Select company, sum(total_laid_off) as sum_t_laidoff
from layoff_staging2
group by company
order by sum_t_laidoff desc;

-- Timeline

Select min(`date`), max(`date`)
from layoff_staging2;

-- Sum of total laid off by industry

Select industry, sum(total_laid_off) as sum_t_laidoff
from layoff_staging2
group by industry
order by sum_t_laidoff desc;


-- Sum of total laid off by country

Select country, sum(total_laid_off) as sum_t_laidoff
from layoff_staging2
group by country
order by sum_t_laidoff desc;

-- Sum of total laid off by year

Select Year(`date`), sum(total_laid_off) as sum_t_laidoff
from layoff_staging2
group by Year(`date`)
order by sum_t_laidoff desc;


-- Sum of total laid off by stage

Select stage, sum(total_laid_off) as sum_t_laidoff
from layoff_staging2
group by stage
order by sum_t_laidoff desc;

-- Sum of total laid off by month

select substring(`date`, 1, 7) as months, sum(total_laid_off)
from layoff_staging2
where substring(`date`, 1, 7) is not null
group by months
order by months;

-- Rolling total monthly 

with roll_total as 
(
select substring(`date`, 1, 7) as months, sum(total_laid_off) as sum_t_laidoff
from layoff_staging2
where substring(`date`, 1, 7) is not null
group by months
order by months
)
Select months, sum_t_laidoff, sum(sum_t_laidoff) over(order by `months`) as rolling_total
from roll_total;

select * 
from layoff_staging2;

-- Yearly total

Select Year(`date`), sum(total_laid_off) as sum_t_laidoff
from layoff_staging2
where year(`date`) is not null
group by Year(`date`)
order by Year(`date`) desc;

-- Rolling total yearly 

With rolling_y_total as
(
Select Year(`date`) as y_date, sum(total_laid_off) as sum_t_laidoff
from layoff_staging2
where year(`date`) is not null
group by Year(`date`)
order by Year(`date`) desc
)
Select y_date, sum_t_laidoff, sum(sum_t_laidoff) over(order by y_date) as rolling_yearly_total
from rolling_y_total;

select company, sum(total_laid_off) as sum_t_laidoff
from layoff_staging2
group by company
order by 2 desc;

-- Sum of total laid off by company and year

select company, year(`date`) as y_date, sum(total_laid_off) as sum_t_laidoff
from layoff_staging2
group by company, y_date
order by company;

-- Adding rank

with company_year as 
(
select company, year(`date`) as y_date, sum(total_laid_off) as sum_t_laidoff
from layoff_staging2
group by company, y_date
)
Select *, dense_rank() over(partition by y_date order by sum_t_laidoff desc) as ranking 
from company_year
where y_date is not null
order by ranking  asc;

-- Filter top 5

with company_year as 
(
select company, year(`date`) as y_date, sum(total_laid_off) as sum_t_laidoff
from layoff_staging2
group by company, y_date
), Company_year_rank as
(
Select *, dense_rank() over(partition by y_date order by sum_t_laidoff desc) as ranking 
from company_year
where y_date is not null
)
Select *
from Company_year_rank
where ranking <= 5
order by ranking
;



