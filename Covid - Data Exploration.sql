-- Select Data that we are going to be starting with

SELECT *
FROM deaths 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM deaths 
WHERE continent IS NOT NULL
ORDER BY 1, 2 

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in Canada

SELECT location, date, total_deaths, total_cases, (total_deaths/total_cases) *100 AS deathpercentage
FROM deaths 
WHERE location = 'Canada'
ORDER BY 1, 2 DESC


-- Total Cases vs Population
-- Shows what percentage of population got infected with covid 

SELECT location, date, population, total_cases, (total_cases/population*100) AS popinfectedpercent
FROM deaths
ORDER BY 1, 2


-- Countries with Highest Infection Rate Compared to Population

SELECT location, population, MAX(total_cases) AS highestinfectedcount, MAX(total_cases/population*100) AS popinfectedpercent
FROM deaths
WHERE continent IS NOT NULL
GROUP BY 1, 2
ORDER BY 4 DESC


-- Countries with Highest Death Count Per Population

SELECT location, population, MAX(total_deaths) AS totaldeathcount, MAX(total_deaths/population*100) AS deathcountpercentage
FROM deaths
WHERE continent IS NOT NULL
GROUP BY 1, 2
ORDER BY 3 DESC


-- Global Numbers

SELECT date, SUM(new_cases) AS totalcases, SUM(new_deaths) AS totaldeaths, SUM(new_deaths)/SUM(new_cases)*100 AS deathpercentage
FROM deaths
WHERE continent IS NOT NULL
GROUP BY 1
ORDER BY 1, 2


-- Looking At Total Population vs Vaccinations 
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

WITH cte (continent, location, date, population, new_vaccinations, RollingPplVaxxed) 
AS 
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
	SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPplVaxxed
FROM deaths d
JOIN vax v 
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT NULL
)
SELECT *, RollingPplVaxxed/population * 100
FROM cte 


-- Creating View to store data for later Visualizations

CREATE VIEW CanadaDeathRate AS 
SELECT location, date, total_deaths, total_cases, (total_deaths/total_cases) *100 AS deathpercentage
FROM deaths 
WHERE location = 'Canada'
ORDER BY 1, 2 DESC

CREATE VIEW InfectionRate AS 
SELECT location, population, MAX(total_cases) AS highestinfectedcount, MAX(total_cases/population*100) AS popinfectedpercent
FROM deaths
WHERE continent IS NOT NULL
GROUP BY 1, 2
ORDER BY 4 DESC

CREATE VIEW PercentDeathCountPerPopulation AS
SELECT location, population, MAX(total_deaths) AS totaldeathcount, MAX(total_deaths/population*100) AS deathcountpercentage
FROM deaths
WHERE continent IS NOT NULL
GROUP BY 1, 2
ORDER BY 3 DESC

CREATE VIEW GlobalNumbers AS 
SELECT date, SUM(new_cases) AS totalcases, SUM(new_deaths) AS totaldeaths, SUM(new_deaths)/SUM(new_cases)*100 AS deathpercentage
FROM deaths
WHERE continent IS NOT NULL
GROUP BY 1
ORDER BY 1, 2

