--------------------------------------------------------
--  Constraints for Table UDT_TERRITORY
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."UDT_TERRITORY" ADD PRIMARY KEY ("POSTALCODE")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."UDT_TERRITORY" MODIFY ("COMPANYID" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_TERRITORY" MODIFY ("CLUSTERCODE" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_TERRITORY" MODIFY ("TERRITORY" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_TERRITORY" MODIFY ("COUNTRY" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."UDT_TERRITORY" MODIFY ("POSTALCODE" NOT NULL ENABLE)