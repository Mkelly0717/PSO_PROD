--------------------------------------------------------
--  Constraints for Table UDT_EQUIPMENT_TYPE
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_EQUIPMENT_TYPE" ADD CONSTRAINT "UDT_EQUIPMENT_TYPE_PK" PRIMARY KEY ("U_EQUIPMENT_TYPE")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."UDT_EQUIPMENT_TYPE" MODIFY ("U_EQUIPMENT_TYPE" NOT NULL ENABLE)
