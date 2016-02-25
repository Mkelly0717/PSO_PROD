--------------------------------------------------------
--  DDL for View UDV_P1_PERCENT_COMPARE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_P1_PERCENT_COMPARE" ("PERCENT_MATCHED_R1", "PERCENT_MATCHED_R2", "PERCENT_MATCHED_R3") AS 
  WITH equal AS
  (SELECT COUNT(1) same
  FROM udt_llamasoft_data
  WHERE hasdemand     =1
  AND haslane         =1
  AND costtransitrank = 1
  ),
  notequal AS
  (SELECT COUNT(1) different
  FROM udt_llamasoft_data
  WHERE hasdemand              =1
  AND haslane                  =1
  AND NVL(costtransitrank,99) <> 1
  ),
 equal2 AS
  (SELECT COUNT(1) rank2
  FROM udt_llamasoft_data
  WHERE hasdemand     =1
  AND haslane         =1
  AND costtransitrank = 2
  ),
 equal3 AS
  (SELECT COUNT(1) rank3
  FROM udt_llamasoft_data
  WHERE hasdemand     =1
  AND haslane         =1
  AND costtransitrank = 3
  )
SELECT ROUND(same/(same + different)*100,2) percent_matched_r1
      ,ROUND(rank2/(rank2 + different)*100,2) percent_matched_r2
      ,ROUND(rank3/(rank3 + different)*100,2) percent_matched_r3
FROM equal,
  notequal,
    equal2,
    equal3
