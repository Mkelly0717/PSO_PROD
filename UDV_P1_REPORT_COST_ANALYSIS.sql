--------------------------------------------------------
--  DDL for View UDV_P1_REPORT_COST_ANALYSIS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_P1_REPORT_COST_ANALYSIS" ("SM_ITEM", "SM_DEST", "SM_DEST_5ZIP", "SM_SRC", "SM_SRC_5ZIP", "SM_ET", "SM_QTY", "SM_RANK", "SM_P1", "SM_COST", "SM1_RANK", "SM1_SRC", "SM1_SRC_5ZIP", "SM1_QTY", "SM1_COST", "P1_TOTALCOST", "SM1_TOTALCOST", "SAVINGS") AS 
  select sm.item sm_item
      , sm.dest sm_dest
      , sm.dest_5zip sm_dest_5zip
      , sm.src sm_src
      , sm.src_5zip sm_src_5zip
      , sm.et sm_et
      , sm.qty sm_qty
      , sm.rank sm_rank
      , sm.p1 sm_p1
      , sm.value sm_cost
      , smr1.rank sm1_rank
      , smr1.src sm1_src
      , smr1.src_5zip sm1_src_5zip
      , smr1.qty sm1_qty
      , smr1.value sm1_cost
      , sm.value   * smr1.qty                as p1_totalcost
      , smr1.value * smr1.qty                as sm1_totalcost
      , ( sm.value - smr1.value ) * smr1.qty as savings
    from udv_p1_sm_ls sm
      , udv_p1_sm_ls smr1
    where sm.p1 is not null
        and sm.rank <> sm.p1
        and sm.item=smr1.item
        and sm.dest=smr1.dest
        and sm.et=smr1.et
        and sm.sourcing=smr1.sourcing
        and smr1.rank=1
    order by sm.item asc
      , sm.dest asc
