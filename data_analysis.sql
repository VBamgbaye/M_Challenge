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
    "region.value",
    "incomeLevel.value",
    SUM((COALESCE("2018",0) + COALESCE("2019",0) + COALESCE("2020",0) + COALESCE("2021",0) + COALESCE("2022",0))) Total
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
    FROM world_bank
    JOIN gdp
    ON world_bank.name = gdp.country_name) AS a
    GROUP BY "region.value", "incomeLevel.value"
    ORDER BY "region.value";

-- Calculate percentage difference in value of GDP year-on-year per country.


-- List 3 countries with lowest GDP per region.
SELECT
    name,
    "region.value",
    "incomeLevel.value",
    total,
    t_rank
FROM
    (SELECT
        name,
        "region.value",
        "incomeLevel.value",
        total,
        RANK() OVER (PARTITION BY "region.value" ORDER BY total ASC) t_rank
    FROM
        (SELECT
            name,
            "region.value",
            "incomeLevel.value",
            (COALESCE("2018",0) + COALESCE("2019",0) + COALESCE("2020",0) + COALESCE("2021",0) + COALESCE("2022",0)) total
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
            FROM world_bank
            JOIN gdp
            ON world_bank.name = gdp.country_name)
            AS a ORDER BY "region.value", total ASC) AS b
            ORDER BY "region.value", Total ASC) AS c WHERE t_rank < 4;

-- Provide an interesting fact from the dataset.

