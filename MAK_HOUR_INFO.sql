--------------------------------------------------------
--  DDL for View MAK_HOUR_INFO
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_HOUR_INFO" ("RES", "NUMBER_PERIODS", "HOURS_AVAIL_TOTAL", "HOURS_USED_TOTAL", "MIN_HOURS_USED", "MAX_HOURS_USED", "AVG_HOURS", "SIGMA_HOURS", "AVG_PERCENT_UTIL", "PERCENT_TOTAL_USED") AS 
  SELECT rm.res ,
    COUNT(1) number_periods ,
    ROUND(SUM(rc.qty),2) hours_avail_total ,
    ROUND(SUM(rm.value)) hours_used_total ,
    ROUND(MIN(value),2) min_hours_used ,
    ROUND(MAX(value),2) max_hours_used ,
    ROUND(AVG(rm.value),2) avg_hours ,
    round(stddev(value),2) sigma_hours ,
    round(100*avg(rm.value/nullif(rc.qty,0)),2)      as avg_percent_util ,
    ROUND(100*SUM(rm.value)/nullif(SUM(rc.qty),0),2) AS percent_total_used
  FROM sim_resmetric rm ,
    resconstraint rc
  WHERE rm.category=401
  AND rm.qtyuom    =28
  AND rc.category  =12
  AND rm.res       =rc.res
  AND rm.eff       =rc.eff
  and rm.setup     =' '
  and rm.simulation_name='AD'
  GROUP BY rm.res
