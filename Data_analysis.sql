SELECT * 
FROM layoff_stagging_2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoff_stagging_2;

SELECT COMPANY,COUNT(*) AS COUNT
FROM layoff_stagging_2
WHERE total_laid_off = (SELECT MAX(total_laid_off) FROM layoff_stagging_2)
OR percentage_laid_off = (SELECT MAX(percentage_laid_off) FROM layoff_stagging_2)
GROUP BY company, location
ORDER BY COUNT(*) DESC;

SELECT * FROM layoff_stagging_2
WHERE COMPANY = "Service";


SELECT company,SUM(total_laid_off) AS "TOTAL PEOPLE LAID OFF"
FROM layoff_stagging_2
GROUP BY company
ORDER BY 2 DESC;

SELECT company,country,SUM(total_laid_off) AS "TOTAL PEOPLE LAID OFF"
FROM layoff_stagging_2
GROUP BY company, country
ORDER BY 3 DESC;

SELECT country,SUM(total_laid_off) AS TOTAL_PEOPLE_LAID_OFF
FROM layoff_stagging_2
GROUP BY country
HAVING TOTAL_PEOPLE_LAID_OFF IS NOT NULL
ORDER BY 2 DESC;

SELECT MIN(`date`) , MAX(`date`)
FROM layoff_stagging_2;


Select country, Year, Month, sum(total_laid_off) as SUM_of_people_laid_off
From
( 
Select *, Year(`date`) as Year, monthname(`date`) as Month
From layoff_stagging_2
)
As Year_table
Group by country, Year, Month
Having Year IS NOT NULL AND SUM_of_people_laid_off IS NOT NULL
Order by 2,3,4 Desc;

SELECT industry, SUM(total_laid_off) AS SUM_OF_PEOPLE_LAID_OFF_BY_INDUSTRY
FROM layoff_stagging_2
GROUP BY industry
HAVING industry IS NOT NULL
ORDER BY 2 DESC;

SELECT *, round(((total_laid_off * 100)/percentage_laid_off),0) AS 'total_number_of_employess'
FROM layoff_stagging_2
having total_number_of_employess is not null
order by total_number_of_employess desc;

SELECT `date` , row_number 
FROM layoff_stagging_2;




