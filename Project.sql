CREATE TABLE inpatientutilization 
(drg_definition varchar(500),
 provider_id int,
 provider_name varchar(100),
 provider_state char(2),
 hrr varchar(100),
 discharges decimal(18,2),
 covered_charges decimal(18,2),
 payments decimal(18,2),
 medicare_payments decimal(18,2),
 year int)
 
CREATE TABLE providerid AS
select 
	distinct provider_id,
			  provider_name	 
from inpatientutilization

CREATE TABLE drg_id AS 
SELECT distinct
        left(drg_definition,3) as drg_id, 
		split_part(drg_definition, '-', 2) as drg_description
FROM inpatientutilization

CREATE TABLE inpatientutilizationclean AS
SELECT left(drg_definition,3) as drg_id, 
		provider_id,
		provider_name,
		provider_state,
		hrr,
		discharges,
		covered_charges,
		payments,
		medicare_payments,
		year
FROM inpatientutilization

select 
	provider_id,
	provider_name,
	provider_state,
	sum(case when year=2016 then discharges else null end) as "2015 Provider Discharges",
	sum(case when year=2015 then discharges else null end) as "2016 Provider Discharges",
	cast(((sum(case when year=2016 then discharges else null end)-sum(case when year=2015 then discharges else null end))
	/sum(case when year=2015 then discharges else null end))*100 as decimal(18,2))as "YOY Percent Change"
from inpatientutilizationclean
group by
	provider_id,
	provider_name,
	provider_state