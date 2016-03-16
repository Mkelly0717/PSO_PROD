--------------------------------------------------------
--  DDL for Procedure U_8D_SKU
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_8D_SKU" as

--about 15 minutes

begin

execute immediate 'truncate table skuconstraint';

execute immediate 'truncate table storagerequirement';

delete res where type = 9 and res <> ' ';

execute immediate 'truncate table skuexception';

execute immediate 'truncate table skuprojstatic';

execute immediate 'truncate table skustatstatic';

execute immediate 'truncate table skudemandparam';

execute immediate 'truncate table skudeploymentparam';

execute immediate 'truncate table skusafetystockparam'; 

execute immediate 'truncate table skuplanningparam';

execute immediate 'delete table sim_skumetric where simulation_name=''AD''';
commit;

execute immediate 'truncate table skupenalty';

execute immediate 'truncate table skuexternalfcst';

execute immediate 'truncate table dfutoskufcst';

delete custorder;

commit;

execute immediate 'truncate table vehicleloadline';

execute immediate 'truncate table dfutoskufcst';

execute immediate 'truncate table dfutosku';

delete sku;

commit;

end;
