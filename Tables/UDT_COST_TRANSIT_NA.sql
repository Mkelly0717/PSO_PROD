--------------------------------------------------------
--  DDL for Table UDT_COST_TRANSIT_NA
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_COST_TRANSIT_NA" 
   (	"DIRECTION" VARCHAR2(2 CHAR) DEFAULT ' ', 
	"SOURCE_CO" VARCHAR2(2 CHAR) DEFAULT ' ', 
	"SOURCE_PC" VARCHAR2(8 CHAR) DEFAULT ' ', 
	"DEST_CO" VARCHAR2(2 CHAR) DEFAULT ' ', 
	"DEST_PC" VARCHAR2(8 CHAR) DEFAULT ' ', 
	"SALESGROUP" VARCHAR2(8 CHAR) DEFAULT ' ', 
	"TRANSITTIME" NUMBER DEFAULT 0, 
	"COST_KM" NUMBER DEFAULT 0, 
	"COST_PALLET" NUMBER DEFAULT 0, 
	"DISTANCE" NUMBER(24,6) DEFAULT 0, 
	"SOURCE_GEO" VARCHAR2(3 CHAR) DEFAULT ' ', 
	"DEST_GEO" VARCHAR2(3 CHAR) DEFAULT ' ', 
	"U_RATE_TYPE" VARCHAR2(1 CHAR) DEFAULT 'U', 
	"U_EQUIPMENT_TYPE" VARCHAR2(50) DEFAULT ' ', 
	"LANE_TYPE" VARCHAR2(50) DEFAULT ' '
   ) 

   COMMENT ON COLUMN "SCPOMGR"."UDT_COST_TRANSIT_NA"."DIRECTION" IS 'Transaction flow type (Issue vs Collection...)'
   COMMENT ON COLUMN "SCPOMGR"."UDT_COST_TRANSIT_NA"."SOURCE_CO" IS 'Country of the source location'
   COMMENT ON COLUMN "SCPOMGR"."UDT_COST_TRANSIT_NA"."SOURCE_PC" IS 'postal code of the source location'
   COMMENT ON COLUMN "SCPOMGR"."UDT_COST_TRANSIT_NA"."DEST_CO" IS 'Cuountry of the destinaitn location.'
   COMMENT ON COLUMN "SCPOMGR"."UDT_COST_TRANSIT_NA"."DEST_PC" IS 'Postal code of the destination locaiton.'
   COMMENT ON COLUMN "SCPOMGR"."UDT_COST_TRANSIT_NA"."COST_KM" IS 'Cost in miles for US and Km for EU'
   COMMENT ON COLUMN "SCPOMGR"."UDT_COST_TRANSIT_NA"."COST_PALLET" IS 'Cost per pallet in dollars'
   COMMENT ON COLUMN "SCPOMGR"."UDT_COST_TRANSIT_NA"."DISTANCE" IS 'distinace in miles or kilometers'
   COMMENT ON COLUMN "SCPOMGR"."UDT_COST_TRANSIT_NA"."SOURCE_GEO" IS 'Source GeoCode - First thres digits of the 5 digit postal code.'
   COMMENT ON COLUMN "SCPOMGR"."UDT_COST_TRANSIT_NA"."DEST_GEO" IS 'Destination GeoCode - First thres digits of the 5 digit postal code.'
   COMMENT ON COLUMN "SCPOMGR"."UDT_COST_TRANSIT_NA"."U_RATE_TYPE" IS 'Rate type: Spot or Other'
   COMMENT ON COLUMN "SCPOMGR"."UDT_COST_TRANSIT_NA"."U_EQUIPMENT_TYPE" IS 'Used to hold the equipment type of Flatbed or Tailer.'
