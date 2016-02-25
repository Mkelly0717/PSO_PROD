--------------------------------------------------------
--  DDL for View CHRISTINE10_REPORT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."CHRISTINE10_REPORT" ("A1", "B1", "PS_RES", "PRODRATE", "YIELD_QTY", "ITEM", "OUTPUTITEM", "PRODMETH", "LOC", "LOC_TYPE", "DESCR", "STATE", "MAXCAP", "NUMBER_PERIODS", "HOURS_AVAIL_TOTAL", "HOURS_USED_TOTAL", "MIN_HOURS_USED", "MAX_HOURS_USED", "AVG_HOURS", "SIGMA_HOURS", "AVG_PERCENT_UTIL", "PERCENT_TOTAL_USED", "HRS_DY1", "HRS_DY2", "HRS_DY3", "HRS_DY4", "HRS_DY5", "HRS_DY6", "HRS_DY7", "HRS_DY8", "HRS_DY9", "HRS_DY10", "HRS_DY11", "HRS_DY12", "HRS_DY13", "HRS_DY14", "MIN_QTY_PRODUCED", "MAX_QTY_PRODUCED", "AVG_QTY_PRODUCED", "SIGMA_QTY_PRODUCED", "QTYMADE_DY1", "QTYMADE_DY2", "QTYMADE_DY3", "QTYMADE_DY4", "QTYMADE_DY5", "QTYMADE_DY6", "QTYMADE_DY7", "QTYMADE_DY8", "QTYMADE_DY9", "QTYMADE_DY10", "QTYMADE_DY11", "QTYMADE_DY12", "QTYMADE_DY13", "QTYMADE_DY14", "AVG_PERCENT_CAPACITY_USED", "STDEV_PERCENT_CAPACITY_USED", "PERCENT_CAPACITY_USED", "PERCENTUTIL_DY1", "PERCENTUTIL_DY2", "PERCENTUTIL_DY3", "PERCENTUTIL_DY4", "PERCENTUTIL_DY5", "PERCENTUTIL_DY6", "PERCENTUTIL_DY7", "PERCENTUTIL_DY8", "PERCENTUTIL_DY9", "PERCENTUTIL_DY10", "PERCENTUTIL_DY11", "PERCENTUTIL_DY12", "PERCENTUTIL_DY13", "PERCENTUTIL_DY14", "RANK") AS 
  WITH py1 AS
  (SELECT py1.loc loc ,
    py1.item item ,
    py1.productionmethod pm ,
    py1.outputitem oi ,
    py1.yieldqty yield_qty ,
    y.maxcap maxcap ,
    l.loc_type ,
    l.descr ,
    l.u_state state ,
    l.u_area
  FROM productionyield py1 ,
    loc l ,
    item i ,
    udt_yield_na y
  WHERE py1.loc         =l.loc
  AND l.u_area          ='NA'
  AND l.enablesw        =1
  AND i.item            =py1.item
  AND i.enablesw        =1
  AND y.loc             =py1.loc
  AND y.item            =py1.outputitem
  AND y.productionmethod=py1.productionmethod
  ORDER BY py1.loc ,
    py1.productionmethod ,
    py1.item
  ) ,
  comb AS
  (SELECT py1.pm
    || '_'
    || py1.item
    || '@'
    || py1.loc a1 ,
    py1.pm
    || '_'
    || py1.oi
    || '@'
    || py1.loc b1 ,
    ps.ps_res ps_res ,
    ps.prodrate ,
    py1.yield_qty yield_qty ,
    py1.item ,
    py1.oi outputitem ,
    py1.pm prodmeth ,
    py1.loc ,
    py1.loc_type ,
    py1.descr ,
    NVL(trim(py1.state),'NA') state ,
    py1.maxcap ,
    mkh.number_periods ,
    mkh.hours_avail_total ,
    mkh.hours_used_total ,
    mkh.min_hours_used ,
    mkh.max_hours_used ,
    mkh.avg_hours ,
    mkh.sigma_hours ,
    mkh.avg_percent_util ,
    mkh.percent_total_used
    /* Now add the Hours Used = rm.value per eff date */
    ,
    lead (ROUND(rm.value,2), 0,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS hrs_DY1 ,
    lead (ROUND(rm.value,2), 1,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS hrs_DY2 ,
    lead (ROUND(rm.value,2), 2,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS hrs_DY3 ,
    lead (ROUND(rm.value,2), 3,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS hrs_DY4 ,
    lead (ROUND(rm.value,2), 4,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS hrs_DY5 ,
    lead (ROUND(rm.value,2), 5,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS hrs_DY6 ,
    lead (ROUND(rm.value,2), 6,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS hrs_DY7 ,
    lead (ROUND(rm.value,2), 7,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS hrs_DY8 ,
    lead (ROUND(rm.value,2), 8,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS hrs_DY9 ,
    lead (ROUND(rm.value,2), 9,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS hrs_DY10 ,
    lead (ROUND(rm.value,2), 10,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff) AS hrs_DY11 ,
    lead (ROUND(rm.value,2), 11,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff) AS hrs_DY12 ,
    lead (ROUND(rm.value,2), 12,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff) AS hrs_DY13 ,
    lead (ROUND(rm.value,2), 13,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff) AS hrs_DY14
    /* Now add the Qty Produced = prodrate * prodyield * prodhours per eff date */
    ,
    ps.min_qty_produced ,
    ps.max_qty_produced ,
    ps.avg_qty_produced ,
    ps.sigma_qty_produced ,
    lead (ROUND(rm.value*ps.prodrate*py1.yield_qty,2), 0,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS qtymade_DY1 ,
    lead (ROUND(rm.value*ps.prodrate*py1.yield_qty,2), 1,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS qtymade_DY2 ,
    lead (ROUND(rm.value*ps.prodrate*py1.yield_qty,2), 2,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS qtymade_DY3 ,
    lead (ROUND(rm.value*ps.prodrate*py1.yield_qty,2), 3,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS qtymade_DY4 ,
    lead (ROUND(rm.value*ps.prodrate*py1.yield_qty,2), 4,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS qtymade_DY5 ,
    lead (ROUND(rm.value*ps.prodrate*py1.yield_qty,2), 5,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS qtymade_DY6 ,
    lead (ROUND(rm.value*ps.prodrate*py1.yield_qty,2), 6,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS qtymade_DY7 ,
    lead (ROUND(rm.value*ps.prodrate*py1.yield_qty,2), 7,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS qtymade_DY8 ,
    lead (ROUND(rm.value*ps.prodrate*py1.yield_qty,2), 8,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS qtymade_DY9 ,
    lead (ROUND(rm.value*ps.prodrate*py1.yield_qty,2), 9,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS qtymade_DY10 ,
    lead (ROUND(rm.value*ps.prodrate*py1.yield_qty,2), 10,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff) AS qtymade_DY11 ,
    lead (ROUND(rm.value*ps.prodrate*py1.yield_qty,2), 11,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff) AS qtymade_DY12 ,
    lead (ROUND(rm.value*ps.prodrate*py1.yield_qty,2), 12,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff) AS qtymade_DY13 ,
    lead (ROUND(rm.value*ps.prodrate*py1.yield_qty,2), 13,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff) AS qtymade_DY14 ,
    /* Now add the Percent Production Utilization per eff date */
    ps.avg_percent_capacity_used ,
    ps.stdev_percent_capacity_used ,
    ps.percent_capacity_used ,
    lead (ROUND(100*rm.value/NULLIF(rc.qty,0),2), 0,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS percentutil_DY1 ,
    lead (ROUND(100*rm.value/NULLIF(rc.qty,0),2), 1,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS percentutil_DY2 ,
    lead (ROUND(100*rm.value/NULLIF(rc.qty,0),2), 2,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS percentutil_DY3 ,
    lead (ROUND(100*rm.value/NULLIF(rc.qty,0),2), 3,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS percentutil_DY4 ,
    lead (ROUND(100*rm.value/NULLIF(rc.qty,0),2), 4,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS percentutil_DY5 ,
    lead (ROUND(100*rm.value/NULLIF(rc.qty,0),2), 5,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS percentutil_DY6 ,
    lead (ROUND(100*rm.value/NULLIF(rc.qty,0),2), 6,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS percentutil_DY7 ,
    lead (ROUND(100*rm.value/NULLIF(rc.qty,0),2), 7,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS percentutil_DY8 ,
    lead (ROUND(100*rm.value/NULLIF(rc.qty,0),2), 8,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS percentutil_DY9 ,
    lead (ROUND(100*rm.value/NULLIF(rc.qty,0),2), 9,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff)  AS percentutil_DY10 ,
    lead (ROUND(100*rm.value/NULLIF(rc.qty,0),2), 10,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff) AS percentutil_DY11 ,
    lead (ROUND(100*rm.value/NULLIF(rc.qty,0),2), 11,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff) AS percentutil_DY12 ,
    lead (ROUND(100*rm.value/NULLIF(rc.qty,0),2), 12,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff) AS percentutil_DY13 ,
    lead (ROUND(100*rm.value/NULLIF(rc.qty,0),2), 13,0 ) over (partition BY py1.loc, py1.item, py1.oi order by py1.loc, py1.item, py1.oi, rm.eff) AS percentutil_DY14 ,
    row_number() over (partition BY py1.loc, py1.item, py1.oi order by rm.eff ASC)                                                                AS rank
  FROM py1 py1 ,
    mak_prod_rate_summary ps ,
    res res ,
    sim_resmetric rm ,
    mak_hour_info mkh ,
    resconstraint rc
  WHERE py1.oi   =ps.py_oi
  AND py1.item   =ps.py_item
  AND py1.pm     =ps.py_pm --  and py1.loc='US8Y'
  AND ps.py_loc  =py1.loc
  AND ps.ps_res  =res.res
  AND res.loc    =py1.loc
  AND res.type   =4
  AND ps.py_item =py1.item
  AND rm.res     =res.res
  AND rm.category=401
  AND mkh.res    =res.res
  AND rc.res     =rm.res
  AND rc.qtyuom  =28
  AND rc.category=12
  AND rc.eff     =rm.eff
  and rm.simulation_name='AD'
  ORDER BY py1.loc -- , rm.eff  asc
  )
SELECT "A1",
  "B1",
  "PS_RES",
  "PRODRATE",
  "YIELD_QTY",
  "ITEM",
  "OUTPUTITEM",
  "PRODMETH",
  "LOC",
  "LOC_TYPE",
  "DESCR",
  "STATE",
  "MAXCAP",
  "NUMBER_PERIODS",
  "HOURS_AVAIL_TOTAL",
  "HOURS_USED_TOTAL",
  "MIN_HOURS_USED",
  "MAX_HOURS_USED",
  "AVG_HOURS",
  "SIGMA_HOURS",
  "AVG_PERCENT_UTIL",
  "PERCENT_TOTAL_USED",
  "HRS_DY1",
  "HRS_DY2",
  "HRS_DY3",
  "HRS_DY4",
  "HRS_DY5",
  "HRS_DY6",
  "HRS_DY7",
  "HRS_DY8",
  "HRS_DY9",
  "HRS_DY10",
  "HRS_DY11",
  "HRS_DY12",
  "HRS_DY13",
  "HRS_DY14",
  "MIN_QTY_PRODUCED",
  "MAX_QTY_PRODUCED",
  "AVG_QTY_PRODUCED",
  "SIGMA_QTY_PRODUCED",
  "QTYMADE_DY1",
  "QTYMADE_DY2",
  "QTYMADE_DY3",
  "QTYMADE_DY4",
  "QTYMADE_DY5",
  "QTYMADE_DY6",
  "QTYMADE_DY7",
  "QTYMADE_DY8",
  "QTYMADE_DY9",
  "QTYMADE_DY10",
  "QTYMADE_DY11",
  "QTYMADE_DY12",
  "QTYMADE_DY13",
  "QTYMADE_DY14",
  "AVG_PERCENT_CAPACITY_USED",
  "STDEV_PERCENT_CAPACITY_USED",
  "PERCENT_CAPACITY_USED",
  "PERCENTUTIL_DY1",
  "PERCENTUTIL_DY2",
  "PERCENTUTIL_DY3",
  "PERCENTUTIL_DY4",
  "PERCENTUTIL_DY5",
  "PERCENTUTIL_DY6",
  "PERCENTUTIL_DY7",
  "PERCENTUTIL_DY8",
  "PERCENTUTIL_DY9",
  "PERCENTUTIL_DY10",
  "PERCENTUTIL_DY11",
  "PERCENTUTIL_DY12",
  "PERCENTUTIL_DY13",
  "PERCENTUTIL_DY14",
  "RANK"
from comb d
WHERE d.rank=1
