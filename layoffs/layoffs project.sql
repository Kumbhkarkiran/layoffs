create database world_layoffs;
use world_layoffs;

-- 🔶 Project Title:--Global Layoffs Data Analysis (2020–2023): Understanding Global Workforce Trends

-- Problem Statement (The “What was the problem?” part?????????)

-- After the pandemic, companies across industries began mass layoffs due to funding issues, market uncertainty, and restructuring.
-- However, there was no clear, data-driven understanding of:
-- Which industries and countries were hit hardest
-- Whether startup funding stage or funding amount affected layoffs
-- How layoffs evolved over time globally
-- So, this project aimed to analyze global layoff patterns using SQL to uncover these insights and trends.

--  Data Cleaning & Preparation 
 
--  1)Removed duplicates

SELECT DISTINCT * FROM layoffs;

-- 2)Standardized date format

UPDATE layoffs 
SET date = STR_TO_DATE(date, '%m/%d/%Y');
SELECT date FROM layoffs LIMIT 10;

-- 3)Handled NULL and blank values

DELETE FROM layoffs 
WHERE total_laid_off IS NULL OR date IS NULL;

-- 4)Checked first and last recorded layoffs

SELECT MIN(date), MAX(date) FROM layoffs;

-- Exploratory Data Analysis (EDA)
 
--  1)Total Layoffs Over Time
SELECT YEAR(date) AS year, SUM(total_laid_off) FROM layoffs GROUP BY year;
-- Insight:
-- Layoffs spiked sharply in 2022–2023, mainly due to tech slowdowns and post-pandemic corrections.

-- Top 10 Companies with Most Layoffs



SELECT company, SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 10;

-- Insight-:Meta, Google, Amazon, Microsoft, and Salesforce were the top contributors, each laying off tens of thousands of employees.
-- Most belong to the Tech industry, showing that even highly profitable firms were not immune.

-- Industry-wise Layoffs



SELECT industry, SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY industry
ORDER BY total_layoffs DESC;


-- Insight:consumer and retail Services sectors faced the highest layoffs.
.

-- Country-wise Layoffs
SELECT country, SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY country
ORDER BY total_layoffs DESC;
-- Insight-- sight: The United States accounted for the majority of global layoffs. India, neatherlands , and sweden followed, mainly driven by global tech dependence.
-- Reflects how U.S. tech downturns impacted worldwide operations.  
-- Company Stage Impact
SELECT stage, SUM(total_laid_off) AS total_layoffs, 
       ROUND(AVG(percentage_laid_off),2) AS avg_percentage
FROM layoffs
GROUP BY stage
ORDER BY total_layoffs DESC;
-- Insight: post-IPO companies had the most layoffs.

-- Total Layoffs per Year

SELECT YEAR(date) AS year,
       SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY year
ORDER BY year;
-- Insight:2023 recorded the highest layoffs, indicating the aftereffects of global inflation and tech correction.
-- 2020–2021 layoffs were pandemic-driven, while 2022–2023 were cost-optimization driven.
-- Month-wise Trend Analysis
SELECT MONTHNAME(date) AS month,
       SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY month
ORDER BY monthname(date);
-- Insight: november had the highest layoffs — typical for fiscal year restructuring.
--  Drop observed in September, indicating market stabilization

-- Top 10 Countries by Number of Layoff Events

SELECT country, COUNT(*) AS layoff_events
FROM layoffs
GROUP BY country
ORDER BY layoff_events DESC
LIMIT 10;
-- Insight:U.S., India, and canada. led not only in layoffs count but also in number of events, showing widespread restructuring.
-- Emerging markets were less affected.

-- Average % of Workforce Laid Off by Industry

SELECT industry, ROUND(AVG(percentage_laid_off),2) AS avg_percent
FROM layoffs
WHERE percentage_laid_off IS NOT NULL
GROUP BY industry
ORDER BY avg_percent DESC;


-- Insight:Crypto and Fintech industries had the highest layoff percentage, some above 50%.
-- Reflects volatility and overhiring during growth phases.

#Top 10 Industries by Number of Companies Affected


SELECT industry, COUNT(DISTINCT company) AS affected_companies
FROM layoffs
GROUP BY industry
ORDER BY affected_companies DESC
LIMIT 10;


-- insight:healthcare, Retail, and Finance had the widest spread — most companies affected.
-- Healthcare and Education showed resilience.
 -- Average Layoff per Country

SELECT country, ROUND(AVG(total_laid_off),0) AS avg_layoff
FROM layoffs
GROUP BY country
ORDER BY avg_layoff DESC
LIMIT 10;


-- Insight:netherlands . and Canada had the highest average layoff count per event, indicating large corporate cuts.

-- Companies with Most Frequent Layoffs



SELECT company, COUNT(*) AS layoff_events
FROM layoffs
GROUP BY company
ORDER BY layoff_events DESC
LIMIT 10;


-- Insight:loft, uber, and swiggy appeared multiple times — indicating staggered layoffs over months.
-- Suggests phased restructuring instead of single layoffs.



-- Companies with High Funding but High Layoffs
SELECT company, industry, funds_raised_millions, total_laid_off
FROM layoffs
WHERE funds_raised_millions > 500
ORDER BY total_laid_off DESC
LIMIT 10;
-- Insight: Even well-funded companies (like meta,ericsson) laid off heavily — showing that capital ≠ stability.

-- Industries with Lowest Average Layoff %
SELECT industry, ROUND(AVG(percentage_laid_off),2) AS avg_percent
FROM layoffs
WHERE percentage_laid_off IS NOT NULL
GROUP BY industry
ORDER BY avg_percent ASC;
 -- Insight:Industries like Healthcare, Energy, and Manufacturing showed more stability and lower average layoffs.
 
 -- Top Locations (City-wise)
SELECT location, SUM(total_laid_off) AS total_layoffs
FROM layoffs
GROUP BY location
ORDER BY total_layoffs DESC
LIMIT 10;


--  Insight:bay area, seattle, and Bangalore were top cities — reflecting major global tech hubs.

-- Industries Affected in Multiple Countries
SELECT industry, COUNT(DISTINCT country) AS countries_affected
FROM layoffs
GROUP BY industry
ORDER BY countries_affected DESC;
--  Insight:The finance industry was globally impacted — spanning 20+ countries — proving its interconnectedness.
 -- Most Common Days for Layoffs
SELECT DAYNAME(date) AS weekday,
       COUNT(*) AS layoff_events
FROM layoffs
GROUP BY weekday
ORDER BY layoff_events DESC;
 -- Insight:wednesday  and tuesday were peak days

-- Companies with Consistent Layoffs (Multiple Years)
SELECT company, COUNT(DISTINCT YEAR(DATE)) AS years_with_layoffs
FROM layoffs
GROUP BY company
HAVING years_with_layoffs > 1
ORDER BY years_with_layoffs DESC;

-- 📍 Insight: -- Some firms had layoffs year after year (e.g.bounce,delivey hero), showing recurring operational adjustments.

-- Conclusion

-- This project analyzed global layoffs data to understand trends across companies, industries, countries, and funding stages.

-- Through extensive SQL-based data cleaning and exploratory analysis, several clear patterns emerged:

-- 🔹 Layoffs peaked in 2022–2023, especially among tech and consumer service companies.

-- 🔹 Big tech firms such as Meta, Google, Amazon, Microsoft, and Salesforce led the layoff wave.

-- 🔹 The United States accounted for the majority of global layoffs, followed by India and the UK.

-- 🔹 Late-stage and post-IPO startups faced higher layoffs than early-stage ones, showing that growth maturity often brings cost pressure.

-- 🔹 november 2023 witnessed the largest single-month layoffs, commonly announced on Mondays and Fridays.







    
