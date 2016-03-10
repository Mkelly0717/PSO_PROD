--------------------------------------------------------
--  DDL for Procedure U_8S_METRICS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_8S_METRICS" as

Begin

--less than 1 minute

--step 1

    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'PRODUCTIONMETRIC');
    --DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'UDT_PRODUCTIONMETRIC_WK');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'PRODUCTIONRESMETRIC');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGMETRIC');
    --DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'UDT_SOURCINGMETRIC_WK');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGRESMETRIC');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SKUMETRIC');
    --DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'UDT_SKUMETRIC_WK');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'RESMETRIC');
    
--do we do this???

  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'PRODUCTIONMETRIC');
  --DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'UDT_PRODUCTIONMETRIC_WK');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'PRODUCTIONRESMETRIC');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'SOURCINGMETRIC');
  --DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'UDT_SOURCINGMETRIC_WK');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'SOURCINGRESMETRIC');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'SKUMETRIC');
  --DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'UDT_SKUMETRIC_WK');
  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'RESMETRIC');

--step 2
-- Gather table stats with cascade true,incase you are manually gathering stats while the process was running
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'PRODUCTIONMETRIC',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    --DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'UDT_PRODUCTIONMETRIC_WK',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'PRODUCTIONRESMETRIC',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGMETRIC',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    --DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'UDT_SOURCINGMETRIC_WK',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGRESMETRIC',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'SKUMETRIC',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    --DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'UDT_SKUMETRIC_WK',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'RESMETRIC',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);

-- Step 3
--Delete some of the  column stats for Process tables
--    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'PRODUCTIONMETRIC', COLNAME => 'SERVICEID', statown => 'scpomgr');
--    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'PRODUCTIONRESMETRIC', COLNAME => 'INSTANCEID', statown => 'scpomgr');
--    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'SOURCINGMETRIC', COLNAME => 'SERVICEID', statown => 'scpomgr');
--    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'SOURCINGRESMETRIC', COLNAME => 'INSTANCEID', statown => 'scpomgr');
--    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'SKUMETRIC', COLNAME => 'SERVICEID', statown => 'scpomgr');
--    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'RESMETRIC', COLNAME => 'INSTANCEID', statown => 'scpomgr');

--step 4
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'PRODUCTIONMETRIC');
    --DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'UDT_PRODUCTIONMETRIC_WK');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'PRODUCTIONRESMETRIC');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGMETRIC');
    --DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'UDT_SOURCINGMETRIC_WK');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SOURCINGRESMETRIC');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'SKUMETRIC');
    --DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'UDT_SKUMETRIC_WK');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'RESMETRIC');

End;
