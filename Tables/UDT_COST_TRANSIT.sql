--------------------------------------------------------
--  DDL for Table UDT_COST_TRANSIT
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_COST_TRANSIT" 
   (	"SOURCE_CO" VARCHAR2(2 CHAR) DEFAULT ' ', 
	"SOURCE_PC" VARCHAR2(8 CHAR) DEFAULT ' ', 
	"DEST_CO" VARCHAR2(2 CHAR) DEFAULT ' ', 
	"DEST_PC" VARCHAR2(8 CHAR) DEFAULT ' ', 
	"SALESGROUP" VARCHAR2(8 CHAR) DEFAULT ' ', 
	"TRANSITTIME" NUMBER DEFAULT 0, 
	"COST_KM" NUMBER DEFAULT 0, 
	"COST_PALLET" NUMBER DEFAULT 0, 
	"PRIMARY_KEY_COL" NUMBER, 
	"DISTANCE" NUMBER(24,6) DEFAULT 0, 
	"U_RATE_TYPE" VARCHAR2(1 CHAR) DEFAULT 'U', 
	"SOURCE_GEO" VARCHAR2(4 CHAR), 
	"DEST_GEO" VARCHAR2(4 CHAR), 
	"DIRECTION" VARCHAR2(4 CHAR) DEFAULT ' '
   )
