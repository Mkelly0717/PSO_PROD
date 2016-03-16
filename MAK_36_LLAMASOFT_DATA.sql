--------------------------------------------------------
--  DDL for Procedure MAK_36_LLAMASOFT_DATA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."MAK_36_LLAMASOFT_DATA" 
IS
  /* This process update the udt_llamasoft_table for:
  1: Sets hasdemand=1 if demand exists for the dest
  2:
  */
  Begin_Date DATE;
  end_date date ;
  v_p1lcm Number := 1;
BEGIN
  -- replace date function when dates bevcome valid!!!!!!!!!
  -- SELECT U_14D_BEGIN_SKUCONSTRAINT into Begin_Date from dual;
  -- SELECT U_14D_END_SKUCONSTRAINT into End_Date from dual;
  select u_14d_begin_skuconstraint  into begin_date  from dual;
  SELECT u_14d_end_skuconstraint  INTO End_Date FROM dual;
  
/* Update HASDEMAND */
  UPDATE udt_llamasoft_data lld 
  SET lld.hasdemand = 0,
      lld.haslane=0,
      costtransitrank = null;
  COMMIT;
  
  UPDATE udt_llamasoft_data lld
  SET lld.hasdemand = 1
  WHERE EXISTS
    (SELECT 1
    FROM skuconstraint skc
    WHERE skc.loc =lld.dest
    AND skc.item  =lld.item
    AND skc.qty   > 0
    AND skc.eff BETWEEN Begin_date AND End_Date
    );
  COMMIT;

/* Update HASLANE */
  UPDATE udt_llamasoft_data lld SET lld.haslane = 0;
  COMMIT;
  
  UPDATE udt_llamasoft_data lld
  SET lld.haslane = 1
  WHERE EXISTS
    (SELECT 1
    FROM sourcing src
    WHERE src.source = lld.source
     and  src.dest=lld.dest
     AND src.item  =lld.item
    );
  COMMIT;
  
/* Update the costtransitrank */
update udt_llamasoft_data lld
set costtransitrank = (select ctr.rank 
             from udv_rank_costtransit ctr
            where ctr.source_pc=lld.source_pc
              and ctr.dest_pc=lld.dest_pc
              and lld.u_equipment_type=ctr.u_equipment_type
            );
commit;



/* Adjust the  tier Value to be 50 % of the actual value 
   For P1 values which are not already the lower cost lane */
execute immediate 'truncate table mak_COSTTIER_table';
insert into MAK_COSTTIER_TABLE 
(COST, SOURCE, DEST, VALUE, EFF, RANK)
  select cost ,
    source,
    dest ,
    value ,
    eff,
    dense_rank() over (partition by dest order by value asc) rank
  FROM mak_costtier_view
  order by dest ,
    rank;

execute immediate 'truncate table UDT_COSTTIER_P1_ADJUSTMENTS';
insert into UDT_COSTTIER_P1_ADJUSTMENTS
( cost, value, new_value)
select cost, value, new_value
from UDv_COSTTIER_P1_ADJUSTMENTS;


update costtier ct
set CT.value =
  (select new_value
  from UDT_COSTTIER_P1_ADJUSTMENTS P1NV
  where P1NV.cost=CT.cost
  )
where exists
  ( select 1 from UDt_COSTTIER_P1_ADJUSTMENTS P1NV2 where P1NV2.cost=CT.cost
  );
  
commit;

END;
