select * from [Portfolio Project]..Covid_vaccination$
order by date ASC;

select * from [Portfolio Project]..CovidDeaths$
order by date ASC;

Select location,population,min(total_cases) as highest_count,(total_cases/population)*100 as infection_rate
from [Portfolio Project]..CovidDeaths$
GROUP BY location,population,total_cases
order by highest_count desc;

--Looking at countries highest infection rate as per population

select location,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as death_rate,population 
from [Portfolio Project]..CovidDeaths$
where location like 'a%'
order by total_cases ASC;

Select location,MAX(CAST(total_deaths as int)) as Total_Death_Count
from [Portfolio Project]..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY location
order by Total_Death_Count desc;

SELECT * FROM [Portfolio Project]..CovidDeaths$
WHERE total_deaths IS NOT NULL;

Select continent,MAX(CAST(total_deaths as int)) as Total_Death_Count
from [Portfolio Project]..CovidDeaths$
WHERE continent IS NOT NULL
GROUP By continent
order by Total_Death_Count desc;

--Showing Total count on global level
Select Sum(new_cases)as total_case, SUM(cast(new_deaths as int))as total_death,(SUM(cast(new_deaths as int))/Sum(new_cases))*100 as Death_Percentage
from [Portfolio Project]..CovidDeaths$
WHERE continent IS NOT NULL
--GROUP By date
Order by total_case desc

--LEt us Join Two Table--

select * from [Portfolio Project]..CovidDeaths$ Dea
join [Portfolio Project]..Covid_vaccination$ Vac
on Dea.location=Vac.location
and
Dea.date=Vac.date

--Total population Vs Vaccination

select dea.location,dea.date,dea.population,vac.new_vaccinations 
from [Portfolio Project]..CovidDeaths$ Dea
join [Portfolio Project]..Covid_vaccination$ Vac
on Dea.location=Vac.location
and
Dea.date=Vac.date
where Dea.continent is not null;

--Partition use

select dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(Cast(Vac.new_vaccinations as int)) over (partition by Dea.location order by Dea.location ,
Dea.date) as Rolling_people_vaccinated,(Rolling_people_vaccinated/population)*100 as Rolling_people_vaccinated_percent
from [Portfolio Project]..CovidDeaths$ Dea
join [Portfolio Project]..Covid_vaccination$ Vac
on Dea.location=Vac.location
and
Dea.date=Vac.date
where Dea.continent is not null;


--Use CTE

with popvssac(location,date,population,new_vaccination,Rolling_people_vaccinated)
as
(
select dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(Cast(Vac.new_vaccinations as int)) over (partition by Dea.location order by Dea.location ,
Dea.date) as Rolling_people_vaccinated--(Rolling_people_vaccinated/population)*100 as Rolling_people_vaccinated_percent
from [Portfolio Project]..CovidDeaths$ Dea
join [Portfolio Project]..Covid_vaccination$ Vac
on Dea.location=Vac.location
and
Dea.date=Vac.date
where Dea.continent is not null
)
select* from popvssac

Create view Percentofpopulationvaccinated as
select dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(Cast(Vac.new_vaccinations as int)) over (partition by Dea.location order by Dea.location ,
Dea.date) as Rolling_people_vaccinated--(Rolling_people_vaccinated/population)*100 as Rolling_people_vaccinated_percent
from [Portfolio Project]..CovidDeaths$ Dea
join [Portfolio Project]..Covid_vaccination$ Vac
on Dea.location=Vac.location
and
Dea.date=Vac.date
where Dea.continent is not null

