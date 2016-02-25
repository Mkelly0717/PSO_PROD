--------------------------------------------------------
--  DDL for Table UDT_COST_UNIT
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_COST_UNIT" 
   (	"LOC" VARCHAR2(50 CHAR), 
	"COMPANY" VARCHAR2(4 CHAR) DEFAULT ' ', 
	"MATCODE" VARCHAR2(5 CHAR), 
	"PROCESS" VARCHAR2(15 CHAR), 
	"UNIT_COST" NUMBER DEFAULT 0
   )
