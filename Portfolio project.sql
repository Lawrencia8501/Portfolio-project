SELECT *
FROM [Portfolio project]..CovidDeaths$
order by 3,4 

SELECT *
FROM [Portfolio project]..Covidvaccinations$
order by 3,4 

--Select data for project--

SELECT Location,
date,
total_cases,
new_cases,
total_deaths,
population
FROM [Portfolio project]..CovidDeaths$
order by 1,2

--The total cases vrs total deaths--
SELECT Location,
date,
total_cases,
total_deaths,
(total_deaths/total_cases)* 100 as death_percentage
FROM [Portfolio project]..CovidDeaths$
WHERE location like '%states%'
order by 1,2

--Total cases vrs populations--
SELECT Location,
date,
total_cases,
population,
(total_cases/population) * 100 as populationpercentage
FROM [Portfolio project]..CovidDeaths$
where location like '%Africa%'
order by 1, 2

-- Country with the highest infection rate compared to population--
SELECT Location,
population,
MAX(total_cases) as highestinfectioncount,
MAX((total_cases/population)) * 100 as infectedpopulationpercentage
FROM [Portfolio project]..CovidDeaths$
GROUP BY location,population
order by infectedpopulationpercentage DESC

--countries with the highest death count--
SELECT Location,
MAX(CAST(total_deaths as int)) as totaldeathcount
FROM [Portfolio project]..CovidDeaths$
where continent is not null
GROUP BY location
order by totaldeathcount DESC

-- Group by continent with the highest death count --
SELECT continent,
MAX(CAST(total_deaths as int)) as totaldeathcount
FROM [Portfolio project]..CovidDeaths$
where continent is not null
GROUP BY continent
order by totaldeathcount DESC

--Global numbers--
SELECT date,
SUM(new_cases) as totalnewcases,
SUM(CAST(new_deaths as int)) as totalnewdeaths,
SUM(CAST(new_deaths as int)) /SUM(new_cases)  *100 as deathpercentage
FROM [Portfolio project]..CovidDeaths$
where continent is not null
group by date
order by 1,2

--Join coviddeaths and covidvaccinations table--
SELECT *
FROM [Portfolio project]..CovidDeaths$ cd
 JOIN [Portfolio project]..Covidvaccinations$ cv
 ON cd.location = cv.location
 And cd.date = cv.date

 --total population vs vaccinations--
 Select cd.continent,
 cd.location,
cd.date,
cd.population,
cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations as int)) OVER (partition by cv.location order by cd.location,cd.date) as rollingcount
 FROM [Portfolio project]..CovidDeaths$ cd
 JOIN [Portfolio project]..Covidvaccinations$ cv
 ON cd.location = cv.location
 And cd.date = cv.date
 where cd.continent is not null
 order by 2,3

 -- create a CTE --
 WITH popvrsvac (continent,location,date,population,new_vaccinations,rollingcount)
 as
 (
 Select cd.continent,
 cd.location,
cd.date,
cd.population,
cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations as int)) OVER (partition by cv.location order by cd.location,cd.date) as rollingcount
 FROM [Portfolio project]..CovidDeaths$ cd
 JOIN [Portfolio project]..Covidvaccinations$ cv
 ON cd.location = cv.location
 And cd.date = cv.date
 where cd.continent is not null
 
 )
 select * , (rollingcount / population) * 100
 FROM popvrsvac

 -- Temp table --
 Drop table if exists #percentpopulationvaccinated
 Create table #percentpopulationvaccinated
 (
 continent nvarchar(255),
 location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingcount numeric
)

Insert into #percentpopulationvaccinated
Select cd.continent,
 cd.location,
cd.date,
cd.population,
cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations as int)) OVER (partition by cv.location order by cd.location,cd.date) as rollingcount
 FROM [Portfolio project]..CovidDeaths$ cd
 JOIN [Portfolio project]..Covidvaccinations$ cv
 ON cd.location = cv.location
 And cd.date = cv.date
 where cd.continent is not null
 
 select * , (rollingcount / population) * 100
 FROM #percentpopulationvaccinated

 --create a view for tableau--
 create view percentpopulationvaccinated as
Select cd.continent,
 cd.location,
cd.date,
cd.population,
cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations as int)) OVER (partition by cv.location order by cd.location,cd.date) as rollingcount
 FROM [Portfolio project]..CovidDeaths$ cd
 JOIN [Portfolio project]..Covidvaccinations$ cv
 ON cd.location = cv.location
 And cd.date = cv.date
 where cd.continent is not null
