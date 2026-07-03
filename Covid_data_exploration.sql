SELECT iso_code, continent, location, date FROM covid_deaths;
SELECT iso_code, continent, location, date, total_deaths, population FROM covid_deaths;
--selecting data which is needed
Select Location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
WHERE continent is not NULL
order by 1,2;

--Total deaths vs total cases 
--How likely a persons dies if that person contracts covid?
SELECT 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    (total_deaths * 100.0 / total_cases) AS death_percentage
FROM 
    covid_deaths
WHERE 
    continent IS NOT NULL 
    AND total_deaths IS NOT NULL
    AND total_cases IS NOT NULL
ORDER BY 
    1,2;

--HIghest dealth percentage if a person gets covid
SELECT
    location,
    MAX(total_cases) as maximum_cases,
    MAX(total_deaths) as maximum_deaths,
    (MAX(total_deaths*100)/MAX(total_cases)) as highest_death_percentage
FROM covid_deaths
WHERE 
    continent IS NOT NULL 
    AND total_deaths IS NOT NULL
    AND total_cases IS NOT NULL
GROUP BY 1
ORDER BY highest_death_percentage DESC;


--Total cases vs population
--What's % of population infected with covid?
SELECT 
    location,
    date, 
    total_cases, 
    population,
    (total_cases/population)*100 as infected_percentage
FROM covid_deaths
WHERE 
    continent IS NOT NULL 
    AND total_cases IS NOT NULL 
    AND population IS NOT NULL
ORDER BY 1,2;

--HIghest Infected percentage country-wise
SELECT 
    location,
    population,
    MAX(total_cases) AS highest_infection_count, 
    MAX(total_cases * 100.0 / population) AS max_infected_percentage
FROM 
    covid_deaths
WHERE 
    continent IS NOT NULL 
    AND total_cases IS NOT NULL 
    AND population IS NOT NULL
GROUP BY 
    location, population
ORDER BY 
    max_infected_percentage DESC;


--Countries with highest dealth count per population
SELECT
    location,
    MAX(total_deaths) as highest_death_count
FROM covid_deaths
WHERE continent is not null and total_deaths is not NULL
group by 1
order by highest_death_count DESC;

--Continents with highest death count per population
SELECT
    continent,
    location,
    MAX(total_deaths) as highest_death_count
FROM covid_deaths
WHERE continent is not null and total_deaths is not NULL
group by 1,2
order by highest_death_count DESC;

--Total popuation vs vaccinations
--How many people vaccinated during covid 19 in each country?

SELECT 
    d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations,
    SUM(CAST(v.new_vaccinations as BIGINT)) OVER(PARTITION BY d.location ORDER BY d.location, d.date) as People_vaccinated
FROM covid_deaths as d
JOIN covid_vaccinations AS v
ON v.location = d.location
AND v.date = d.date
WHERE 
d.continent  IS NOT NULL
AND v.new_vaccinationS IS NOT NULL
AND v.people_vaccinated IS NOT NULL
ORDER BY 2,3;

--creating view to store data
CREATE VIEW percent_population_vacc as 
(
    SELECT 
        d.continent, 
        d.location, 
        d.date, 
        d.population, 
        v.new_vaccinations,
        SUM(CAST(v.new_vaccinations as BIGINT)) OVER(PARTITION BY d.location ORDER BY d.location, d.date) AS people_vaccinated,
        SUM(CAST(v.new_vaccinations as BIGINT)) OVER(PARTITION BY d.location ORDER BY d.location, d.date)*100/d.population as per_pop_vacc
    FROM covid_deaths as d
    JOIN covid_vaccinations as v
    ON v.location = d.location
    AND v.date = d.date
    WHERE d.continent IS NOT NULL
    AND v.new_vaccinations IS NOT NULL
    AND v.people_vaccinated IS NOT NULL
)

--For easy calling  
WITH summary_data AS 
(
    SELECT
        continent,
        location,
        MAX(population) as tot_pop,
        MAX(people_vaccinated) as total_vac,
        MAX(per_pop_vacc) AS Vaccinated
        FROM percent_population_vacc 
        GROUP BY continent, location
)
SELECT * FROM summary_data ORDER BY 1,2;
SELECT * FROM percent_population_vacc ORDER BY 1,2;

SELECT 
    SUM(total_cases) as sum_cases, 
    SUM(total_deaths) as sum_deaths,
    SUM(total_deaths)*100/SUM(total_cases) as death_percentage
FROM covid_deaths
WHERE total_cases is not NULL
and total_deaths is not NULL; 