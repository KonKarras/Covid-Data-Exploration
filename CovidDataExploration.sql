-- COVID DATA EXPLORATION

-- Queries 1 and 2: Datasets' check
-- Simply starting with displaying the two datasets we will be working with.

Select * 
From PortfolioProject..CovidDeaths
Order by 3,4 -- sorting out by Location and Date

Select * 
From PortfolioProject..CovidVaccinations
Order by 3,4 -- sorting out by Location and Date

-- Query 3: 
-- Displaying specific columns we might be interested in.

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2 -- sorting out by Location and Date

-- Query 4: Total Deaths vs Total Cases
-- Showing likelihood of dying if infected by Covid in each country.

Select Location, 
       date as Date, 
       total_cases/10 as TotalCases, 
	   total_deaths/10 as TotalDeaths,
	   (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where Location like '%greece%'-- specifying the country of interest
	  and continent is not null -- specifying the entries which only refer to countries  
Order by 1,2

-- Query 5: Total Cases vs Population
-- Showing percentage of population infected by Covid in each country.

Select Location, 
       date as Date,
       population/10 as Population, 
	   cast(total_cases as numeric)/10 as TotalCases,
	   (cast(total_cases as float)/cast(population as float))*100 as CasePercentage
From PortfolioProject..CovidDeaths
-- Where Location like '%greece%'
Order by 1,2

-- Query 6: Highest Infection Rate per Country
-- Showing countries with Highest Infection Rate compared to their Population.

Select Location, 
       population/10 as Population, 
	   MAX(cast(total_cases as float))/10 as HighestInfectionCount,
	   MAX(cast(total_cases as float)/cast(population as float))*100 as PopulationInfectedPercentage
From PortfolioProject..CovidDeaths
-- Where Location like '%greece%'
Group by Location, population
Order by PopulationInfectedPercentage desc -- sorting out by descending order

-- Query 7: Highest Death Count per Country
-- Showing countries with Highest Death Count per Population.

Select Location, 
	   MAX(cast(total_deaths as int)/10) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
Order by TotalDeathCount desc -- sorting out by descending order


-- Query 8: Highest Death Count per Continent
-- Showing continents with Highest Death Count per Population.

Select continent as Continent, 
	   MAX(cast(total_deaths as int)/10) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc 

-- Query 9: Global Numbers
-- Showing some universal day by day information.

Select date as Date,
       SUM(new_cases)/10 as TotalCases, 
	   SUM(cast(new_deaths as int))/10 as TotalDeaths,
	   (SUM(cast(new_deaths as int))/(nullif(SUM(new_cases), 0)))*100 as DeathPercentage 
			                       -- nullif is used to avoid division by zero (0)
From PortfolioProject..CovidDeaths 
Where continent is not null
Group by date
Order by 1,2

-- Query 10: Vaccinations vs Population
-- Showing the Rolling Daily Count of vaccinated (with at least one vaccine) people in each country.

Select dea.continent as Continent, 
       dea.location as Location,
	   dea.date as Date, 
	   dea.population/10 as Population, 
	   cast(vac.new_vaccinations as numeric)/10 as NewVaccinations,
	   SUM(cast(vac.new_vaccinations as float)) over 
	   (Partition by dea.location -- separating by Location
	   Order by dea.location, dea.date) -- sorting out by Location and Date
	   as RollingCountOfVaccinatedPeople 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac -- joining the two datasets together, 
                                             -- based on Location and Date
	 on dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
Order by 2,3 -- sorting out by Location and Date

-- Query 11: CTE
-- Creating a Common Table Expression which temporarily stores the previous query's results,
-- this time added with the Rolling Daily Percentage of vaccinated 
-- (with at least one vaccine) people in each country.

With VACvsPOP (Continent, Location, Date, Population, NewVaccinations, RollingCountOfVaccinatedPeople)
as
(
Select dea.continent, dea.location, dea.date, dea.population/10, vac.new_vaccinations,
	   SUM(cast(vac.new_vaccinations as float)) over
	   (Partition by dea.location 
	   Order by dea.location, dea.date) 
	   as RollingCountOfVaccinatedPeople
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	 on dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingCountOfVaccinatedPeople/Population)*100 as RollingPercentageOfVaccinatedPeople
From VACvsPOP

-- Query 12: Temp Table
-- Creating a Temporary Table which temporarily stores the previous query's results.

Drop Table if exists #VaccinatedPopulationPercentage -- deleting the temp table, 
                                                     -- in case the query gets run multiple times
Create Table #VaccinatedPopulationPercentage -- actually creating the temp table
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
NewVaccinations numeric,
RollingCountOfVaccinatedPeople numeric
)

Insert into #VaccinatedPopulationPercentage -- inserting the previous query's results 
                                            -- into the temp table we just created
Select dea.continent, dea.location, dea.date, dea.population/10, vac.new_vaccinations,
	   SUM(cast(vac.new_vaccinations as float)) over
	   (Partition by dea.location 
	   Order by dea.location, dea.date) 
	   as RollingCountOfVaccinatedPeople
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	 on dea.location = vac.location
	 and dea.date = vac.date

Select *, (RollingCountOfVaccinatedPeople/Population)*100 as RollingPercentageOfVaccinatedPeople
From #VaccinatedPopulationPercentage

-- Query 13: View 
-- Creating a View which temporarily stores the previous query's results, 
-- ready for later visualizations.

Create View VaccinatedPopulationPercentage
as
Select dea.continent as Continent, 
       dea.location as Location, 
	   dea.date as Date, 
	   dea.population/10 as Population,
	   vac.new_vaccinations as NewVaccinations,
	   SUM(cast(vac.new_vaccinations as float)) over
	   (Partition by dea.location 
	   Order by dea.location, dea.date) 
	   as RollingCountOfVaccinatedPeople
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	 on dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null

Select *
From VaccinatedPopulationPercentage