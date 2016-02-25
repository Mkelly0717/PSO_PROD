--------------------------------------------------------
--  Constraints for Table MAK_TPM_PLANTS_WITH_0_QTY
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."MAK_TPM_PLANTS_WITH_0_QTY" ADD CONSTRAINT "MAK_TPM_PLANTS_WITH_0_QTY_PK" PRIMARY KEY ("LOC")
  USING INDEX  ENABLE
  ALTER TABLE "SCPOMGR"."MAK_TPM_PLANTS_WITH_0_QTY" MODIFY ("LOC" NOT NULL ENABLE)
