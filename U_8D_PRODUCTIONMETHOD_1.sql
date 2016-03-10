--------------------------------------------------------
--  DDL for Procedure U_8D_PRODUCTIONMETHOD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_8D_PRODUCTIONMETHOD" as

begin

execute immediate 'truncate table productionstep';

execute immediate 'truncate table productionyield';

execute immediate 'truncate table bom';

delete res where type = 4 and res <> ' ';

commit;

delete productionmethod;

commit;

end;
