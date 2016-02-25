--------------------------------------------------------
--  DDL for View MAK_PROD_RATE_SUMMARY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_PROD_RATE_SUMMARY" ("PY_LOC", "PY_ITEM", "PY_OI", "PY_PM", "PS_RES", "PRODRATE", "YIELDQTY", "NUMBER_PERIODS", "MIN_HRS_USED", "MAX_HRS_USED", "AVG_HRS_USED", "SIGMA_HRS_USED", "TOTAL_HRS_USED", "MIN_QTY_PRODUCED", "MAX_QTY_PRODUCED", "AVG_QTY_PRODUCED", "SIGMA_QTY_PRODUCED", "AVG_MAX_QTY_PER_WEEK", "AVG_PERCENT_CAPACITY_USED", "STDEV_PERCENT_CAPACITY_USED", "PERCENT_CAPACITY_USED") AS 
  select py1.loc py_loc
    ,py1.item py_item
    ,py1.outputitem py_oi
    ,py1.productionmethod py_pm
    ,ps.res ps_res
    ,nvl(ps.prodrate,0) prodrate
    ,py1.yieldqty
    ,COUNT(1) number_periods
    ,round(min(rm.value),2) min_hrs_used
    ,ROUND(MAX(rm.value),2) max_hrs_used
    ,round(avg(rm.value),2) avg_hrs_used
    ,ROUND(stddev(rm.value),2) sigma_hrs_used
    ,round(sum(rm.value),2) total_hrs_used
    ,ROUND(MIN(rm.value   *NVL(ps.prodrate,0)*py1.yieldqty),2) min_qty_produced
    ,round(max(rm.value   *nvl(ps.prodrate,0)*py1.yieldqty),2) max_qty_produced
    ,round(avg(rm.value   *nvl(ps.prodrate,0)*py1.yieldqty),2) avg_qty_produced
    ,round(stddev(rm.value*nvl(ps.prodrate,0)*py1.yieldqty),2) sigma_qty_produced
    ,(sum(rc.qty)         * nvl(ps.prodrate,0) * py1.yieldqty)/count(1)as avg_max_qty_per_week
    ,sum(rm.value)
    ,min(rc.qty)
    ,round(100            *avg(rm.value/nullif(rc.qty,0)),2) avg_percent_capacity_used
--  ,round(100            *stddev(rm.value/nullif(rc.qty,0)),2) stdev_percent_capacity_used
--  ,ROUND(100            *SUM(rm.value)/nullif(SUM(rc.qty),0),2) percent_capacity_used
  FROM productionyield py1 ,
    item i ,
    loc l ,
    productionstep ps ,
    sim_resmetric rm ,
    resconstraint rc
  WHERE py1.loc          =l.loc
  AND py1.item           =i.item
  AND py1.qtyuom         =18
  AND l.enablesw         =1
  AND i.enablesw         =1
  AND ps.loc             =py1.loc
  AND ps.productionmethod=py1.productionmethod
  AND ps.item            =py1.item
  AND ps.qtyuom          =28
  AND rm.res             =ps.res
  AND rm.category        =401
  AND rm.qtyuom          =28
  AND rc.res             =rm.res
  AND rc.qtyuom          =28
  AND rc.category        =12
  AND rc.eff             =rm.eff
  and rm.simulation_name='AD'
  GROUP BY py1.loc ,
    py1.item ,
    py1.outputitem ,
    py1.productionmethod ,
    ps.res ,
    NVL(ps.prodrate,0) ,
    py1.yieldqty
  ORDER BY py1.loc ,
    py1.productionmethod ,
    py1.item
