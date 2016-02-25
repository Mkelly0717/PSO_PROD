--------------------------------------------------------
--  Constraints for Table UDT_GIDLIMITS
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_GIDLIMITS" ADD CONSTRAINT "PK_UDT_GIDLIMITS" PRIMARY KEY ("PRIMARY_KEY_COL")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."UDT_GIDLIMITS" ADD CONSTRAINT "UDT_GIDLIMITS_C03" CHECK (MATCODE IS NOT NULL) ENABLE
  ALTER TABLE "SCPOMGR"."UDT_GIDLIMITS" ADD CONSTRAINT "UDT_GIDLIMITS_C02" CHECK (COUNTRY IS NOT NULL) ENABLE
  ALTER TABLE "SCPOMGR"."UDT_GIDLIMITS" MODIFY ("LOC" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_GIDLIMITS" MODIFY ("U_LOC_TYPE" NOT NULL ENABLE)
