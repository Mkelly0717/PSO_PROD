--------------------------------------------------------
--  DDL for Table UDT_SUBSTITUTE
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_SUBSTITUTE" 
   (	"COUNTRY" VARCHAR2(2 CHAR), 
	"PARENT" VARCHAR2(15 CHAR), 
	"SUBORD" VARCHAR2(15 CHAR), 
	"BOMNUM" NUMBER(*,0), 
	"LOC" VARCHAR2(50 CHAR), 
	"UNIT_COST" NUMBER(*,0) DEFAULT 0
   )
