--------------------------------------------------------
--  DDL for View UDV_NOLANE_FIXED_COLL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_NOLANE_FIXED_COLL" ("LOC", "PLANT") AS 
  select distinct fcoll.loc
      , fcoll.plant
    from scpomgr.udt_fixed_coll fcoll
      , scpomgr.loc l1
      , scpomgr.loc l2
    where fcoll.loc=l1.loc
        and fcoll.plant=l2.loc
        and exists
        (select '1'
        from udt_cost_transit_na ct
        where ct.source_pc=l1.postalcode
            and ct.dest_pc=l2.postalcode
        )
