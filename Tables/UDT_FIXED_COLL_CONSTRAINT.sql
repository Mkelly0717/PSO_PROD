--------------------------------------------------------
--  Constraints for Table UDT_FIXED_COLL
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_FIXED_COLL" MODIFY ("PLANT" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_FIXED_COLL" MODIFY ("LOC" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_FIXED_COLL" ADD CONSTRAINT "UDT_FIXED_COLL_PK" PRIMARY KEY ("LOC", "PLANT")
  USING INDEX  ENABLE
