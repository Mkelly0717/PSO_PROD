--------------------------------------------------------
--  Constraints for Table UDT_PLANT_STATUS
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_PLANT_STATUS" ADD CONSTRAINT "UDT_PLANT_STATUS_CHK1" CHECK (STATUS IN ('0', '1')) ENABLE
  ALTER TABLE "SCPOMGR"."UDT_PLANT_STATUS" ADD CONSTRAINT "UDT_PLANT_STATUS_PK" PRIMARY KEY ("LOC", "U_MATERIALCODE", "U_STOCK", "RES")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."UDT_PLANT_STATUS" MODIFY ("LOC" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_PLANT_STATUS" MODIFY ("U_MATERIALCODE" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_PLANT_STATUS" MODIFY ("U_STOCK" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_PLANT_STATUS" MODIFY ("RES" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_PLANT_STATUS" MODIFY ("STATUS" NOT NULL ENABLE)
