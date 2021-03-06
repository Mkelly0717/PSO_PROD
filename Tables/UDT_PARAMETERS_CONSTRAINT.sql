--------------------------------------------------------
--  Constraints for Table UDT_PARAMETERS
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_PARAMETERS" ADD CONSTRAINT "UDT_PARAMETERS_PK" PRIMARY KEY ("PARAM_ID", "REGION_PRODUCT")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."UDT_PARAMETERS" MODIFY ("REGION_PRODUCT" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_PARAMETERS" MODIFY ("PARAM_ID" NOT NULL ENABLE)
