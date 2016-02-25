--------------------------------------------------------
--  DDL for Procedure U_8S_SOURCING
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_8S_SOURCING" as

Begin

--about 5 minutes

--step 1

    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCING');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGDRAW');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGYIELD');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGREQUIREMENT');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGCONSTRAINT');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SKU');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SKUCONSTRAINT');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'RESCONSTRAINT');
    
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'CUSTORDER');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'PLANARRIV');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'PLANORDER');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'DFUTOSKUFCST');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'FCST');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'RES');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'COST');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'COSTTIER');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'RESCOST');
    
--do we do this???

  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'SOURCING');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'SOURCINGDRAW');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'SOURCINGYIELD');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'SOURCINGREQUIREMENT');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'SOURCINGCONSTRAINT');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'SKU');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'SKUCONSTRAINT');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'RESCONSTRAINT');
  
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'CUSTORDER');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'PLANARRIV');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'PLANORDER');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'DFUTOSKUFCST');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'FCST');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'RES');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'COST');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'COSTTIER');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'RESCOST');

--step 2
-- Gather table stats with cascade true,incase you are manually gathering stats while the process was running
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCING',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGDRAW',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGYIELD',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGREQUIREMENT',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGCONSTRAINT',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'SKU',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'SKUCONSTRAINT',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'RESCONSTRAINT',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'CUSTORDER',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'PLANARRIV',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'PLANORDER',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'DFUTOSKUFCST',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'FCST',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'RES',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'COST',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'COSTTIER',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'RESCOST',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);

-- Step 3
--Delete some of the  column stats for Process tables
--    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'PRODUCTIONMETRIC', COLNAME => 'SERVICEID', statown => 'scpomgr');
--    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'PRODUCTIONRESMETRIC', COLNAME => 'INSTANCEID', statown => 'scpomgr');
--    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'SOURCINGMETRIC', COLNAME => 'SERVICEID', statown => 'scpomgr');
--    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'SOURCINGRESMETRIC', COLNAME => 'INSTANCEID', statown => 'scpomgr');
--    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'SKUMETRIC', COLNAME => 'SERVICEID', statown => 'scpomgr');
--    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'RESMETRIC', COLNAME => 'INSTANCEID', statown => 'scpomgr');

--step 4
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCING');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGDRAW');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGYIELD');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGREQUIREMENT');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGCONSTRAINT');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SKU');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SKUCONSTRAINT');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'RESCONSTRAINT');
    
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'CUSTORDER');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'PLANARRIV');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'PLANORDER');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'DFUTOSKUFCST');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'FCST');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'RES');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'COST');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'COSTTIER');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'RESCOST');

End;
