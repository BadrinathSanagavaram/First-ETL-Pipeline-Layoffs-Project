![image](https://github.com/user-attachments/assets/a2ff142e-93fe-484f-8f56-df1e74ae74f1)


Project Title: Global Layoff Analysis Dashboard
🧩 Step-by-Step Process
🔹 1. Data Collection & Staging
Source: A .csv file named layoffs.csv containing raw layoff data across companies, countries, industries, and dates.

Loaded this dataset into a MySQL database schema called layoff_db.

Created a backup table layoff and cloned it into a staging table layoff_stagging to ensure raw data was preserved before transformation.

🔹 2. Data Cleaning (in Data_cleaning.sql)
Performed detailed data cleaning using SQL scripts:

✅ Duplicate Removal
Used both GROUP BY + HAVING and ROW_NUMBER() window functions to identify duplicate records.

Created a cleaned version of the table named layoff_stagging_2 by filtering out duplicates.

🧽 Standardization
Trimmed whitespaces from company, country, and industry fields.

Standardized variations like CryptoCurrency, Crypto Currency → unified as Crypto.

Cleaned up malformed country names with trailing periods using TRIM(TRAILING '.').

📆 Data Type Fixes
Converted the date column from TEXT to proper DATE format using STR_TO_DATE() and ALTER TABLE.

🚫 Null Handling
Filled null values in the industry column by cross-joining rows with matching company names.

Removed records where both total_laid_off and percentage_laid_off were NULL.

Dropped unnecessary RNK column after de-duplication.

🔹 3. ETL and Data Transformation (from ETL_Loading.ipynb)
Imported the cleaned layoff_stagging_2 dataset into a Python notebook for transformation.

Likely performed EDA and transformation in Python using pandas (based on notebook context).

Prepared aggregated datasets such as:

Total layoffs by company and country

Rolling sum by month and year

Total layoffs by industry

🔹 4. Data Analysis (from Data_analysis.sql)
Executed key SQL queries to extract insights:

🏢 Top companies by total layoffs

🌍 Layoffs by country (SUM(total_laid_off) grouped by country)

📆 Trends over time (Year-Month analysis)

🏭 Layoffs by industry

📊 Estimate of total employees using total_laid_off and percentage_laid_off

🔁 Rolling sum of monthly layoffs using window functions

🔹 5. Visualization (Tableau)
Exported aggregated data to Tableau.

Built a world map visualization where:

Darker shades represent higher total layoffs.

Countries like the USA, Japan, and Canada appear darker — indicating higher layoff counts.

This visual helps identify global layoff hotspots and supports executive decision-making.

🎯 Final Goal Achieved:
Successfully migrated raw layoff data from CSV → MySQL → Python/SQL analysis → Tableau.

Cleaned and enriched the dataset with proper type casting, deduplication, and null filling.

Produced a data-driven interactive visualization summarizing layoff trends across countries and industries.
