USE layoff_db;

SHOW TABLES;


# REMOVED THE INDEX COLUMN
ALTER TABLE layoff
DROP COLUMN `index`;

SELECT * FROM layoff_db.layoff;

# CREATING A STAGGING DATATABLE SO THAT WE CAN ALWAYS HAVE THE ORIGINAL LAYOFF
# DATA TABLE AS A BACK UP. IT IS GENERALLY A BEST PRACTICE

CREATE TABLE layoff_stagging 
LIKE layoff_db.layoff;

# Checking whether the table is created or not
Select * from layoff_stagging;

# Now inserting values into the table

insert layoff_stagging
SELECT *
FROM layoff;

# Checking whether data is inserted into or not

Select * from layoff_stagging;

----------------------- Task : 1 Removing Duplicates from the Layoff_stagging Dataset --------------------
 
# To find out duplicates we can do it using Group By + Having and another method where in we use the Window Function

SELECT Company, location, industry, total_laid_off , percentage_laid_off, `date`,Count(*) as Count
FROM layoff_stagging
Group by Company, location, industry, total_laid_off , percentage_laid_off, `date`
Having Count > 1;

With duplicate_cte As
(
SELECT *,
		row_number() OVER
        (
        partition by Company, location, 
        country, industry, total_laid_off , 
        percentage_laid_off, funds_raised_millions ,`date`
        ) AS RNK
FROM layoff_stagging
)

SELECT * FROM duplicate_cte
where RNK > 1;

CREATE TABLE `layoff_stagging_2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` double DEFAULT NULL,
  `percentage_laid_off` double DEFAULT NULL,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` double DEFAULT NULL,
  `RNK` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


Insert layoff_stagging_2
Select * From (
SELECT *,
		row_number() OVER
        (
        partition by Company, location, 
        country, industry, total_laid_off , 
        percentage_laid_off, funds_raised_millions ,`date`
        ) AS RNK
FROM layoff_stagging
) as duplicate_cte;

SELECT * FROM layoff_stagging_2
Where RNK > 1;

Delete from layoff_stagging_2
Where RNK > 1;

## STANDARDISING DATA

SELECT DISTINCT(Trim(company)) 
from layoff_stagging_2;

Update layoff_stagging_2
SET company = Trim(company);

SELECT distinct(company)
FROM layoff_stagging_2;

SELECT DISTINCT(industry) 
FROM layoff_stagging_2
Order by industry;

# We have 3 distinct industries of teh same domain namely Crypto, CryptoCurrency and Crypto Currency
# These 3 are the same but named differently we are gonna update this

Update layoff_stagging_2
SET industry = 'Crypto'
Where industry like 'Crypto%';


# From executing this query we can observe that we have eliminated the ambiguous naming of Crypto
SELECT DISTINCT(industry) 
FROM layoff_stagging_2
Order by industry;


# Looking into Country and Location column

Select distinct(country)
from layoff_stagging_2
Where country like "%." OR country like " % "
Order by country;

Select TRIM(TRAILING '.' FROM country)
from layoff_stagging_2;

Update layoff_stagging_2
SET country = trim(trailing '.' FROM country) and 
country = trim(country);

# Checking whether the changes made are reflected or not
Select distinct(country)
from layoff_stagging_2
Where country like "%." OR country like " % "
Order by country;

SELECT Distinct(substring(country,1,1)) as starting_char FROM layoff_stagging_2;

## Obtaning the Data type of all the columns in the layoff_stagging 2 table

Select TABLE_SCHEMA, COLUMN_NAME, COLUMN_TYPE 
from INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'layoff_stagging_2' and COLUMN_NAME IN ('company', 'country', 'date', 'funds_raised_millions', 'industry');

# WE HAVE SEEN THAT THE COLUMN TYPE OF DATE COLUMN IS TEXT WE HAVE TO CONVERT IT INTO DATE

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y') 
FROM layoff_stagging_2;

update layoff_stagging_2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

Select TABLE_SCHEMA, COLUMN_NAME, COLUMN_TYPE 
from INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'layoff_stagging_2' and COLUMN_NAME IN ('date');

## Even though we have converted this to date format we have to convert the type to date format using ALTER

ALTER TABLE layoff_stagging_2
MODIFY COLUMN `date` date;

Select TABLE_SCHEMA, COLUMN_NAME, COLUMN_TYPE 
from INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'layoff_stagging_2' and COLUMN_NAME IN ('date');

## NOW WHAT WE ARE TRYING TO DO IS TO REPLACE NULL VALUES AND BLANK VALUES


