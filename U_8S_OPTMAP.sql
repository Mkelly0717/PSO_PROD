--------------------------------------------------------
--  DDL for Procedure U_8S_OPTMAP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_8S_OPTMAP" as

Begin

--less than 1 minute

--step 1

    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERSKUMAP');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERSOURCINGMAP');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERRESMAP');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERPRODUCTIONMAP');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERLOCMAP');

    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERBASIS');
    DBMS_STATS.UNLOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERBASISCOUNT');
    
--do we do this???

--  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'OPTIMIZERSKUMAP');
--  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'OPTIMIZERSOURCINGMAP');
--  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'OPTIMIZERRESMAP');
--  DBMS_STATS.DELETE_TABLE_STATS (OwnName => 'scpomgr',TabName => 'OPTIMIZERPRODUCTIONMAP');

--step 2
-- Gather table stats with cascade true,incase you are manually gathering stats while the process was running
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERSKUMAP',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERSOURCINGMAP',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERRESMAP',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERPRODUCTIONMAP',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERLOCMAP',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);

    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERBASIS',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERBASISCOUNT',estimate_percent => dbms_stats.auto_sample_size , method_opt =>'for all indexed columns size auto', degree => 4, cascade => true);

-- Step 3
--Delete some of the  column stats for Process tables
    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'OPTIMIZERSKUMAP', COLNAME => 'SERVICEID', statown => 'scpomgr');
    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'OPTIMIZERSKUMAP', COLNAME => 'INSTANCEID', statown => 'scpomgr');

    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'OPTIMIZERSOURCINGMAP', COLNAME => 'SERVICEID', statown => 'scpomgr');
    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'OPTIMIZERSOURCINGMAP', COLNAME => 'INSTANCEID', statown => 'scpomgr');

    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'OPTIMIZERRESMAP', COLNAME => 'SERVICEID', statown => 'scpomgr');
    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'OPTIMIZERRESMAP', COLNAME => 'INSTANCEID', statown => 'scpomgr');


    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'OPTIMIZERPRODUCTIONMAP', COLNAME => 'SERVICEID', statown => 'scpomgr');
    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'OPTIMIZERPRODUCTIONMAP', COLNAME => 'INSTANCEID', statown => 'scpomgr');

    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'OPTIMIZERLOCMAP', COLNAME => 'SERVICEID', statown => 'scpomgr');
    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'OPTIMIZERLOCMAP', COLNAME => 'INSTANCEID', statown => 'scpomgr');


    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'OPTIMIZERBASIS', COLNAME => 'SERVICEID', statown => 'scpomgr');
    DBMS_STATS.DELETE_COLUMN_STATS(ownname=> 'scpomgr', tabname => 'OPTIMIZERBASIS', COLNAME => 'INSTANCEID', statown => 'scpomgr');

--step 4
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERSKUMAP');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERSOURCINGMAP');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERRESMAP');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERPRODUCTIONMAP');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERLOCMAP');

    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERBASIS');
    DBMS_STATS.LOCK_TABLE_STATS(ownname => 'scpomgr', tabname => 'OPTIMIZERBASISCOUNT');

End;
