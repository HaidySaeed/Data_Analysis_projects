select * from PortfolioProject..CovidDeaths$
where continent is NULL
order by 3,4
--looking at date

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths$
where continent is not NULL
order by 1,2
--first death after 1 month 

--looking at total death vs total cases
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPerectange
from PortfolioProject..CovidDeaths$
where location ='Egypt'
order by 1,2

--looking at total cases vs population
--show what percentage of population got covied
select location, date, population, total_cases, (total_cases/population)*100 as coviedPer
from PortfolioProject..CovidDeaths$
where location ='Egypt'
order by 1,2

--looking at countries with higest infection rate compared to population
select location, population, MAX(total_cases) as MaxInfection , Max((total_cases/population))*100 as coviedPer
from PortfolioProject..CovidDeaths$
group by location , population
order by coviedPer desc

-- looking at countries with higest death count per population 
select location, population, MAX(cast(total_deaths as int)) as Max_Death 
from PortfolioProject..CovidDeaths$
where continent is not NULL
group by location , population
order by Max_Death desc

--LET'S BREAK THNGS DOWN BY CONTINENT
select continent, MAX(cast(total_deaths as int)) as Max_Death 
from PortfolioProject..CovidDeaths$
where continent is NOT NULL
group by continent 
order by Max_Death desc

--Global Numbers
--1
select sum(new_cases) as total_cases,sum(cast(new_deaths as int))as total_death,sum(cast(new_deaths as int))/ sum(new_cases)*100 as deathpercentage
from PortfolioProject..CovidDeaths$
where continent is NOT NULL
--group by date 
order by 1,2

select location , continent
from PortfolioProject..CovidDeaths$
where continent is null
--2
select location ,sum(cast(new_deaths as int)) as total_death
from PortfolioProject..CovidDeaths$
where continent is null and location not in ('European Union','World','International')
group by location
order by total_death
--3

select location,population , max(total_cases) as HighestInfictionCount , max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
--where continent is null
group by location,population
order by PercentPopulationInfected desc
--4

select location,population ,date, max(total_cases) as HighestInfictionCount , max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
--where continent is null
group by location,population,date
order by PercentPopulationInfected desc

--vaccination data
--total vaccination vs population
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
select dea.continent,dea.location,dea.date , dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea join PortfolioProject..CovidVaccinations$ vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 
-- ordered by date and country 

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 as VacPopPerc
From #PercentPopulationVaccinated





