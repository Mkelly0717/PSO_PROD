--------------------------------------------------------
--  DDL for Table UDT_DEMAND_DETAIL_REPORT_OLD
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_DEMAND_DETAIL_REPORT_OLD" 
   (	"ITEM" VARCHAR2(50 CHAR), 
	"DEST" VARCHAR2(50 CHAR), 
	"SOURCE" VARCHAR2(50 CHAR), 
	"TOTALDEMAND" NUMBER, 
	"TOTALMET" NUMBER, 
	"EFF_DATE" DATE, 
	"%MetOnLane" NUMBER, 
	"SOURCING" VARCHAR2(50 CHAR), 
	"STATE" VARCHAR2(50 CHAR)
   )
