--------------------------------------------------------
--  Constraints for Table UDT_SUBSTITUTE
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_SUBSTITUTE" ADD CONSTRAINT "UDT_SUBSTITUTE_PK" PRIMARY KEY ("BOMNUM", "SUBORD", "PARENT", "COUNTRY")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."UDT_SUBSTITUTE" MODIFY ("UNIT_COST" NOT NULL ENABLE)
