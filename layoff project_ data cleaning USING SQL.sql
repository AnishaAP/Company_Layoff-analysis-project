select * from layoffs;

#CREATING A DUMMY TABLE


Create table layoff_clean
LIKE layoffs;
INSERT layoff_clean
select * from layoffs;
select * from layoff_clean;
 
 
#TO REMOVE DUPLICATES USING CTE

WITH duplicate AS(
select *,
ROW_NUMBER() OVER(PARTITION BY company, location,industry,
 total_laid_off,percentage_laid_off,`date`,stage,country,
funds_raised_millions) AS Row_num
FROM layoff_clean
)
select * from duplicate WHERE Row_num>1;
CREATE TABLE `layoff_staging` (
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

select * from layoff_staging;

INSERT INTO layoff_staging
select *,
ROW_NUMBER() OVER(PARTITION BY company, location,industry,
 total_laid_off,percentage_laid_off,`date`,stage,country,
funds_raised_millions) AS Row_num
FROM layoff_clean;

DELETE 
FROM layoff_staging
WHERE row_num>1;
select * 
from layoff_staging 
where row_num>1;


#STANDARDIZING THE DATA

select industry
 from layoff_staging
group by industry;
select * from layoff_staging
 where industry LIKE "Crypto%";
 
 UPDATE layoff_staging
 SET industry = "Crypto"
 WHERE industry LIKE "Crypto%";
 
select DISTINCT country
from layoff_staging
group by 1;

UPDATE layoff_staging
 SET country = "United States"
 WHERE country LIKE "United States%";


#DEALING WITH NULL VALUES AND BLANK SPACES


select * FROM layoff_staging 
where industry IS NULL 
OR industry = ''; 

select t1.industry,t2.industry
 from layoff_staging t1
JOIN layoff_staging t2
ON t1.company = t2.company
WHERE t1.industry IS NULL OR t1.industry = ''
AND t2.industry IS NOT NULL;

UPDATE layoff_staging
SET industry = NULL
WHERE industry ='';

UPDATE layoff_staging t1
JOIN layoff_staging t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

select * from layoff_staging
 where industry is null;

DELETE from layoff_staging
 where total_laid_off IS NULL 
 AND percentage_laid_off IS NULL;

select* from layoff_staging
 where total_laid_off IS NULL 
 AND percentage_laid_off IS NULL;
 
 select * from layoff_staging;
 
 ALTER TABLE layoff_staging
 DROP COLUMN row_num;













