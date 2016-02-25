--------------------------------------------------------
--  DDL for Trigger TIU_PLANNETCHG_PLANARRIV
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SCPOMGR"."TIU_PLANNETCHG_PLANARRIV" 
BEFORE INSERT OR UPDATE ON PLANARRIV
for each row
    WHEN (NEW.FF_TRIGGER_CONTROL IS NOT NULL) BEGIN

   if INSERTING THEN
      -- set netchangesw if not already set
      UPDATE sku SET netchgsw = 1
         WHERE  netchgsw = 0
        AND   sku.item = :new.item
        AND   sku.loc = :new.source;

    elsif UPDATING then
        if :NEW.FF_TRIGGER_CONTROL=-1 then
          UPDATE sku SET netchgsw = 1
            WHERE  netchgsw = 0
            AND   sku.item = :new.item
            AND   sku.loc = :new.source;
      elsif
        -- set netchangesw if source, schedshipdate, item, firmplansw ,schedarrivdate,expdate,qty,transmode   columns have changed
        :new.source <> :old.source or
        :new.schedshipdate <> :old.schedshipdate or
        :new.item <> :old.item or
        :new.dest <> :old.dest or
        :new.firmplansw <> :old.firmplansw or
        :new.schedarrivdate <> :old.schedarrivdate or
        :new.expdate <> :old.expdate or
        :new.qty <> :old.qty or
        :new.transmode <> :old.transmode

      then
        -- set netchangesw if not already set
        UPDATE sku SET netchgsw = 1
            WHERE netchgsw = 0
            AND   sku.item = :new.item
            AND   sku.loc = :new.source;
      end if;
   end if;
   -- reset trigger_control to NULL
   :new.FF_TRIGGER_CONTROL := NULL;

END;

ALTER TRIGGER "SCPOMGR"."TIU_PLANNETCHG_PLANARRIV" ENABLE
