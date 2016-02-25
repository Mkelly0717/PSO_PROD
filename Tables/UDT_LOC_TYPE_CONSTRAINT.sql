--------------------------------------------------------
--  Constraints for Table UDT_LOC_TYPE
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_LOC_TYPE" ADD CONSTRAINT "UDT_LOC_TYPE_PK" PRIMARY KEY ("LOC_TYPE")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."UDT_LOC_TYPE" MODIFY ("LOC_TYPE" NOT NULL ENABLE)
