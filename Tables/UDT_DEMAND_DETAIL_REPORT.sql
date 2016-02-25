--------------------------------------------------------
--  DDL for Table UDT_DEMAND_DETAIL_REPORT
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_DEMAND_DETAIL_REPORT" 
   (	"ITEM" VARCHAR2(50 CHAR), 
	"DEST" VARCHAR2(50 CHAR), 
	"TOTALDEMAND" NUMBER, 
	"TOTALMET" NUMBER, 
	"%MetOnLane" NUMBER, 
	"SOURCING" VARCHAR2(50 CHAR)
   )
