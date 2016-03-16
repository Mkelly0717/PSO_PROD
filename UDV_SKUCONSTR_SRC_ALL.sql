--------------------------------------------------------
--  DDL for View UDV_SKUCONSTR_SRC_ALL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_SKUCONSTR_SRC_ALL" ("ITEM", "LOC", "TOTALDEMAND", "TOTALSRC", "LOC_TYPE", "POSTALCODE", "U_3DIGITZIP", "COUNTRY", "U_AREA", "U_MAX_SRC", "U_MAX_DIST", "ENABLESW") AS 
  with total_demand( item, loc, totaldemand ) as
  (select skc.item, skc.loc, round( sum( skc.qty ), 1 ) as totaldemand
     from skuconstraint skc
    where skc.category in( 1, 6 ) and skc.qty > 0
 group by skc.item, skc.loc
  ), total_src( item, loc, totalsrc ) as
  (select skc1.item, skc1.loc, nvl( count( 1 ), 0 )
     from sourcing src, total_demand skc1
    where skc1.item = src.item(+) and skc1.loc = src.dest(+) and src.item is
    not null
 group by skc1.item, skc1.loc
    union
   select skc1.item, skc1.loc, 0
     from sourcing src, total_demand skc1
    where skc1.item = src.item(+) and skc1.loc = src.dest(+) and src.item is
    null
  )
 select td.item, td.loc, td.totaldemand, ts.totalsrc
, l.loc_type, l.postalcode, l.u_3digitzip, l.country
, l.u_area, l.u_max_src, l.u_max_dist, l.enablesw
   from total_demand td, total_src ts, loc l
  where td.item = ts.item and td.loc = ts.loc and l.loc = td.loc
    and l.u_area='NA'
