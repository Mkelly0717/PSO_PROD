--------------------------------------------------------
--  Constraints for Table UDT_LANE_TYPE
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_LANE_TYPE" ADD CONSTRAINT "UDT_LANE_TYPE_PK" PRIMARY KEY ("LANE_TYPE")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."UDT_LANE_TYPE" MODIFY ("LANE_TYPE" NOT NULL ENABLE)
