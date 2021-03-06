--------------------------------------------------------
--  DDL for Table UDT_PLANARRIV_EXTRACT_BKUP
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_PLANARRIV_EXTRACT_BKUP" 
   (	"RECNUM" NUMBER, 
	"FIRMSW" NUMBER, 
	"U_RATE_TYPE" CHAR(1 CHAR), 
	"U_CUSTORDERID" VARCHAR2(50 CHAR), 
	"LOADID" VARCHAR2(50 CHAR), 
	"ITEM" VARCHAR2(50 CHAR), 
	"SOURCE" VARCHAR2(50 CHAR), 
	"DEST" VARCHAR2(50 CHAR), 
	"NEEDARRIVDATE" DATE, 
	"SCHEDARRIVDATE" DATE, 
	"NEEDSHIPDATE" DATE, 
	"SCHEDSHIPDATE" DATE, 
	"QTY" NUMBER, 
	"SOURCING" VARCHAR2(50 CHAR), 
	"SOURCESTATUS" NUMBER, 
	"DESTSTATUS" NUMBER
   )
