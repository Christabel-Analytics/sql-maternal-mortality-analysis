select *
from state

create table state (
state_id int,
state_name varchar(200),
geopolitical_zone varchar(200),
capital varchar(200),
est_population int);

create table maternal_info(
record_id int,
year int,
state varchar(200),
indicator varchar(250),
value int,
population int,
source varchar(100));

select *
from maternal_info
)





--kpis
--1 total cases
select count(record_id)
from maternal_info

--2 most reported region
select s.geopolitical_zone, count (m.record_id)
from maternal_info m
join state s
on m.state = s.state_name
group by  s.geopolitical_zone
order by count (m.record_id) desc
limit 1

--3 top contributing state
 select state,round(sum(value) *100.0 / sum(sum(value)) over(), 0)as contribution_percent
 from maternal_info
 group by state
 order by contribution_percent desc
 limit 1

--4 population adjusted rate
select round(sum(m.value)*100000.0/max(s.est_population),0) adjusted_rate 
from maternal_info m
join state s
on m.state= s.state_name


 
insights
--1 states by indicator value
select state,sum(value)
from maternal_info
group by state
order by sum(value)desc

--2cases by geopolitical zone
select s.geopolitical_zone,sum(m.value) sum_of_deaths
from maternal_info m
join state s
on s.state_name=m.state
group by geopolitical_zone
order by count(indicator) desc

--3 trend by year
select year,sum(value)
from maternal_info
where year is not null
group by year



--4 population adjusted rate per 100,000

select m.state, round(sum(m.value)*100000.0/max(s.est_population),0) adjusted_rate 
from maternal_info m
join state s
on m.state= s.state_name
group by m.state

--5 population impact
 select m.state, sum(m.value) count_of_deaths ,max(s.est_population) population
 from maternal_info m
 join state s
on m.state= s.state_name
group by m.state

 --6 highest deaths within each states
 with rank as(
 select state, indicator,sum(value) as deaths,
dense_rank() over(partition by state order by sum(value) desc) as highest_death_indicator
 from maternal_info 
 group by state, indicator
 order by sum(value) desc )

 select *
 from rank
 where highest_death_indicator = 1

 

