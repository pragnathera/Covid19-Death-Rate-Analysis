--Queries for Visualization 
--Table1
select sum(new_cases) as Total_Cases, 
       sum(convert(int,new_deaths)) as Total_Deaths, 
	   sum(convert(int,new_deaths))/sum(new_cases)*100 as DeathPercentage 
from CovidDeath
  where continent is not null
  order by Total_Cases, Total_Deaths

--Table 2

Select location, SUM(cast(new_deaths as int)) as TotalDeath
From CovidDeath
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeath desc

--Table 3

select location, 
       population, 
	   max(total_cases) as HighestInfection,
	   max(total_cases/population)*100 as PercentagePopulationInfected
from CovidDeath
group by location, population
order by PercentagePopulationInfected desc


--Table4

select Location,
       Population,
	   date,
	   max(total_cases) as HighestInfection,
	   max(total_cases/Population)*100 as PercentagePopulationInfected
from CovidDeath
group by location,population,date
order by PercentagePopulationInfected desc



