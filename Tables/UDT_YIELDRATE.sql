--------------------------------------------------------
--  DDL for Table UDT_YIELDRATE
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_YIELDRATE" 
   (	"PLANT" VARCHAR2(4 CHAR), 
	"MATERIAL" VARCHAR2(10 CHAR), 
	"BATCH" VARCHAR2(25 CHAR), 
	"QUANTITY" NUMBER(*,0), 
	"PRIMARY_KEY_COL" NUMBER, 
	"PRODUCTIONMETHOD" VARCHAR2(4 CHAR) DEFAULT ' '
   )
