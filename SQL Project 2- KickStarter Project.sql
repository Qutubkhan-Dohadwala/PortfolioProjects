-----
Skills used : Case Statement, Temp Tables, Rank Function, Aggregate Functions, Date Function

-----
Select *
From [Portfolio Project 2].. kickstarter_projects

-- Projects in which Category were most likely to reach their goals

Select category,
       count(id) as Success
From [Portfolio Project 2].. kickstarter_projects
where State = 'Successful'
group by category
order by count(id) desc

-- Did the dollar amount required have an impact on which goals were accomplished most often
Select country,
sum(Case When goal < 1000 and State = 'Successful' then 1 else 0 end) as 'Successes when Goal less than 1000' ,
sum(Case When goal between 1000 and 10000 and State = 'Successful' then 1 else 0 end) as 'Successes when Goal between 1000 and 10000',
sum(Case When goal > 10000 and State= 'Successful' then 1 else 0 end) as 'Successes when Goal greater than 10000'
From [Portfolio Project 2].. kickstarter_projects
group by country

-- Did the projects which were successful belong to different categories over the years

with info as (
       Select rank() over( partition by datepart(year, deadline) order by count(id) desc) as 'Rank',
       datepart(year, deadline) as Year,
       category,
       count(id) as Success
From [Portfolio Project 2].. kickstarter_projects
where State = 'Successful'
group by category, datepart(year, deadline) 
)

select *
from info
where rank = 1

-- Percentage of Projects successful in Music 
with music_info as (
    Select
     sum(Case When Category = 'Music' and State = 'Successful' then 1 else 0 end) as 'Successful_Music_Ventures',
     Sum(Case when Category = 'Music' then 1 else 0 end) as 'Total_Music_Projects'
from [Portfolio Project 2].. kickstarter_projects
)

Select
(Successful_Music_Ventures*100/Total_Music_Projects)  as 'Percent Success'
from music_info

-- Percentage of Projects successful in Films
with film_info as (
    Select
     sum(Case When Category = 'Film & Video' and State = 'Successful' then 1 else 0 end) as 'Successful_Film_Ventures',
     Sum(Case when Category = 'Film & Video' then 1 else 0 end) as 'Total_Film_Projects'
from [Portfolio Project 2].. kickstarter_projects
)

Select
(Successful_Film_Ventures*100/Total_Film_Projects)  as 'Percent Success'
from film_info
