-- Data Cleaning Project

select * 
from layoffs;

-- 1. Remove Duplicate
-- 2. Standardize the Data
-- 3. Null values or blank values
-- 4. Remove any column 

Create Table layoff_staging
like layoffs;

select * 
from layoff_staging;

insert layoff_staging
select *
from layoffs;

-- assigning row numbers 

select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoff_staging;


-- duplicates 

With duplicate_cte as
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoff_staging
)
Select *
from duplicate_cte
where row_num > 1
;

-- Checking if the rows selected are duplicate

Select * 
from layoff_staging
where company = 'casper';

-- creating a new table with a additional column of row_num

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select *
from layoff_staging2;

Insert into layoff_staging2
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoff_staging;

Select *
from layoff_staging2;

Delete
from layoff_staging2
where row_num > 1;

Select *
from layoff_staging2
where row_num > 1;

-- Standardizing data 

Select *
from layoff_staging2;

-- Trim

Select company, trim(company)
from layoff_staging2;

update layoff_staging2
set company = trim(company);


Select Distinct industry
from layoff_staging2
order by industry;

select *
from layoff_staging2
where industry like 'crypto%';

update layoff_staging2
set industry = 'Crypto'
where industry like 'crypto%';

Select distinct location
from layoff_staging2
order by 1;

Select distinct company
from layoff_staging2
order by company;

-- Updated Country 

Select distinct country
from layoff_staging2
order by 1;

update layoff_staging2
set country = 'United States'
where country like 'United States%';

-- Updated date

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoff_staging2;


update layoff_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

Alter Table layoff_staging2
modify column `date` Date;

-- Working with null and blank values

Select *
from layoff_staging2
where total_laid_off is Null
and percentage_laid_off is null;

Select *
from layoff_staging2
where industry is null or industry = '';

update layoff_staging2
set industry = null
where industry = '';

Select *
from layoff_staging2
where industry is null;

select * 
from layoff_staging2
where company = 'Airbnb';

select t1.industry, t2.industry 
from layoff_staging2 as t1
join layoff_staging2 as t2
	on t1.company = t2.company;

select t1.industry, t2.industry 
from layoff_staging2 as t1
join layoff_staging2 as t2
	on t1.company = t2.company
where t1.industry is null 
and t2.industry is not null;
	
Update layoff_staging2 as t1
join layoff_staging2 as t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

Select *
from layoff_staging2
where total_laid_off is Null
and percentage_laid_off is null;

Delete
from layoff_staging2
where total_laid_off is Null
and percentage_laid_off is null;

select * 
from layoff_staging2;

Alter table layoff_staging2
drop column row_num;



