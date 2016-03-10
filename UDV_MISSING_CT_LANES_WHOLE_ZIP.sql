
  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_MISSING_CT_LANES_WHOLE_ZIP" ("PC_SOURCE", "PC_DEST") AS 
  select distinct l.postalcode as pc_source
      , l2.postalcode            as pc_dest
    from scpomgr.loc l
      , sourcing s
      , loc l2
    where s.source=l.loc
        and s.dest =l2.loc
        and not exists
        (select '1'
        from udt_cost_transit_na ct
        where ct.source_pc=l.postalcode
            and ct.dest_pc=l2.postalcode
        )
