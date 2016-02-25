--------------------------------------------------------
--  DDL for Table MAK_COST_TRANSIT_NA
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."MAK_COST_TRANSIT_NA" 
   (	"DIRECTION" VARCHAR2(2 CHAR), 
	"SOURCE_CO" VARCHAR2(2 CHAR), 
	"SOURCE_PC" VARCHAR2(8 CHAR), 
	"DEST_CO" VARCHAR2(2 CHAR), 
	"DEST_PC" VARCHAR2(8 CHAR), 
	"SALESGROUP" VARCHAR2(8 CHAR), 
	"TRANSITTIME" NUMBER, 
	"COST_KM" NUMBER, 
	"COST_PALLET" NUMBER, 
	"DISTANCE" NUMBER(24,6), 
	"SOURCE_GEO" VARCHAR2(3 CHAR), 
	"DEST_GEO" VARCHAR2(3 CHAR), 
	"U_RATE_TYPE" VARCHAR2(1 CHAR), 
	"U_EQUIPMENT_TYPE" VARCHAR2(50), 
	"LANE_TYPE" VARCHAR2(50)
   )
