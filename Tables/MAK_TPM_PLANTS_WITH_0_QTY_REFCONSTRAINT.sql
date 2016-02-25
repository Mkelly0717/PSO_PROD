--------------------------------------------------------
--  Ref Constraints for Table MAK_TPM_PLANTS_WITH_0_QTY
--------------------------------------------------------

  ALTER TABLE "SCPOMGR"."MAK_TPM_PLANTS_WITH_0_QTY" ADD CONSTRAINT "MAK_TPM_PLANTS_WITH_0_QTY_FK1" FOREIGN KEY ("LOC")
	  REFERENCES "SCPOMGR"."LOC" ("LOC") ENABLE
