--------------------------------------------------------
--  Constraints for Table UDT_RATE_TYPE
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_RATE_TYPE" ADD CONSTRAINT "UDT_RATE_TYPE_PK" PRIMARY KEY ("U_RATE_TYPE")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."UDT_RATE_TYPE" MODIFY ("DESCRIPTION" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_RATE_TYPE" MODIFY ("U_RATE_TYPE" NOT NULL ENABLE)
