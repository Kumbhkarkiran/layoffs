create database world_layoffs;
use world_layoffs;

-- 1 remove duplicates
-- 2)standardise the data
-- 3)null vaues or blank values
-- 4) remove any coloumn
-- 🧩 Project Objective:
-- To analyze global layoffs across industries, countries, and company stages to uncover:

-- How layoffs have evolved over time.

-- Which industries, countries, and company stages are most affected.

-- Whether company funding and stage have any relation to layoffs.

-- How severe layoffs are (% laid off) and what trends they reveal.

-- Goal:
-- Provide data-driven insights to help investors, employees, and
--  policymakers understand which sectors are at risk and
--  how company growth stage or funding impacts workforce reduction.


-- Main Objective (in SQL terms):

-- To perform data exploration and trend analysis on global
--  layoffs — understanding which companies, industries, countries, 
--  and funding stages are most impacted by layoffs over time
use world_layoffs;


-- 🔹 1️⃣ Total number of layoffs overall
SELECT 
    SUM(total_laid_off) AS total_layoffs
FROM layoffs;
-- 🔹 2️⃣ Total layoffs per year
SELECT 
    EXTRACT(YEAR FROM date) AS year,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY year
ORDER BY year;
-- 🔹 3️⃣ Top 10 companies with the most layoffs
SELECT 
    company,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 10;
-- 🔹 4️⃣ Companies that laid off everyone (100%)
SELECT 
    company, 
    industry, 
    country, 
    percentage_laid_off
FROM layoffs
WHERE percentage_laid_off = 100;
-- 🔹 5️⃣ Layoffs by industry
SELECT 
    industry, 
    SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY industry
ORDER BY total_layoffs DESC;
-- 🔹 6️⃣ Average layoff percentage by industry
SELECT 
    industry,
    ROUND(AVG(percentage_laid_off),2) AS avg_percentage_laid_off
FROM layoffs
GROUP BY industry
ORDER BY avg_percentage_laid_off DESC;
-- 🔹 7️⃣ Layoffs by country
SELECT 
    country,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY country
ORDER BY total_layoffs DESC;
-- 🔹 8️⃣ Average layoff percentage by country
SELECT 
    country,
    ROUND(AVG(percentage_laid_off),2) AS avg_percentage_laid_off
FROM layoffs
GROUP BY country
ORDER BY avg_percentage_laid_off DESC;
-- 🔹 9️⃣ Layoffs by company stage
SELECT 
    stage,
    SUM(total_laid_off) AS total_layoffs,
    ROUND(AVG(percentage_laid_off),2) AS avg_percentage_laid_off
FROM layoffs
GROUP BY stage
ORDER BY total_layoffs DESC;
-- 👉 Which stage of companies (early, mid, late, post-IPO) faced the most layoffs.
-- 🔹 13️⃣ Industry-wise layoffs by country
SELECT 
    country,
    industry,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY country, industry
ORDER BY total_layoffs DESC;
-- 👉 Multi-dimensional insight — which industry suffered most in which country.
-- 🔹 14️⃣ Ranking industries by total layoffs
SELECT 
    industry,
    SUM(total_laid_off) AS total_layoffs,
    DENSE_RANK() OVER (ORDER BY SUM(total_laid_off) DESC) AS rank_of_industry
FROM layoffs
GROUP BY industry;
-- 👉 Ranks industries by their total layoffs count.
-- 🔹 15️⃣ Average layoffs per company
SELECT 
    company,
    ROUND(AVG(total_laid_off),2) AS avg_layoffs,
    ROUND(AVG(percentage_laid_off),2) AS avg_percentage
FROM layoffs
GROUP BY company
ORDER BY avg_layoffs DESC;
-- 🔹 16️⃣ Top 5 countries by average % laid off
SELECT 
    country,
    ROUND(AVG(percentage_laid_off),2) AS avg_percentage_laid_off
FROM layoffs
GROUP BY country
ORDER BY avg_percentage_laid_off DESC
LIMIT 5;
-- 🔹 17️⃣ Total layoffs by location (city-wise)
SELECT 
    location,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY location
ORDER BY total_layoffs DESC
LIMIT 10;
-- 🔹 18️⃣ Rolling Total by Year & Industry (Advanced)
SELECT 
    EXTRACT(YEAR FROM date) AS year,
    industry,
    SUM(SUM(total_laid_off)) OVER (PARTITION BY industry ORDER BY EXTRACT(YEAR FROM date)) AS cumulative_layoffs
FROM layoffs
GROUP BY year, industry
ORDER BY industry, year;

-- 🔹 19️⃣ Average funding per industry
SELECT 
    industry,
    ROUND(AVG(funds_raised_millions),2) AS avg_funding
FROM layoffs
GROUP BY industry
ORDER BY avg_funding DESC;
-- 🔹 20️⃣ Companies with High Funding but High Layoffs
SELECT 
    company,
    industry,
    country,
    funds_raised_millions,
    total_laid_off
FROM layoffs
WHERE funds_raised_millions > 500
ORDER BY total_laid_off DESC
LIMIT 10;
select * from  layoffs;
-- Remove duplicates

SELECT DISTINCT * 
FROM layoffs;


--  Total Layoffs Per Year
SELECT 
    YEAR(STR_TO_DATE(date, '%m/%d/%Y')) AS year,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs
WHERE date IS NOT NULL
GROUP BY year
ORDER BY year;
-- c) Handle NULL values
DELETE FROM layoffs WHERE total_laid_off IS NULL OR date IS NULL;


-- 🧭 5️⃣ First and Last recorded layoff date
SELECT 
    MIN(STR_TO_DATE(date, '%m/%d/%Y')) AS first_layoff,
    MAX(STR_TO_DATE(date, '%m/%d/%Y')) AS last_layoff
FROM layoffs;
-- 🧭 6️⃣ Companies with layoffs in the most recent year
SELECT 
    company, 
    SUM(total_laid_off) AS total_layoffs
FROM layoffs
WHERE YEAR(STR_TO_DATE(date, '%m/%d/%Y')) = (
    SELECT MAX(YEAR(STR_TO_DATE(date, '%m/%d/%Y'))) FROM layoffs
)
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 10;
-- 🧭 7️⃣ Year-over-year layoff growth
WITH yearly AS (
    SELECT 
        YEAR(STR_TO_DATE(date, '%m/%d/%Y')) AS year,
        SUM(total_laid_off) AS total_layoffs
    FROM layoffs
    GROUP BY year
)
SELECT 
    year,
    total_layoffs,
    total_layoffs - LAG(total_layoffs) OVER (ORDER BY year) AS change_from_last_year
FROM yearly;
-- 🧭 8️⃣ Days with the highest layoffs (peak events)
SELECT 
    STR_TO_DATE(date, '%m/%d/%Y') AS layoff_date,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY layoff_date
ORDER BY total_layoffs DESC
LIMIT 10;
-- 🧭 10️⃣ Count of layoffs per weekday
SELECT 
    DAYNAME(STR_TO_DATE(date, '%m/%d/%Y')) AS weekday,
    COUNT(*) AS number_of_layoff_events
FROM layoffs
GROUP BY weekday
ORDER BY number_of_layoff_events DESC;
-- 📊 Key Insights:

-- Yearly Trend:

-- Layoffs increased sharply in 2022–2023, showing post-pandemic and tech slowdown effects.

-- Monthly & Quarterly Trend:

-- Most layoffs happen in Q1 (Jan–Mar), especially in March — a common time for company restructuring.

-- Recent Year:

-- 2023
--  saw maximum layoffs, mainly by big tech firms like Google, Meta, and Amazon.
-- Peak Days:

-- Specific dates like March 2023 had major layoff waves.

-- Weekday Pattern:

-- Layoffs are often announced on Mondays or Fridays for strategic reasons.




































-- use world_layoffs;

-- CREATE TABLE `layoffs_staging2` (
--   `company` text,
--   `location` text,
--   `industry` text,
--   `total_laid_off` int DEFAULT NULL,
--   `percentage_laid_off` text,
--   `date` text,
--   `stage` text,
--   `country` text,
--   `funds_raised_millions` int DEFAULT NULL
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- select * from layoffs_staging2;
-- insert into  layoffs_staging2 select *  , row_number() over ( partition by company,industry ,total_laid_off,percentage_laid_off,'date')as
--  row_num
--  from layoffs_staging;








