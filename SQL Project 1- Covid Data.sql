
---- Data we will be looking at
Select Location, date, total_cases, new_cases, total_deaths, population
From portfolio..CovidDeaths$
Where continent is not null 
order by 1,2

--- Total Cases vs Total Deaths in India
Select Location, Date, total_deaths, total_cases, (total_deaths/total_cases)*100 as DeathPercent
From portfolio..CovidDeaths$
where location like '%India%'
and continent is not null
order by 1,2

-- Total Cases vs Population
Select Location, Date, population, total_cases, (total_cases/population)*100 as InfectionRate
From portfolio..CovidDeaths$
order by 1,2

---Countries with Highest Infection Rate compared to Population
Select Location, Population, max(total_cases) as HighestInfectionCount, ((max(total_cases)/Population))*100 as InfectionRate
From portfolio..CovidDeaths$
Where continent is not null
group by Location, Population
order by InfectionRate desc

--- Countries with Highest Death Count
Select Location, max(cast(total_deaths as int)) as DeathCount
From portfolio..CovidDeaths$
Where continent is not null
group by Location
order by DeathCount desc

-- Grouping Deaths by Continent
Select Continent, max(cast(total_deaths as int)) as DeathCount
From portfolio..CovidDeaths$
Where continent is not null
group by Continent
order by DeathCount desc

-- Global Death Rate

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From portfolio..CovidDeaths$
where continent is not null 
order by 1,2

-- Population vs People Vaccinated

Select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(CONVERT(INT, v.new_vaccinations)) over(partition by d.location order by d.location, 
d.date) as PeopleVaccinated
From portfolio..CovidDeaths$ d
join portfolio.. CovidVaccinations$ v
    on d.location= v.location
    and d.date = v.date
where d.continent is not null
order by 2,3


-- TEMP TABLE
drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 PeopleVaccinated numeric
 )

 Insert into #PercentPopulationVaccinated
 Select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(CONVERT(INT, v.new_vaccinations)) over(partition by d.location order by d.location, 
d.date) as PeopleVaccinated
From portfolio..CovidDeaths$ d
join portfolio.. CovidVaccinations$ v
    on d.location= v.location
    and d.date = v.date
where d.continent is not null

Select *, (PeopleVaccinated/Population)*100 as PercentVaccinated
From #PercentPopulationVaccinated

-- Create VIEW

Drop View if exists PercentPopulationVaccinated 
Create View PopulationVaccinated as    
Select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(CONVERT(INT, v.new_vaccinations)) over(partition by d.location order by d.location, 
d.date) as PeopleVaccinated
From portfolio..CovidDeaths$ d
join portfolio.. CovidVaccinations$ v
    on d.location= v.location
    and d.date = v.date
where d.continent is not null

Select *
From PopulationVaccinated

