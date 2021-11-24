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
	"Country Name",
	"Region",
	"IncomeGroup",
	SUM("2017") OVER(PARTITION BY "Region" ORDER BY "Country Name", "IncomeGroup") AS "year 17",
	SUM("2018") OVER(PARTITION BY "Region" ORDER BY "Country Name", "IncomeGroup") AS "year 18",
	SUM("2019") OVER(PARTITION BY "Region" ORDER BY "Country Name", "IncomeGroup") AS "year 19",
	SUM("2020") OVER(PARTITION BY "Region" ORDER BY "Country Name", "IncomeGroup") AS "year 20"
FROM gdp;

-- Calculate percentage difference in value of GDP year-on-year per country.
SELECT
	"Country Name",
	"Region",
	"2017",
	"2018",
	"2019",
	"2020",
	100.0 * (1 - LEAD("2017") OVER (ORDER BY "Region") / "2017") AS "%d_2017",
	100.0 * (1 - LEAD("2018") OVER (ORDER BY "Region") / "2017") AS "%d_2018",
	100.0 * (1 - LEAD("2019") OVER (ORDER BY "Region") / "2017") AS "%d_2019",
	100.0 * (1 - LEAD("2020") OVER (ORDER BY "Region") / "2017") AS "%d_2020"
FROM gdp
ORDER BY "Region";

-- List 3 countries with lowest GDP per region.
SELECT
	"Country Name",
	"Region",
	total,
	"T_Rank"
FROM
	(SELECT
		"Country Name",
		"Region",
		"2017",
		"2018",
		"2019",
		"2020",
		total,
		RANK() OVER(PARTITION BY "Region" ORDER BY "total") AS "T_Rank"
	FROM
		(SELECT
			"Country Name",
			"Region",
			"2017",
			"2018",
			"2019",
			"2020",
			(COALESCE("2017",0) + COALESCE("2018",0) + COALESCE("2019",0) + COALESCE("2020",0)) total
		FROM gdp)  AS a) AS b
WHERE "T_Rank" < 4
ORDER BY "Region";



