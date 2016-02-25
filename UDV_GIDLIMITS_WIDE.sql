--------------------------------------------------------
--  DDL for View UDV_GIDLIMITS_WIDE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_GIDLIMITS_WIDE" ("LOC", "ITEM", "MANDLOC", "MANDLOC_2", "MANDLOC_3", "MANDLOC_4", "FORBLOC", "FORBLOC_1", "FORBLOC_2", "FORBLOC_3", "EXCLLOC", "EXCLLOC_1", "EXCLLOC_2", "EXCLLOC_3", "RANK") AS 
  with data as 
(  SELECT loc ,
    item ,
    lead (mandatory_loc, 0, NULL ) over (partition BY loc, item order by loc, item, mandatory_loc) AS MandLoc ,
    lead (mandatory_loc, 1, NULL ) over (partition BY loc, item order by loc, item, mandatory_loc) AS MandLoc_2 ,
    lead (mandatory_loc, 2, NULL ) over (partition BY loc, item order by loc, item, mandatory_loc) AS MandLoc_3 ,
    lead (mandatory_loc, 3, NULL ) over (partition BY loc, item order by loc, item, mandatory_loc) AS MandLoc_4 ,
    lead (forbidden_loc, 0, NULL ) over (partition BY loc, item order by loc, item, mandatory_loc) AS ForbLoc ,
    lead (forbidden_loc, 1, NULL ) over (partition BY loc, item order by loc, item, mandatory_loc) AS ForbLoc_1 ,
    lead (forbidden_loc, 2, NULL ) over (partition BY loc, item order by loc, item, mandatory_loc) AS ForbLoc_2 ,
    lead (forbidden_loc, 3, NULL ) over (partition BY loc, item order by loc, item, mandatory_loc) AS ForbLoc_3 ,
    lead (exclusive_loc, 0, NULL ) over (partition BY loc, item order by loc, item, mandatory_loc) AS ExclLoc ,
    lead (exclusive_loc, 1, NULL ) over (partition BY loc, item order by loc, item, mandatory_loc) AS ExclLoc_1 ,
    lead (exclusive_loc, 2, NULL ) over (partition BY loc, item order by loc, item, mandatory_loc) AS ExclLoc_2 ,
    lead (exclusive_loc, 3, NULL ) over (partition BY loc, item order by loc, item, mandatory_loc) AS ExclLoc_3
    ,row_number() over (partition BY loc, item order by loc, item, mandatory_loc) rank
    FROM udt_gidlimits_na
    ORDER BY loc ASC
)
select "LOC","ITEM","MANDLOC","MANDLOC_2","MANDLOC_3","MANDLOC_4","FORBLOC","FORBLOC_1","FORBLOC_2","FORBLOC_3","EXCLLOC","EXCLLOC_1","EXCLLOC_2","EXCLLOC_3","RANK"
from data
where rank=1
