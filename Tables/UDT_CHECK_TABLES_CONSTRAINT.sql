--------------------------------------------------------
--  Constraints for Table UDT_CHECK_TABLES
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_CHECK_TABLES" ADD CONSTRAINT "UDT_CHECK_TABLES_PK" PRIMARY KEY ("RUN_DATE")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."UDT_CHECK_TABLES" MODIFY ("RUN_DATE" NOT NULL ENABLE)
