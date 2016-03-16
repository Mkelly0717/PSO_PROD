--------------------------------------------------------
--  DDL for Procedure MAK_TEST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."MAK_TEST" as


v_delivery_issues_pen number;
v_delivery_ai_collections_pen number;
v_delivery_aw_collections_pen number;

begin
     
  select numval1 into v_delivery_issues_pen
    from udt_default_parameters dfp
    where dfp.name='DELIVERY_ISSUES_PENALTY' ;
    
  select numval1 into v_delivery_ai_collections_pen
    from udt_default_parameters dfp
    where dfp.name='DELIVERY_AI_COLLECTIONS_PENALTY' ;
    
  select numval1 into v_delivery_aw_collections_pen
    FROM UDT_DEFAULT_PARAMETERS DFP
    where dfp.name='DELIVERY_AW_COLLECTIONS_PENALTY' ;
    
    
dbms_output.put_line(  'V_DELIVERY_ISSUES_PEN         := ' || v_delivery_issues_pen );
dbms_output.put_line(  'V_DELIVERY_AI_COLLECTIONS_PEN := ' || v_delivery_ai_collections_pen );
dbms_output.put_line(  'V_DELIVERY_AW_COLLECTIONS_PEN := ' || V_DELIVERY_AW_COLLECTIONS_PEN);

end;
