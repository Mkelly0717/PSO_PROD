--------------------------------------------------------
--  Ref Constraints for Table UDT_YIELD_NA
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_YIELD_NA" ADD CONSTRAINT "UDT_YIELD_LOC_FK1" FOREIGN KEY ("LOC")
	  REFERENCES "SCPOMGR"."LOC" ("LOC") ENABLE
