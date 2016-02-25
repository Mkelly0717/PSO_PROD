--------------------------------------------------------
--  DDL for Table UDT_LLAMASOFT_DATA_BKUP
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_LLAMASOFT_DATA_BKUP" 
   (	"ITEM" VARCHAR2(20), 
	"SOURCE" VARCHAR2(50), 
	"SOURCE_PC" VARCHAR2(10), 
	"DEST" VARCHAR2(50), 
	"DEST_PC" VARCHAR2(10), 
	"TRANSLEADTIME" NUMBER, 
	"PRIORITY" NUMBER, 
	"U_EQUIPMENT_TYPE" VARCHAR2(20), 
	"HASDEMAND" NUMBER(1,0), 
	"HASLANE" NUMBER(1,0), 
	"COSTTRANSITRANK" NUMBER
   )