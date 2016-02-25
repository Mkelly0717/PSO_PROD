--------------------------------------------------------
--  Constraints for Table UDT_AREA_TYPE
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_AREA_TYPE" ADD CONSTRAINT "UDT_AREA_TYPE_PK" PRIMARY KEY ("U_AREA")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."UDT_AREA_TYPE" MODIFY ("U_AREA" NOT NULL ENABLE)
