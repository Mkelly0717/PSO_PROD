--------------------------------------------------------
--  DDL for Trigger TIU_PLANNETCHG_VEHICLELOADLINE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SCPOMGR"."TIU_PLANNETCHG_VEHICLELOADLINE" 
BEFORE INSERT OR UPDATE ON VEHICLELOADLINE
for each row
  WHEN (
NEW.FF_TRIGGER_CONTROL IS NOT NULL
      ) BEGIN

   if INSERTING THEN
      -- set netchangesw if not already set
      UPDATE sku SET netchgsw = 1
         WHERE  netchgsw = 0
            AND   sku.item = :new.item or sku.loc = :new.source;

elsif UPDATING then
if :NEW.FF_TRIGGER_CONTROL=-1 then
      UPDATE sku SET netchgsw = 1
      WHERE  netchgsw = 0
            AND   sku.item = :new.item or sku.loc = :new.source;

elsif
      -- set netchangesw if expdate, item, qty columns have changed
      :new.expdate <> :old.expdate or
      :new.item <> :old.item or
        :new.qty <> :old.qty or
:new.source <> :old.source or
:new.dest <> :old.dest

      then
         -- set netchangesw if not already set
         UPDATE sku SET netchgsw = 1
            WHERE netchgsw = 0
            AND   sku.item = :new.item or sku.loc = :new.source;
      end if;
  end if;
     -- reset trigger_control to NULL
   :new.FF_TRIGGER_CONTROL := NULL;

END;

ALTER TRIGGER "SCPOMGR"."TIU_PLANNETCHG_VEHICLELOADLINE" ENABLE
