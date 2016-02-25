--------------------------------------------------------
--  DDL for Procedure U_93_PSTOPTIMIZER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_93_PSTOPTIMIZER" AS 
BEGIN

SCPOMGR.U_60_PST_STOREMETRICS;
SCPOMGR.u_60_PST_REPLENISHMENTS;
--SCPOMGR.U_8S_METRICS;
--SCPOMGR.U_8S_OPTMAP;

/* Post Production Table Updates */
scpomgr.u_100_check_tables;
u_100_igperror_hist_table;
/* End Post Production table updates */

/* Run the Plan Extract Procedure to populate udt_planarriv_extract */
scpomgr.u_60_create_planarriv_extract;

END U_93_PSTOPTIMIZER;
