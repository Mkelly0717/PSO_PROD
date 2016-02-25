--------------------------------------------------------
--  Ref Constraints for Table PLANARRIV
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."PLANARRIV" ADD CONSTRAINT "PLANARRIV_SKU_FK2" FOREIGN KEY ("ITEM", "DEST")
	  REFERENCES "SCPOMGR"."SKU" ("ITEM", "LOC") ON DELETE CASCADE ENABLE
  ALTER TABLE "SCPOMGR"."PLANARRIV" ADD CONSTRAINT "PLANARRIV_SKU_FK3" FOREIGN KEY ("ITEM", "SOURCE")
	  REFERENCES "SCPOMGR"."SKU" ("ITEM", "LOC") ON DELETE CASCADE ENABLE
  ALTER TABLE "SCPOMGR"."PLANARRIV" ADD CONSTRAINT "PLANARRIV_TRANSMODE_FK1" FOREIGN KEY ("TRANSMODE")
	  REFERENCES "SCPOMGR"."TRANSMODE" ("TRANSMODE") ENABLE
