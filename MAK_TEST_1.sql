--------------------------------------------------------
--  DDL for View MAK_TEST_1
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_TEST_1" ("LOC", "PRODUCTIONMETHOD", "PRODRATE", "RATE") AS 
  select y.loc, y.productionmethod, round( sum( maxcap / 80 ) ) prodrate, round(
  sum( maxcap / 80 ) ) * 2500 rate
   from udt_yield_na y
  where y.productionmethod in( 'INS', 'REP' ) and maxcap > 0 and yield > 0
group by y.loc, y.productionmethod
