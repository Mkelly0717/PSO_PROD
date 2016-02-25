--------------------------------------------------------
--  Ref Constraints for Table VEHICLELOADTOTAL
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."VEHICLELOADTOTAL" ADD CONSTRAINT "VEHICLELOADTOTAL_VLOAD_FK1" FOREIGN KEY ("LOADID")
	  REFERENCES "SCPOMGR"."VEHICLELOAD" ("LOADID") ON DELETE CASCADE ENABLE
