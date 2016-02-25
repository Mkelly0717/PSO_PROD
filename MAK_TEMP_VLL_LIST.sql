--------------------------------------------------------
--  DDL for View MAK_TEMP_VLL_LIST
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_TEMP_VLL_LIST" ("LOADID", "ITEM", "QTY", "SUPPLYMETHOD", "LOADLINEID", "CANCELSW", "REVISEDDATE", "ACTIONALLOWEDSW", "PRIMARYITEM", "DRAWQTY", "EXPDATE", "ACTION", "ACTIONDATE", "ACTIONQTY", "ORDERNUM", "FF_TRIGGER_CONTROL", "SOURCING", "MUSTGOQTY", "SEQNUM", "SCHEDSHIPDATE", "SCHEDARRIVDATE", "LBSOURCE", "ORDERID", "SUPPORDERQTY", "REVISEDEXPDATE", "SOURCE", "DEST", "GROUPORDERID", "PRIMARYITEMQTY", "SUPPLYID", "U_OVERALLSTS") AS 
  select vll."LOADID", vll."ITEM", vll."QTY", vll."SUPPLYMETHOD", vll.
    "LOADLINEID", vll."CANCELSW", vll."REVISEDDATE", vll. "ACTIONALLOWEDSW",
    vll."PRIMARYITEM", vll."DRAWQTY", vll."EXPDATE", vll."ACTION", vll.
    "ACTIONDATE", vll."ACTIONQTY", vll."ORDERNUM", vll."FF_TRIGGER_CONTROL",
    vll."SOURCING", vll."MUSTGOQTY", vll. "SEQNUM", vll."SCHEDSHIPDATE", vll.
    "SCHEDARRIVDATE", vll. "LBSOURCE", vll."ORDERID", vll."SUPPORDERQTY", vll.
    "REVISEDEXPDATE", vll."SOURCE", vll."DEST", vll. "GROUPORDERID", vll.
    "PRIMARYITEMQTY", vll."SUPPLYID", vll. "U_OVERALLSTS"
     from vehicleloadline vll, loc l
    where l.loc = vll.dest and l.u_area = 'NA' and vll.item like '4%RU%' and
    vll.schedarrivdate between trunc( sysdate ) and trunc( sysdate + 13 ) and
    vll.u_overallsts <> 'C'
