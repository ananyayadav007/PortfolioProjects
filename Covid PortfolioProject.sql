select * 
from PortfolioProject..CovidDeaths
order by 3,4

--select * 
--from PortfolioProject..CovidDeaths
--order by 3,4
select location,date, total_cases, new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2

-- Data to show likely one can die if they contract covid in India
select location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from PortfolioProject..CovidDeaths
where location ='India'
order by 2 


select location,date, total_cases, population, (total_deaths/population)*100 as Populationpercentage
from PortfolioProject..CovidDeaths
where location ='India'
order by 2 

--Infecion rate in compared to population 
select location, population, max(total_cases) as HighestNumberCase, Max((total_cases/population))*100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
group by location,population

--Countries with Highest Death count per population 
Select location, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by HighestDeathCount desc


-- Continent with highest death count
Select continent, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null and location <>'lower middle income' and location <>'Upper middle income' and location <>'High income' and location <>'low income'
group by continent
order by HighestDeathCount desc


Select  sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as  total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from PortfolioProject..CovidDeaths 
where continent is not null
--group by date
order by 1,2


-- total vaccination vs population using CTE
with PopulationVsVaccine (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated) 
as (
Select deaths.continent, deaths.location, deaths.date, deaths.population, vaccine.new_vaccinations, 
sum(convert(bigint,vaccine.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths deaths
join PortfolioProject..CovidVaccine vaccine
	on deaths.location=vaccine.location
	and deaths.date=vaccine.date
where deaths.continent is not null

)
select *, (RollingPeopleVaccinated/population)*100 as RollingPeopleVaccinatedPercentage
from PopulationVsVaccine


--Using view to store data for visualizations
create view PercentagePopulationVaccinated as 
Select deaths.continent, deaths.location, deaths.date, deaths.population, vaccine.new_vaccinations, 
sum(convert(bigint,vaccine.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths deaths
join PortfolioProject..CovidVaccine vaccine
	on deaths.location=vaccine.location
	and deaths.date=vaccine.date
where deaths.continent is not null

select * from PercentagePopulationVaccinated
