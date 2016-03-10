--------------------------------------------------------
--  DDL for Procedure MAK_LOAD_MP_DATA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."MAK_LOAD_MP_DATA" as

begin

execute immediate 'truncate table mak_mp_arrivals';


insert into mak_mp_arrivals
(orderid, source, dest, shipdate, arrivddate, item)
(
SELECT trim(SUBSTR(A,7,16)) orderid ,
  trim(SUBSTR(A,23,4)) source ,
  trim(SUBSTR(A,31,10)) dest ,
  to_date(SUBSTR(A,41,6),'YYMMDD') shipdate ,
  to_date(SUBSTR(A,57,6),'YYMMDD') arrivdate ,
  trim(replace(replace(SUBSTR(A,64,20),'-',''),' ',''))  item
FROM mak_mp_stage_arrivals
where A is not null and length(A) > 20
);

commit;

end;
