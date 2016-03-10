--------------------------------------------------------
--  DDL for Procedure U_92_PREOPTIMIZER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_92_PREOPTIMIZER" AS 
BEGIN

scpomgr.U_15_SKU_DAILY;  -- create skuconstraint

-- 11/30/2015 RFD Comment out for now to prevent U_30_SRC_DAILY from being called so U_8D_Sourcing will not delete sourcing data.
-- 12/16/2015 JB removed --comment -- for U_30_SRC_DAILY; sourcing deletion logic restricted to NA; updated sourcing logic for NA from TST
-- 01/14/2016 JB added resource constraints
scpomgr.u_29_prd_resconstraint_dy;

scpomgr.U_30_SRC_DAILY;  

scpomgr.u_33_src_delivery;

scpomgr.u_33_src_delivery_constraints;

scpomgr.u_34_src_outhandling;

SCPOMGR.U_35_TPM_CORRECTIONS;

/* Update the table UDT_LLAMASOFT_DATA according to the new demand and lenes.
  Then set the costtier value to be updated by a factor of udt_default_parameter.p1lcm.
*/
SCPOMGR.MAK_36_LLAMASOFT_DATA;

-- RFD 02/05/2016 - Moved these to a seperate step JBPSO1_U_8S_GATHER_STATS
--scpomgr.u_8s_sourcing;
--SCPOMGR.U_8D_EXCEPTIONS;

END U_92_PREOPTIMIZER;
