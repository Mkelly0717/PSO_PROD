--------------------------------------------------------
--  Constraints for Table UDT_COUNTRY_GLID_MAT_QTY
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_COUNTRY_GLID_MAT_QTY" ADD CONSTRAINT "PK_UDT_CTRY_GLID_MAT_QTY" PRIMARY KEY ("COUNTRY", "GLID", "MATERIAL_CODE", "DMDGROUP")
  USING INDEX  ENABLE
