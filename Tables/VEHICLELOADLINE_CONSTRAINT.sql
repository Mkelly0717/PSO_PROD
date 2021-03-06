--------------------------------------------------------
--  Constraints for Table VEHICLELOADLINE
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" ADD CONSTRAINT "VEHICLELOADLINE_UC" UNIQUE ("SUPPLYID")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" ADD CONSTRAINT "MPACTIONS10" CHECK (Action IN (0, 1, 2, 3)) ENABLE
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" ADD CONSTRAINT "MUSTGOQTY" CHECK (MUSTGOQTY >= 0) ENABLE
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" ADD CONSTRAINT "LBSOURCE" CHECK (LBSOURCE >= 1 AND LBSOURCE <= 6) ENABLE
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" ADD CONSTRAINT "VEHICLELOADLINE_PK" PRIMARY KEY ("LOADID", "PRIMARYITEM", "EXPDATE", "ITEM", "DEST")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("PRIMARYITEMQTY" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("GROUPORDERID" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("DEST" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("SOURCE" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("REVISEDEXPDATE" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("SUPPORDERQTY" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("ORDERID" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("LBSOURCE" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("SCHEDARRIVDATE" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("SCHEDSHIPDATE" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("SEQNUM" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("MUSTGOQTY" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("SOURCING" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("ORDERNUM" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("ACTIONQTY" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("ACTIONDATE" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("ACTION" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("EXPDATE" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("DRAWQTY" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("PRIMARYITEM" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("ACTIONALLOWEDSW" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("REVISEDDATE" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("CANCELSW" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("LOADLINEID" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("SUPPLYMETHOD" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("QTY" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("ITEM" NOT NULL ENABLE)
  ALTER TABLE "SCPOMGR"."VEHICLELOADLINE" MODIFY ("LOADID" NOT NULL ENABLE)
