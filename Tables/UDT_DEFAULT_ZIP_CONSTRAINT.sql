--------------------------------------------------------
--  Constraints for Table UDT_DEFAULT_ZIP
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_DEFAULT_ZIP" MODIFY ("POSTALCODE" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_DEFAULT_ZIP" MODIFY ("LOC" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_DEFAULT_ZIP" ADD CONSTRAINT "UDT_DEFAULT_ZIP_PK" PRIMARY KEY ("POSTALCODE", "LOC")
  USING INDEX  ENABLE
