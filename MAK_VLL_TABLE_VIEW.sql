--------------------------------------------------------
--  DDL for View MAK_VLL_TABLE_VIEW
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_VLL_TABLE_VIEW" ("STATUS", "SM_RECORD", "LOADID", "DEST", "SOURCE", "ITEM", "SCHEDSHIPDATE", "SCHEDARRIVDATE", "QTY", "ORDERID", "EFF_SR", "SFF_AR", "SRCNG_SR", "SRCNG_AR", "VALUE_SR", "VALUE_AR") AS 
  with ship_recs as
  (select vll.loadid, vll.dest, vll.source, vll.item, vll.schedshipdate,
    vll.schedarrivdate, vll.qty, vll.orderid, sm.eff, sm.sourcing, sm.value
     from vehicleloadline vll, loc l, item i, sim_sourcingmetric sm
    where l.loc                       = vll.dest and l.u_area = 'NA' -- and vll.dest='6100151873'
    and i.item                        = vll.item and i.u_stock = 'C' and sm.dest = vll.dest and
    sm.source                         = vll.source and sm.item = vll.item and( sm.eff =
    vll.schedshipdate and sm.category = 417 ) and sm.sourcing = 'ISS9DEL' and
    sm.value                          > 0 and vll.u_overallsts = 'A'
    and sm.simulation_name='AD'
 order by loadid asc, vll.schedarrivdate asc
  ), arrive_recs as
  (select vll.loadid, vll.dest, vll.source, vll.item, vll.schedshipdate,
    vll.schedarrivdate, vll.qty, vll.orderid, sm.eff, sm.sourcing, sm.value
     from vehicleloadline vll, loc l, item i, sim_sourcingmetric sm
    where l.loc                        = vll.dest and l.u_area = 'NA' --  and vll.dest='6100151873'
    and i.item                         = vll.item and i.u_stock = 'C' and sm.dest = vll.dest and
    sm.source                          = vll.source and sm.item = vll.item and( sm.eff =
    vll.schedarrivdate and sm.category = 418 ) and sm.sourcing = 'ISS9DEL' and
    sm.value                           > 0 and vll.u_overallsts = 'A'
    and sm.simulation_name='AD'
 order by loadid asc, vll.schedarrivdate asc
  )
 select 0 status, 0 sm_record, sr.loadid, sr.dest, sr.source, sr.item,
  sr.schedshipdate, sr.schedarrivdate, sr.qty, sr.orderid, sr.eff eff_sr,
  ar.eff sff_ar, sr.sourcing srcng_sr, ar.sourcing srcng_ar, sr.value value_sr,
  ar.value value_ar
   from ship_recs sr, arrive_recs ar
  where sr.loadid = ar.loadid and ar.schedarrivdate <= trunc( sysdate + 14 )
  and sr.sourcing = ar.sourcing
order by loadid asc, schedarrivdate asc
