-- List countries with income level of "Upper middle income".
SELECT name FROM world_bank WHERE "incomeLevel.value" = 'Upper middle income';

-- List countries with income level of "Low income" per region.
SELECT name FROM world_bank WHERE "incomeLevel.value" = 'Low income';

-- Find the region with the highest proportion of "High income" countries.

 SELECT COUNT(*), "region.value"
 FROM world_bank
 WHERE "incomeLevel.value" = 'High income'
 GROUP BY "region.value"
 HAVING COUNT(*) =(
                    SELECT MAX(COUNT)
                    FROM (
                            SELECT COUNT(*), "region.value"
                            FROM world_bank
                            WHERE "incomeLevel.value" = 'High income'
                            GROUP BY "region.value") AS a);

-- Calculate cumulative/running value of GDP per region ordered by income from lowest to highest and country name.
SELECT
name,
"region.value",
"incomeLevel.value",
"2018",
"2019",
"2020",
"2021",
"2022"
FROM
(SELECT
world_bank.name,
world_bank."region.value",
world_bank."incomeLevel.value",
gdp."2018",
gdp."2019",
gdp."2020",
gdp."2021",
gdp."2022"
FROM world_bank JOIN gdp ON world_bank.name = gdp.country_name) AS a GROUP BY a.name, a."region.value";


-- Calculate percentage difference in value of GDP year-on-year per country.


-- List 3 countries with lowest GDP per region.


-- Provide an interesting fact from the dataset.