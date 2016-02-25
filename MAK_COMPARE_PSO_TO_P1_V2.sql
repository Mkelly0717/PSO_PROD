--------------------------------------------------------
--  DDL for View MAK_COMPARE_PSO_TO_P1_V2
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_COMPARE_PSO_TO_P1_V2" ("STATUS", "CNT", "TOT_QTY") AS 
  select 'Total' status, count( 1 ) cnt, sum( co_qty ) tot_qty
     from mak_cust_table pe
    where status in( 1, 4 ) and pe.shipdate <= trunc( sysdate ) + 6
    union
   select 'Match' status, count( 1 ) cnt, sum( co_qty ) tot_qty
     from mak_cust_table pe
    where status in( 1, 4 ) and exists
    (select 1
       from udt_llamasoft_data llsft
      where pe.assigned_plant = llsft.source and pe.loc = llsft.dest and
      pe.co_item              = llsft.item
    ) and exists
    ( select 1 from udt_llamasoft_data ll where ll.dest = pe.loc
    ) and pe.shipdate <= trunc( sysdate ) + 6
    union
   select 'NOT-Match' status, count( 1 ) cnt, sum( co_qty ) tot_qty
     from mak_cust_table pe
    where status in( 1, 4 ) and not exists
    (select 1
       from udt_llamasoft_data llsft
      where pe.assigned_plant = llsft.source and pe.loc = llsft.dest and
      pe.co_item              = llsft.item
    ) and pe.shipdate        <= trunc( sysdate ) + 6
    union
   select 'CANT-Match' status, count( 1 ) cnt, sum( co_qty ) tot_qty
     from mak_cust_table pe
    where status in( 1, 4 ) and not exists
    (select 1
       from udt_llamasoft_data ll
      where ll.dest    = pe.loc and ll.item = pe.co_item
    ) and pe.shipdate <= trunc( sysdate ) + 6
