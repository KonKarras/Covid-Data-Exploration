-- Query 1: Global Numbers
Select SUM(new_cases)/10 as TotalCases, 
	   SUM(cast(new_deaths as int))/10 as TotalDeaths,
	   (SUM(cast(new_deaths as int))/(nullif(SUM(new_cases), 0)))*100 as DeathPercentage 
			                       -- nullif is used to avoid division by zero (0)
From PortfolioProject..CovidDeaths 
Where continent is not null
Order by 1,2

-- Query 2: Total Death Count per Continent
Select location as Location,
	   SUM(cast(new_deaths as int))/10 as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by location
Order by TotalDeathCount desc

-- Query 3: Population Infected Percentage per Country
Select Location, 
       population/10 as Population, 
	   MAX(cast(total_cases as float))/10 as HighestInfectionCount,
	   MAX(cast(total_cases as float)/cast(population as float))*100 as PopulationInfectedPercentage
From PortfolioProject..CovidDeaths
Group by Location, Population
Order by PopulationInfectedPercentage desc

-- Query 4: Population Infected Percentage per Country and by Date
Select Location, 
       population/10 as Population, 
	   date as Date,
	   MAX(cast(total_cases as float))/10 as HighestInfectionCount,
	   MAX(cast(total_cases as float)/cast(population as float))*100 as PopulationInfectedPercentage
From PortfolioProject..CovidDeaths
Group by Location, Population, Date
Order by PopulationInfectedPercentage desc
