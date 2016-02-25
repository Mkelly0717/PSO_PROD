--------------------------------------------------------
--  Ref Constraints for Table UDT_FIXED_COLL
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_FIXED_COLL" ADD CONSTRAINT "UDT_FIXED_COLL_LOC_FK1" FOREIGN KEY ("LOC")
	  REFERENCES "SCPOMGR"."LOC" ("LOC") ENABLE
