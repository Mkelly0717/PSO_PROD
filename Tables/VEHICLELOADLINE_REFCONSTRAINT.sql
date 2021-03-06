--------------------------------------------------------
--  Ref Constraints for Table VEHICLELOADLINE
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" ADD CONSTRAINT "VEHICLELOADLINE_ITEM_FK2" FOREIGN KEY ("PRIMARYITEM")
	  REFERENCES "SCPOMGR"."ITEM" ("ITEM") ON DELETE CASCADE ENABLE
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" ADD CONSTRAINT "VEHICLELOADLINE_SKU_FK1" FOREIGN KEY ("ITEM", "SOURCE")
	  REFERENCES "SCPOMGR"."SKU" ("ITEM", "LOC") ON DELETE CASCADE ENABLE
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" ADD CONSTRAINT "VEHICLELOADLINE_SKU_FK2" FOREIGN KEY ("ITEM", "DEST")
	  REFERENCES "SCPOMGR"."SKU" ("ITEM", "LOC") ON DELETE CASCADE ENABLE
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" ADD CONSTRAINT "VEHICLELOADLINE_VL_FK1" FOREIGN KEY ("LOADID")
	  REFERENCES "SCPOMGR"."VEHICLELOAD" ("LOADID") ON DELETE CASCADE ENABLE
