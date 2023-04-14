# Covid Data Exploration

Exploration project conducted on data provided through the following link: https://ourworldindata.org/covid-deaths

After downloading the original .csv file, containing all data from 1-1-2020 onwards, we split it into two .xlsx files; 

the Covid Deaths and the Covid Vaccinations, which we later import into SSMS to create the two tables we will be working with.

The actual exploration takes place across 13 different SQL queries:

1) Covid Deaths dataset's check,

2) Covid Vaccinations dataset's check,

3) Selecting possibly interesting columns,

4) Total Deaths vs Total Cases,

5) Total Cases vs Population,

6) Highest Infection Rate per Country,

7) Highest Death Count per Country,

8) Highest Death Count per Continent,

9) Global Numbers,

10) Vaccinations vs Population,

11) CTE (Common Table Expression) on previous query,

12) Temp(orary) Table on previous query and

13) View on previous query.

In a future update, some of those queries will give interesting visualizations on Tableau, resulting in valuable insights.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Update: Covid Dashboard

This update includes a new .sql file (TableauCovidQueries.sql) with 4 queries, quite similar to those in the initial .sql file (CovidDataExploration.sql), though a bit modified, so that they serve the purposes of the desired outcome. 

These queries are later brought into Excel, to be cleaned and prepared for Tableau. More precisely, the cleaning process consists of transforming NULL values and Date columns, so that they can be recognized appropriately by Tableau. 

Only then, those .xlsx files can be properly imported in Tableau, resulting in 4 different visualizations and, of course, the final dashboard.

In particular:

1) a simple table, breaking down some significant Global Numbers,

2) a bar chart, showing the Total Death Count per Continent,

3) a global map, showing the Percentage of Infected Population per Country and 

4) a line graph, showing the Current as well as the Estimated Percentage of Infected Population per Country over time.

A glimpse of the produced dashboard can be found in the .png file, however I would highly recommend taking advantage of the Tableau's interactive capabilities through the .twbx file or directly through the link below:

https://public.tableau.com/app/profile/konstantinos.karras/viz/CovidDashboard_16814176536910/CovidStats
