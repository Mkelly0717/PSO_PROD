--------------------------------------------------------
--  DDL for View MAK_ORDS_SUMMARY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_ORDS_SUMMARY" ("SUBSET", "TOTAL") AS 
  select 'ALL_PLANARRIV_TO_RETURN' subset, count(1) Total
from udt_planarriv_extract
where firmsw=1
union
select 'ALL_MP_TO_RETURN' subset, count(1) Total
from mak_mp_arrivals
where item like '%RU%'
union
select 'MAK_ORDS_IN_MP_NOT_PSO' subset, count(1) Total
from MAK_ORDS_IN_MP_NOT_PSO
union
select 'MAK_ORDS_IN_PSO_NOT_MP' subset, count(1) Total
from MAK_ORDS_IN_PSO_NOT_MP
union
select 'MAK_ORDS_MP_MATCHES_PSO' subset, count(1) Total
from MAK_ORDS_MP_MATCHES_PSO
union
select 'MAK_ORDS_MP_NOT_MATCH_PSO' subset, count(1) Total
from MAK_ORDS_MP_NOT_MATCH_PSO
union
select 'MAK_ORDS_IN_MP_NFIRM_PSO' subset, count(1) Total
from MAK_ORDS_IN_MP_NFIRM_PSO
union
select 'MAK_ORDS_IN_BOTH' subset, count(1) Total
from MAK_ORDS_IN_BOTH
