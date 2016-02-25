--------------------------------------------------------
--  Constraints for Table UDT_IGPERROR_HIST
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_IGPERROR_HIST" ADD CONSTRAINT "UDT_IGPERROR_STATS_PK" PRIMARY KEY ("RUN_DATE")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."UDT_IGPERROR_HIST" MODIFY ("RUN_DATE" NOT NULL ENABLE)
