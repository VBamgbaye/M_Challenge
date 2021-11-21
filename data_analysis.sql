-- List countries with income level of "Upper middle income".
SELECT name FROM world_bank WHERE "incomeLevel.value" = 'Upper middle income';

-- List countries with income level of "Low income" per region.
SELECT name FROM world_bank WHERE "incomeLevel.value" = 'Low income';

-- Find the region with the highest proportion of "High income" countries.
 SELECT COUNT(*), "region.value"
 FROM world_bank
 GROUP BY "region.value"
 HAVING COUNT(*) = (
                    SELECT MAX(COUNT)
                    FROM (
                            SELECT COUNT(*), "region.value"
                            FROM world_bank
                            WHERE "incomeLevel.value" = 'High income'
                            GROUP BY "region.value") AS a);
-- OR

SELECT a."region.value"
FROM (
        SELECT COUNT(*), "region.value"
        FROM world_bank
        WHERE "incomeLevel.value" = 'High income'
        GROUP BY "region.value") AS a
        WHERE a.count = 37;

SELECT COUNT(*), "region.value" FROM world_bank GROUP BY "region.value"
WHERE COUNT(*) = (SELECT MAX(count) max_count FROM
(SELECT COUNT(*), "region.value" FROM world_bank WHERE "incomeLevel.value" = 'High income' GROUP BY "region.value") AS a)
-- Calculate cumulative/running value of GDP per region ordered by income from lowest to highest and country name.


-- Calculate percentage difference in value of GDP year-on-year per country.


-- List 3 countries with lowest GDP per region.


-- Provide an interesting fact from the dataset.
