SELECT *
FROM [Portfolio project]..['covid_deaths']
WHERE continent is not NULL
ORDER BY 3,4

SELECT *
FROM [Portfolio project]..['covid_vaccinations']
WHERE continent is not NULL
ORDER BY 3,4

ALTER TABLE [Portfolio project]..['covid_deaths'] ALTER COLUMN location nvarchar(150)
SELECT*
FROM [Portfolio project]..['covid_deaths']

--SELECT *
--FROM [Portfolio project]..['covid_vaccinations']
--ORDER BY 3,4

--Select data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM [Portfolio project]..['covid_deaths']
ORDER BY 1,2

-- Looking at total cases vs total deaths
-- shows the likelyhood of dying from COVID if you are infected by it

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 death_percentage
FROM [Portfolio project]..['covid_deaths']
WHERE location = 'India' OR location like '%states'

ORDER BY 1,2


-- Looking at total cases vs population
-- shows what percentage of population got covid

SELECT location, date, total_cases, total_deaths, population, (total_cases/population)*100 percent_of_population_infected
FROM [Portfolio project]..['covid_deaths']
WHERE location LIKE '%Kingdom%'
ORDER BY 1,2

-- Looking at countries with highest infection rate compared to the population


SELECT location, population, MAX(total_cases) highest_infection_count, MAX((total_cases/population))*100 highest_infection_rate
FROM [Portfolio project]..['covid_deaths']
GROUP BY location, population
ORDER BY 4 DESC


-- Looking at countries with highest death count compared to the population

SELECT location, MAX(cast(total_deaths as int)) total_death_count
FROM [Portfolio project]..['covid_deaths']
WHERE continent is not NULL
GROUP BY location, population
ORDER BY 2 DESC

-- Shwoing the CONTINENTS with highest death counts

SELECT location, MAX(cast(total_deaths as int)) total_death_count
FROM [Portfolio project]..['covid_deaths']
WHERE continent is  NULL
GROUP BY location
ORDER BY 2 DESC


--  GLOBAL NUMBERS

-- shows the global death rate per each day

SELECT date, SUM(new_cases) total_cases, SUM(cast(new_deaths as int)) total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 Global_death_percentage
FROM [Portfolio project]..['covid_deaths']
--WHERE location = 'India' OR location like '%states'
WHERE continent is not NULL
GROUP BY date
ORDER BY 1,2

--shows global deaths, global death rate and total global cases

SELECT  SUM(new_cases) total_cases, SUM(cast(new_deaths as int)) total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 Global_death_percentage
FROM [Portfolio project]..['covid_deaths']
--WHERE location = 'India' OR location like '%states'
WHERE continent is not NULL
--GROUP BY date
ORDER BY 1,2


-- JOINING DEATH TABLE WITH VACCINATION TABLE

-- total population vs vaccination (USING CTE or without it)


WITH PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
As
(

SELECT death.continent, death.location, death.date, population, vaccine.new_vaccinations,
SUM(CONVERT(INT,vaccine.new_vaccinations)) OVER (partition by death.location ORDER BY death.location,death.date) RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM [Portfolio project]..['covid_deaths'] death
JOIN [Portfolio project].. ['covid_vaccinations'] vaccine
ON death.location = vaccine.location
AND death.date = vaccine.date
WHERE death.continent is not NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac



-- TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric, 
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT death.continent, death.location, death.date, population, vaccine.new_vaccinations,
SUM(CONVERT(INT,vaccine.new_vaccinations)) OVER (partition by death.location ORDER BY death.location,death.date) RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM [Portfolio project]..['covid_deaths'] death
JOIN [Portfolio project].. ['covid_vaccinations'] vaccine
ON death.location = vaccine.location
AND death.date = vaccine.date
WHERE death.continent is not NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


-- creating view to store data for later visualization

CREATE view PercentpopulationVaccinated AS
SELECT death.continent, death.location, death.date, population, vaccine.new_vaccinations,
SUM(CONVERT(INT,vaccine.new_vaccinations)) OVER (partition by death.location ORDER BY death.location,death.date) RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM [Portfolio project]..['covid_deaths'] death
JOIN [Portfolio project].. ['covid_vaccinations'] vaccine
ON death.location = vaccine.location
AND death.date = vaccine.date
WHERE death.continent is not NULL
--ORDER BY 2,3



