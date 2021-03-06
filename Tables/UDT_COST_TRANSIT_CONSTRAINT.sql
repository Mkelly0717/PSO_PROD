--------------------------------------------------------
--  Constraints for Table UDT_COST_TRANSIT
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_COST_TRANSIT" ADD CONSTRAINT "PK_UDT_COST_TRANSIT" PRIMARY KEY ("PRIMARY_KEY_COL")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."UDT_COST_TRANSIT" ADD CHECK (COST_PALLET >= 0) ENABLE
  ALTER TABLE "SCPOMGR"."UDT_COST_TRANSIT" ADD CHECK (COST_KM >= 0) ENABLE
  ALTER TABLE "SCPOMGR"."UDT_COST_TRANSIT" ADD CHECK (TRANSITTIME >= 0) ENABLE
  ALTER TABLE "SCPOMGR"."UDT_COST_TRANSIT" MODIFY ("COST_PALLET" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_COST_TRANSIT" MODIFY ("COST_KM" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_COST_TRANSIT" MODIFY ("TRANSITTIME" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_COST_TRANSIT" MODIFY ("SALESGROUP" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_COST_TRANSIT" MODIFY ("DEST_PC" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_COST_TRANSIT" MODIFY ("DEST_CO" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_COST_TRANSIT" MODIFY ("SOURCE_PC" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_COST_TRANSIT" MODIFY ("SOURCE_CO" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_COST_TRANSIT" MODIFY ("DIRECTION" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_COST_TRANSIT" ADD CONSTRAINT "CHK_U_RATE_TYPE" CHECK (U_RATE_TYPE IN ('U','S','T')) ENABLE
