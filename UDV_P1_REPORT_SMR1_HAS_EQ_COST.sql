--------------------------------------------------------
--  DDL for View UDV_P1_REPORT_SMR1_HAS_EQ_COST
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_P1_REPORT_SMR1_HAS_EQ_COST" ("LS_ITEM", "LS_DEST", "LS_DEST_PC", "LS_SRC", "LS_SOURCE_PC", "LS_ET", "LS_QTY", "LS_RANK", "LS_LLAMA_P1", "LS_COST", "SMR1_RANK", "SMR1_LLAMA_P1", "SMR1_SRC", "SMR1_SOURCE_PC", "SMR1_QTY", "SMR1_COST", "SMR1_TOTALCOST", "LS_TOTALCOST", "SAVINGS") AS 
  SELECT sm.sm_item ls_item ,
    sm.sm_dest ls_dest ,
    sm.ct_dest_pc ls_dest_pc ,
    sm.sm_src ls_src ,
    sm.ct_source_pc ls_source_pc ,
    sm.ct_et ls_et ,
    sm.sm_value ls_qty ,
    sm.sm_rank ls_rank ,
    sm.ls_priority ls_llama_p1 ,
    sm.ct_cost ls_cost ,
    smr1.sm_rank smr1_rank ,
    NVL(smr1.ls_priority,NULL) smr1_llama_p1 ,
    smr1.sm_src smr1_src ,
    smr1.ct_source_pc smr1_source_pc ,
    smr1.sm_value smr1_qty ,
    smr1.ct_cost smr1_cost ,
    smr1.sm_value * smr1.ct_cost                   AS smr1_totalcost ,
    smr1.sm_value * sm.ct_cost                     AS ls_totalcost ,
    ( sm.ct_cost  - smr1.ct_cost ) * smr1.sm_value AS savings
  FROM udv_p1_report_v2 sm ,
    udv_p1_report_v2 smr1
  WHERE sm.ls_priority IS NOT NULL
  AND sm.sm_rank       <> sm.ls_priority
  AND sm.sm_item        =smr1.sm_item
  AND sm.sm_dest        =smr1.sm_dest
  AND sm.ct_et          =smr1.ct_et
    --  AND sm.sm_sourcing    =smr1.sm_sourcing
  AND smr1.sm_rank =1
  AND smr1.ct_cost = sm.ct_cost
  ORDER BY sm.sm_item ASC ,
    sm.sm_dest ASC
