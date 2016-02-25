--------------------------------------------------------
--  DDL for View UDV_COSTTIER_RANK
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_COSTTIER_RANK" ("COST", "DEST", "SOURCE", "VALUE", "RANK") AS 
  SELECT cost ,
    dest ,
    source ,
    value ,
    dense_rank() over (partition BY dest order by value ASC) rank
  FROM mak_costtier_table
  ORDER BY dest ,
    rank
