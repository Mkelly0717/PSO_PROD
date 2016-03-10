--------------------------------------------------------
--  DDL for Procedure U_01_UPDATE_UDT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_01_UPDATE_UDT" as

begin

execute immediate 'truncate table scpomgr.udt_yield';

insert into scpomgr.udt_yield

select *
from stgmgr.udt_yield

commit;

end;
