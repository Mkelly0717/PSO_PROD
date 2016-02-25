--------------------------------------------------------
--  Constraints for Table UDT_AREA
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_AREA" ADD PRIMARY KEY ("COMPANYID")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."UDT_AREA" MODIFY ("U_AREA" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_AREA" MODIFY ("COMPANYID" NOT NULL ENABLE)
