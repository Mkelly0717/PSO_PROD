--------------------------------------------------------
--  DDL for Table UDT_TPM_CORRECTIONS
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_TPM_CORRECTIONS" 
   (	"LOC" VARCHAR2(50 CHAR), 
	"ITEM" VARCHAR2(50 CHAR), 
	"EFF" DATE, 
	"ORIG_QTY" FLOAT(126), 
	"ADJUSTMENT_QTY" FLOAT(126), 
	"CORRECTED_QTY" FLOAT(126), 
	"CATEGORY" NUMBER(38,0)
   )
