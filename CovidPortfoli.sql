select location
from CovidDeath
where location = 'India'

select * 
from CovidDeath
order by 3,4

-- Select Data that we are going to be starting with



select distinct continent
from CovidDeath

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeath
where continent is not null
order by 1,2

--
select location, sum( total_cases),sum(new_cases)
from CovidDeath
where continent is not null
group by location


---- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from CovidDeath
where location ='india'
order by 2,3
-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

select location, date, population, total_cases, (total_cases/population)*100 as PercentagePopulationInfected
from CovidDeath
where location like 'india'
order by 1,2

---- Countries with Highest Infection Rate compared to Population
select location, population, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as PercentagePopulationInfected
from CovidDeath
where location = 'India'
group by location,population
order by 4 desc

--countries with Highest Death Count per Population
select location,  MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeath
where location = 'india'
and continent is not null
group by location
order by TotalDeathCount

--Breaking Things Down By Continent

--Showing continents with the highest death count per population

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeath
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage 
from CovidDeath
where continent is not null
order by 1,2

--Total Population Vs Vaccination
--Shows Percentages of Population That has recieved at least one Covid Vaccine

select d.continent, d.location, d.date, d.population, v.new_vaccinations,
       sum(convert(int,v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from CovidDeath d
join CovidVaccination v
  on  d.location =v.location
   and d.date = v.date
   where d.continent is not null
   order by 2,3

   --Use CTE
with PopVsVac (Continent, Location, Data, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
       sum(convert(int,v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from CovidDeath d
join CovidVaccination v
  on  d.location =v.location
   and d.date = v.date
   where d.continent is not null
   )
select *,(RollingPeopleVaccinated/Population)*100
from PopVsVac

--TEMP Table
DROP Table if exists #PercentPopulationVaccinated
create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
       sum(convert(int,v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from CovidDeath d
join CovidVaccination v
  on  d.location =v.location
   and d.date = v.date
 --  where d.continent is not null
  -- order by 2,3

select * ,(RollingPeopleVaccinated/Population)*100
   from #PercentPopulationVaccinated

select * , (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


--Creating View to store data for visualization

Create View PercentPopulationVaccinated as
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
       sum(convert(int,v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from CovidDeath d
join CovidVaccination v
  on  d.location =v.location
   and d.date = v.date
   where d.continent is not null