select * from dbo.CovidDeaths;
select * from dbo.CovidVaccinations;

-- Looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid

select 
location , date , population , total_cases , total_deaths , (cast(total_deaths AS float) /cast(total_cases AS float))*100 as DeathPercentage
from dbo.CovidDeaths
where location like '%states%'
order by 1,2;

-- looking at total population vs total cases

select 
location , date , population , total_cases , total_deaths , (cast(total_cases AS float) /cast(population AS float))*100 as CasesPercentage
from dbo.CovidDeaths
where location like '%states%'
order by 1,2;

-- Looking at countries with highest infection rate compared to population

select 
location , population , max(total_cases) as HighestInfectionCount ,  max(((cast(total_cases AS float) /cast(population AS float)))*100) as CasesPercentage
from dbo.CovidDeaths
group by location , population
order by CasesPercentage desc;

-- showing countries with highest death count per population

select 
location , population , max(total_deaths) as HighestDeathCount ,  max(((cast(total_deaths AS float) /cast(population AS float)))*100) as DeathPercentage
from dbo.CovidDeaths
group by location , population
order by HighestDeathCount desc;

-- Break things by continent

select 
location  , max(total_deaths) as HighestDeathCount  -- max(((cast(total_deaths AS float) /cast(population AS float)))*100) as DeathPercentage
from dbo.CovidDeaths
where continent is null
group by location
order by HighestDeathCount desc;

-- continents with highest death counts

select 
location , max(total_deaths) as HighestDeathCount
from dbo.CovidDeaths
where continent is null
group by location
order by HighestDeathCount desc;

--Global Numbers


select 
location , max(total_cases) as HighestcaseCount
from dbo.CovidDeaths
where continent is null
group by location
order by HighestcaseCount desc;

-- sum of deaths and cases

select
sum(cast(total_cases as int)) , sum(cast(total_deaths as int))
from dbo.CovidDeaths;

-- total population vs vaccination (date columns not present so join wont work) with CTE (use same colum to do some action)


with popvsvac (population, people_vaccinated, continent, date, location, new_vaccinations,rollingpopadd)
as
(
select 
population, people_vaccinated, continent, dbo.CovidDeaths.date, dbo.CovidDeaths.location, new_vaccinations,
sum(cast(dbo.[Covid Vaccinations2].new_vaccinations as  bigint)) 
over (partition by dbo.CovidDeaths.location order by dbo.CovidDeaths.location, dbo.CovidDeaths.date) as rollingpopadd -- rolling addition/count, here add is done till a new loaction comes up
from dbo.CovidDeaths 
join dbo.[Covid Vaccinations2]
	on dbo.CovidDeaths.location = dbo.[Covid Vaccinations2].location
	and dbo.CovidDeaths.date = dbo.[Covid Vaccinations2].date
where dbo.CovidDeaths.continent is not null
--order by 5,3; 
)

select *, (new_vaccinations/population)*100 as percentOfVacVsPop from popvsvac;









