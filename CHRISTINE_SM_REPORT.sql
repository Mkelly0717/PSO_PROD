--------------------------------------------------------
--  DDL for View CHRISTINE_SM_REPORT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."CHRISTINE_SM_REPORT" ("SOURCING", "SOURCE", "DEST", "EFF", "ITEM", "VALUE", "SOURCE_PC", "DEST_PC", "SOURCE_GEO", "DEST_GEO", "TRANSITTIME", "DISTANCE", "U_RATE_TYPE", "COST_PALLET", "CT_ET", "LS_ET", "LD_ET", "RUNEW_ALLOWED", "DEST_MAX_SRC", "DEST_MAX_DIST", "MANDLOC", "MANDLOC_2", "MANDLOC_3", "MANDLOC_4", "FORBLOC", "FORBLOC_2", "FORBLOC_3", "EXCLLOC", "EXCLLOC_2", "EXCLLOC_3") AS 
  select sm.sourcing
      , sm.source
      , sm.dest
      , sm.eff
      , sm.item
      , round(sm.value,2) value
      , ct.source_pc
      , dest_pc
      , source_geo
      , dest_geo
      , ct.transittime
      , ct.distance
      , ct.u_rate_type
      , ct.cost_pallet
      , ct.u_equipment_type ct_et
      , case
            when ls.loc_type = 3
            then nvl(trim(ls.u_equipment_type),'VN')
            else null
        end ls_et
      , case
            when ld.loc_type = 3
            then nvl(trim(ld.u_equipment_type),'VN')
            else null
        end ld_et
      , decode(ld.u_runew_cust,0,'N',1,'Y',ld.u_runew_cust) runew_allowed
      , ld.u_max_src dest_max_src
      , ld.u_max_dist dest_max_dist
      , gidw.mandloc
      , gidw.mandloc_2
      , gidw.mandloc_3
      , gidw.mandloc_4
      , gidw.forbloc
      , gidw.forbloc_2
      , gidw.forbloc_3
      , gidw.exclloc
      , gidw.exclloc_2
      , gidw.exclloc_3
    from sim_sourcingmetric sm
      , udt_sourcing_definitions sd
      , loc ls
      , loc ld
      , udt_cost_transit_na ct
      , udv_gidlimits_wide gidw
    where sm.category =417
        and sm.sourcing =sd.sourcing
        and sd.zip_type is not null
        and ls.loc =sm.source
        and ld.loc =sm.dest
        and ( ( ld.loc_type = 3
        and ct.u_equipment_type = nvl(trim(ld.u_equipment_type),'VN') )
        or ( ls.loc_type = 3
        and ct.u_equipment_type = nvl(trim(ls.u_equipment_type),'VN') ) )
    and (    ( sd.zip_type = '3' and ls.u_3digitzip =ct.source_geo
                                 and ld.u_3digitzip = ct.dest_geo)
          or ( sd.zip_type = '5' and ls.postalcode =ct.source_pc
                                 and ld.postalcode = ct.dest_pc) 
          or ( sd.zip_type = 'NA' and ls.postalcode =ct.source_pc
                                  and ld.postalcode = ct.dest_pc) 
          or ( sd.zip_type = 'NA' and ls.u_3digitzip =ct.source_geo
                                  and ld.u_3digitzip = ct.dest_geo) 

        )
        and gidw.loc(+) =sm.dest
        and gidw.item(+) =sm.item
		and sm.simulation_name='AD'
