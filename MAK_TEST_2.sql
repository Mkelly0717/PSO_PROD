--------------------------------------------------------
--  DDL for View MAK_TEST_2
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_TEST_2" ("LOC", "PRODMETH", "PRODRATE", "RATE") AS 
  select y.loc loc     , y.productionmethod prodmeth, round( sum( maxcap / 80 ) )
  prodrate            , round( sum( maxcap / 80 ) ) * 2500 rate
   from udt_yield_na y, productionstep ps
  where y.productionmethod in( 'INS', 'REP' ) and maxcap > 0 and yield > 0 and
  ps.loc                    = y.loc and ps.item = y.item and
  ps.productionmethod       = y.productionmethod and ps.qtyuom = 28
group by y.loc, y.productionmethod
order by y.loc, y.productionmethod asc
