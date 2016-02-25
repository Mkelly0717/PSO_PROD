--------------------------------------------------------
--  Ref Constraints for Table VEHICLELOAD
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."VEHICLELOAD" ADD CONSTRAINT "VEHICLELOAD_TRANSMODE_FK1" FOREIGN KEY ("TRANSMODE")
	  REFERENCES "SCPOMGR"."TRANSMODE" ("TRANSMODE") ENABLE
