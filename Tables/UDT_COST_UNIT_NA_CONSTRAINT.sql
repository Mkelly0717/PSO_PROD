--------------------------------------------------------
--  Constraints for Table UDT_COST_UNIT_NA
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_COST_UNIT_NA" MODIFY ("UNIT_COST" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_COST_UNIT_NA" MODIFY ("PROCESS" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_COST_UNIT_NA" MODIFY ("MATCODE" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_COST_UNIT_NA" MODIFY ("COMPANY" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_COST_UNIT_NA" MODIFY ("LOC" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_COST_UNIT_NA" ADD CONSTRAINT "UDT_COST_UNIT_NA_CHK1" CHECK (UNIT_COST >= 0) ENABLE
  ALTER TABLE "SCPOMGR"."UDT_COST_UNIT_NA" ADD CONSTRAINT "UDT_COST_UNIT_NA_PK" PRIMARY KEY ("LOC", "MATCODE", "PROCESS")
  USING INDEX  ENABLE