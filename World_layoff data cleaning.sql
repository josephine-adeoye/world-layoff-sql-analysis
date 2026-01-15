SELECT *
FROM layoffs;


                                               # REMOVING DUPLICATES
CREATE TABLE layoffs_sample
LIKE layoffs;

INSERT layoffs_sample
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_sample;

SELECT *
FROM layoffs_sample
WHERE company = 'Loft';

SELECT *,
ROW_NUMBER() OVER (PARTITION BY 
company,location,industry,percentage_laid_off,`date`) 
AS row_num
FROM layoffs_sample;


WITH duplicate_sample AS
(SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company,location,industry,percentage_laid_off,`date`) 
AS row_num
FROM layoffs_sample)
SELECT *
FROM duplicate_sample
WHERE row_num > 1;



CREATE TABLE `layoffs_sample2` (
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


SELECT *
FROM layoffs_sample2;


INSERT INTO layoffs_sample2     
 SELECT *,
ROW_NUMBER() OVER (PARTITION BY 
company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_sample;

DELETE
FROM layoffs_sample2      
WHERE row_num >1;

SELECT *
FROM layoffs_sample2
WHERE row_num >1;

SELECT *
FROM layoffs_sample2;	

                                          #DATA CLEANING(STANDARDIZING)
                                          
SELECT company, TRIM(company)
FROM layoffs_sample2;

UPDATE layoffs_sample2
SET company = TRIM(company);

SELECT *
FROM layoffs_sample2;

SELECT DISTINCT industry
FROM layoffs_sample2
ORDER BY industry;

SELECT industry
FROM layoffs_sample2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_sample2
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';

SELECT *
FROM layoffs_sample2;

SELECT industry
FROM layoffs_sample2
WHERE industry LIKE 'crypto%';


SELECT DISTINCT *         
FROM layoffs_sample2    
WHERE country LIKE 'United State%';


UPDATE layoffs_sample2
SET country = 'United States'
WHERE country LIKE  'United State%';


SELECT *
FROM layoffs_sample2;


                                         #STANDARDIZING DATE COLUMN
SELECT `date`, STR_TO_DATE(`date`,'%Y-%m-%d')
FROM layoffs_sample2;

UPDATE layoffs_sample2
SET `date` = STR_TO_DATE( `date`,'%Y-%m-%d');

SELECT *
FROM layoffs_sample2;

ALTER TABLE  layoffs_sample2  
MODIFY COLUMN `date` DATE;    


                           # FIXING NULL AND BLANK VALUES
SELECT *
FROM layoffs_sample2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 


SELECT *
FROM layoffs_sample2
WHERE industry IS NULL 
OR industry = '';
  

SELECT *
FROM layoffs_sample2
WHERE company = 'Airbnb';

UPDATE layoffs_sample2
SET industry= NULL
WHERE industry = '';

SELECT t1.industry, t2.industry
FROM layoffs_sample2 t1
JOIN layoffs_sample2 t2
	ON 	t1.company=t2.company
    WHERE t1.industry IS NULL 
    AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_sample2 t1
JOIN layoffs_sample2 t2
	ON 	t1.company=t2.company
    WHERE t1.industry IS NULL
    AND t2.industry IS NOT NULL;


UPDATE layoffs_sample2 t1
 JOIN layoffs_sample2 t2
	ON 	t1.company=t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
    AND t2.industry IS NOT NULL;
    
    SELECT *
FROM layoffs_sample2;


SELECT *
FROM layoffs_sample2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;  

DELETE                         
FROM layoffs_sample2          
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;  


SELECT *
FROM layoffs_sample2;


ALTER TABLE layoffs_sample2
DROP column row_num;


 

 
