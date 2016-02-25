--------------------------------------------------------
--  DDL for View MAK_COSTTIER_VIEW
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_COSTTIER_VIEW" ("COST", "SOURCE", "DEST", "VALUE", "EFF") AS 
  SELECT ct.cost,
    SUBSTR(ct.cost ,instr(ct.cost,'_',1) +1 ,instr(ct.cost,'->') - instr(ct.cost,'_',1)-1 ) source,
    SUBSTR(ct.cost ,instr(ct.cost,'->',1)+2 ,instr(ct.cost,'-',-1) - instr(ct.cost,'->',1)-2 ) dest,
    ct.value,
    ct.eff
  FROM costtier ct, loc l
  where category='303'
  and cost like 'ISS%'
  and l.loc = substr(ct.cost ,instr(ct.cost,'->',1)+2 ,instr(ct.cost,'-',-1) - instr(ct.cost,'->',1)-2 )
  and l.u_area='NA'
