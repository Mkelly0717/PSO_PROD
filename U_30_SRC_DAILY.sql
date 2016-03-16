--------------------------------------------------------
--  DDL for Procedure U_30_SRC_DAILY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_30_SRC_DAILY" as

/* U_30_SRC_DAILY_PART1:  TPM(4) to SC(2), ST(5) 
   U_30_SRC_DAILY_PART2:  TPM(4),SC(2),or ST(5) to GLID (3) ==> 5 digit lanes
   U_30_SRC_DAILY_PART2b: TPM(4),SC(2),or ST(5) to GLID (3) ==> 3 digit lanes
   U_30_SRC_DAILY_PART3:  COMMENTED OUT NOW!! Find Closest 5zip Lane over max Dist  
   U_30_SRC_DAILY_PART3B: Find Closest 3zip Lane over max Dist
   U_30_SRC_DAILY_PART4:  Create RU SKU'S at the MFG Locaitons
   U_30_SRC_DAILY_PART5:  Allow sourcing from MFG if substitution is allowed.
   U_30_SRC_DAILY_PART6:  Collections based on UDT_FIXED_COLL.
   U_30_SRC_DAILY_PART7:  Collections based UDT_DEFAULT_ZIP.
   U_30_SRC_DAILY_PART8:  TPM relocations.
   U_30_SRC_DAILY_PART9:  Update Sourcing Min LeadTime.
   U_30_SRC_DAILY_PART10: Add Sourcing Draw records.
   U_30_SRC_DAILY_PART11: Add SourcingYield records.
   U_30_SRC_DAILY_PART12: Add Res records.
   U_30_SRC_DAILY_PART13: Add SourcingRequirement Records.
   U_30_SRC_DAILY_PART14: Add Cost Records.
   U_30_SRC_DAILY_PART15: Now insert costtier records for 5 digit lanes.
   U_30_SRC_DAILY_PART16: Now insert costtier records for 3 digit lanes
   U_30_SRC_DAILY_PART17: Now Populate teh ResCost table.
*/


v_begin_date date;
v_end_date date;
v_initial_date date;

begin

--sourcing for issues

-- scpomgr.u_8d_sourcing;
scpomgr.z_8d_sourcing('NA');

select u_14d_begin_skuconstraint into v_begin_date from dual;
select u_14d_end_skuconstraint into v_end_date from dual;
select v_init_eff_date into v_initial_date from dual;

/******************************************************************
** Part 1: create one sourcing record for each exclusive TPM SKU  * 
*******************************************************************/
insert into intups_sourcing ( integration_jobid
                      ,item, dest, source, transmode, eff, factor, arrivcal
                      ,majorshipqty, minorshipqty, enabledyndepsw
                      ,shrinkagefactor, maxshipqty, abbr, sourcing, disc
                      ,maxleadtime, minleadtime, priority, enablesw, yieldfactor
                      ,supplyleadtime, costpercentage, supplytransfercost
                      ,nonewsupplydate, shipcal, ff_trigger_control
                      ,pullforwarddur, splitqty, loaddur, unloaddur, reviewcal
                      ,uselookaheadsw, convenientshipqty, convenientadjuppct
                      ,convenientoverridethreshold, roundingfactor, ordergroup
                      ,ordergroupmember, lotsizesenabledsw
                      ,convenientadjdownpct
                      )
select distinct 'U_30_SRC_DAILY_PART1', u.item, u.dest, u.source
      , 'TRUCK' transmode, v_initial_date eff
      ,1 factor, ' ' arrivcal, 0 majorshipqty, 0 minorshipqty, 1 enabledyndepsw
      ,0 shrinkagefactor, 0 maxshipqty, ' ' abbr, 'ISS1EXCL' sourcing
      ,v_initial_date disc, 1440 * 365 * 100 maxleadtime, 0 minleadtime
      ,1 priority, 1 enablesw, 100 yieldfactor, 0 supplyleadtime
      ,100 costpercentage, 0 supplytransfercost, v_initial_date nonewsupplydate
      ,' ' shipcal, ''  ff_trigger_control, 0 pullforwarddur, 0 splitqty
      ,0 loaddur, 0 unloaddur, ' ' reviewcal, 1 uselookaheadsw
      ,0 convenientshipqty, 0 convenientadjuppct, 0 convenientoverridethreshold
      ,0 roundingfactor, ' ' ordergroup, ' ' ordergroupmember
      ,0 lotsizesenabledsw, 0 convenientadjdownpct
from sourcing c, sku ss, sku sd, 

            (select distinct g.item, g.loc dest, g.exclusive_loc source
            from udt_gidlimits_na g, loc l
            where g.exclusive_loc = l.loc
            and l.loc_type in (1,2,4)
            and g.exclusive_loc is not null
            and g.de = 'E'
            
            union
            
            select distinct g.item, g.loc, g.mandatory_loc 
            from udt_gidlimits_na g, loc l
            where g.mandatory_loc = l.loc
            and l.loc_type in (1,2,4)
            and g.mandatory_loc is not null
            ) u
    
where u.item = ss.item
and u.source = ss.loc
and u.item = sd.item
and u.dest = sd.loc
and u.item = c.item(+)
and u.dest = c.dest(+)
and c.item is null;

commit;

/*******************************************************************************
** Part 2: Find all possible sources within loc.u_max_dist nullu_max_srcs 
**         where udt_cost_transit_na matches source_pc and dest_pc
**     ==> This should Exclude exclusive TPM SKU's which where handled in Part 1.
**         Make sure that: Get all possible matches of Source Plants to each GLID
**           1) where it is not an exclusive or forbidded lanes
**           2) udt_cost_transist.distance <- loc.u_max_dist 
**           3) Number of sources ranked by cost < loc.u_max_src
*******************************************************************************/
--  First do the 5digit zip to 5 digit zip. because union takes too long
insert into igpmgr.intins_sourcing 
                    ( integration_jobid
                      ,item, dest, source, transmode, eff,     factor, arrivcal
                      ,majorshipqty, minorshipqty, enabledyndepsw,shrinkagefactor
                      ,maxshipqty, abbr, sourcing, disc, maxleadtime, minleadtime
                      ,priority, enablesw, yieldfactor, supplyleadtime
                      ,costpercentage, supplytransfercost, nonewsupplydate
                      ,shipcal, ff_trigger_control, pullforwarddur, splitqty
                      ,loaddur, unloaddur, reviewcal, uselookaheadsw
                      ,convenientshipqty, convenientadjuppct
                      ,convenientoverridethreshold, roundingfactor, ordergroup
                      ,ordergroupmember, lotsizesenabledsw, convenientadjdownpct
                     )

select distinct 'U_30_SRC_DAILY_PART2'
      ,ranked_lanes.item, ranked_lanes.dest,ranked_lanes.source
      ,'TRUCK' transmode, v_initial_date eff, 1 factor, ' ' arrivcal
      ,0 majorshipqty, 0 minorshipqty, 1 enabledyndepsw, 0 shrinkagefactor
      ,0 maxshipqty, ' ' abbr, 'ISS2MAXDISTSRC-5ZIP' sourcing, v_initial_date disc
      , 1440 * 365 * 100 maxleadtime, 0 minleadtime, 1 priority, 1 enablesw
      ,100 yieldfactor, 0 supplyleadtime, 100 costpercentage
      ,0 supplytransfercost, v_initial_date nonewsupplydate, ' ' shipcal
      , ''  ff_trigger_control, 0 pullforwarddur, 0 splitqty, 0 loaddur
      ,0 unloaddur, ' ' reviewcal, 1 uselookaheadsw, 0 convenientshipqty
      ,0 convenientadjuppct, 0 convenientoverridethreshold, 0 roundingfactor
      ,' ' ordergroup, ' ' ordergroupmember, 0 lotsizesenabledsw
      ,0 convenientadjdownpct
from sourcing src, 
     /******************************************************************** 
     ** Ranked Lanes Piece: Source Item, dest, dest_pc, source, source_pc
     ** ,max_dist, max_src, distance, rownum 
     *********************************************************************/
    (select all_lanes.item, all_lanes.dest, all_lanes.dest_pc, all_lanes.source
           ,ALL_LANES.SOURCE_PC, ALL_LANES.U_MAX_DIST, ALL_LANES.U_MAX_SRC
           ,all_lanes.distance, dense_rank()
           OVER ( PARTITION BY ALL_LANES.ITEM, ALL_LANES.DEST 
                  order by cost_pallet asc
                 ) as rank
    from  
    /*********************************************************************
    ** Getting All Lanes: item, dest, dest_pc, source, source_pc max_dist
    ** ,max_src, dist and  cost(999 if null) 
    **********************************************************************/
    (select /*+ use_hash(lane_cost, lanes) parallel (lane_cost,4) parallel (lanes,4) */
            lanes.item, lanes.dest, lanes.dest_pc, lanes.source, lanes.source_pc
            ,lanes.u_max_dist, lanes.u_max_src, lane_cost.distance
            ,nvl(lane_cost.cost_pallet, 999) cost_pallet, lane_cost.direction
            ,lane_cost.u_equipment_type
        from
            /* Cost for the lanes from UDT_COST_TRANSIT_NA */ 
            (select direction
                   ,u_equipment_type u_equipment_type
                   ,substr(source_pc, 1, 5)        source_pc
                   ,source_geo       source_geo
                   ,substr(dest_pc, 1, 5)          dest_pc
                   ,dest_geo         dest_geo
                   ,source_co
                   ,distance         distance
                   ,cost_pallet      cost_pallet 
             from udt_cost_transit_na
             order by direction, u_equipment_type, source_pc, dest_pc, source_geo, dest_geo
            )  lane_cost, 
             /***************************************************************
             ** Lanes based on matching the source for producitonyield and 
             ** dest for sku constraint. dest sku, max_dist, max_src, dest_pc
             ** ,source, source_pc 
             *****************************************************************/            
            (select /*+ use_hash(dest, source_sku, demand_group) parallel (dest,4)parallel (sku_source,4 ) */
                    ' ' direction
                   ,dest.item
                   ,dest.loc dest
                   ,dest.u_max_dist
                   ,dest.u_max_src
                   ,dest.dest_pc
                   ,dest.dest_geo
                   ,source_sku.loc source
                   ,source_sku.source_pc
                   ,source_sku.source_geo
                   ,case when dest.u_equipment_type='FB' then 'FB' 
                         else 'VN' 
                    end u_equipment_type
            
            from
                    /**********************************************************
                    ** Allowed Destinations (GLID) Based on SKUCONSTRAINT 
                    ** ( OR ACTUAL DEMAND) Sku, max _dist, max _src, Postal Code
                    ***********************************************************/
                    (select distinct sku.item
                                    ,i.u_materialcode matcode
                                    ,sku.loc
                                    ,l.u_max_dist
                                    ,l.u_max_src
                                    ,substr(l.postalcode, 1, 5) dest_pc
                                    ,l.u_equipment_type u_equipment_type
                                    ,l.u_3digitzip dest_geo
                    from skuconstraint sku
                        ,loc l
                        ,item i
                    where sku.category in (1,6)
                      and sku.loc = l.loc
                      and l.loc_type = 3
                      and l.U_AREA='NA'
                      and sku.item = i.item
                      and i.u_stock = 'C'
                      and sku.qty > 0
                      -- commented out, causing a performance issue calling the function over and over, 
                      -- moved it outside the select statement
                      
                      -- and sku.eff between u_14d_begin_skuconstraint
                      --                and u_14d_end_skuconstraint
                      and sku.eff between v_begin_date
                      and v_end_date
                      and trim(l.postalcode ) is not null
                      and trim(l.u_3digitzip ) is not null
                    /* added by MAK */
                    and not exists ( select '1' from udt_gidlimits_na gl 
                                      where gl.loc  = sku.loc 
                                        and gl.item = sku.item 
                                        and gl.mandatory_loc is not null )  
                    ) dest,
                    /* Allowed Sources based on PRODUCITONYIELD (PLant).
                       sku, postalcode 
                       for the SOURCE SKU
                    */
                    (select distinct i.item
                          ,l.loc
                          ,substr(l.postalcode, 1, 5) source_pc
                          ,l.u_3digitzip source_geo
                          ,ps.status flatbed_status                        
                    from item i
                        ,loc l
                        ,sku sku
                        ,udt_plant_status ps                              
                    where l.loc=sku.loc
                    and l.loc_type in (2,4,5)
                    and l.U_AREA='NA'
                    and l.postalcode  is not null
                    and l.u_3digitzip is not null
                    and is_5digit(l.postalcode) = 1
                    and is_3digit(l.u_3digitzip) = 1
                    and l.enablesw=1
                    and i.item=sku.item
                    and i.u_stock = 'C'
                    and i.enablesw=1
                    and ps.loc=sku.loc
                    and ps.res= 'SOURCEFLATBED'
                    and not exists
                         (select '1'
                            from udt_gidlimits_na gl
                           where   gl.exclusive_loc = sku.loc
                             and gl.item = sku.item
                         )
                    union 
                    select sku.item
                          ,sku.loc
                          ,substr(l1.postalcode, 1, 5) source_pc
                          ,l1.u_3digitzip source_geo
                          ,ps.status flatbed_status
                    from sku sku
                        ,loc l1
                        ,item i1
                        ,udt_plant_status ps       
                    where l1.loc_type in (2,4,5)
                      and i1.u_stock='C'
                      and sku.item=i1.item
                      and sku.oh > 0
                      and sku.loc=l1.loc
                      and trim(l1.postalcode )  is not null
                      and trim(l1.u_3digitzip ) is not null
                      and l1.U_AREA='NA'                       
                      and l1.loc=ps.loc
                      and ps.res= 'SOURCEFLATBED' 
                      and not exists
                         (select '1'
                            from udt_gidlimits_na gl
                           where   gl.exclusive_loc = sku.loc
                             and gl.item = sku.item
                         )
                  ) source_sku
            where dest.loc <> source_sku.loc
              and dest.item = source_sku.item
              and ( ( u_equipment_type='FB'and source_sku.flatbed_status=1) 
                   or 
                    (u_equipment_type <> 'FB')
                  )
         ) lanes
        
      where lanes.u_equipment_type = lane_cost.u_equipment_type
        and lane_cost.direction    = ' '
        and lanes.dest_pc          = lane_cost.dest_pc
        and lanes.source_pc        = lane_cost.source_pc
        and lanes.u_max_dist      >= lane_cost.distance
        ) all_lanes
    ) ranked_lanes
/*******************************************************************************
**                      End of In Line Views
*******************************************************************************/
where ranked_lanes.rank <= ranked_lanes.u_max_src
and   ranked_lanes.item = src.item(+)
and   ranked_lanes.dest = src.dest(+)
and   ranked_lanes.source = src.source(+)
and not exists ( select '1' 
                   from udt_gidlimits_na gl1 
                  where gl1.loc  = src.dest
                    and gl1.item = src.item 
                    and gl1.forbidden_loc = src.source )
and src.item is null;

commit;
-- Next do the 3 digit zip to 3 digit zip
insert into igpmgr.intins_sourcing 
                     ( integration_jobid
                      ,item, dest, source, transmode, eff, factor, arrivcal
                      ,majorshipqty, minorshipqty, enabledyndepsw
                      ,shrinkagefactor, maxshipqty, abbr, sourcing, disc
                      ,maxleadtime, minleadtime, priority, enablesw
                      ,yieldfactor, supplyleadtime, costpercentage
                      ,supplytransfercost, nonewsupplydate, shipcal
                      ,ff_trigger_control, pullforwarddur, splitqty, loaddur
                      ,unloaddur, reviewcal, uselookaheadsw, convenientshipqty
                      ,convenientadjuppct, convenientoverridethreshold
                      ,roundingfactor, ordergroup, ordergroupmember
                      ,lotsizesenabledsw, convenientadjdownpct
                     )

select distinct 'U_30_SRC_DAILY_PART2B'
      ,ranked_lanes.item, ranked_lanes.dest, ranked_lanes.source
      ,'TRUCK' transmode, v_initial_date eff, 1 factor, ' ' arrivcal
      ,0 majorshipqty, 0 minorshipqty, 1 enabledyndepsw, 0 shrinkagefactor
      ,0 maxshipqty, ' ' abbr, 'ISS2MAXDISTSRC-3ZIP' sourcing, v_initial_date disc
      ,1440 * 365 * 100 maxleadtime, 0 minleadtime, 1 priority, 1 enablesw
      ,100 yieldfactor, 0 supplyleadtime, 100 costpercentage
      ,0 supplytransfercost, v_initial_date nonewsupplydate, ' ' shipcal
      ,''  ff_trigger_control,0 pullforwarddur, 0 splitqty, 0 loaddur
      ,0 unloaddur, ' ' reviewcal, 1 uselookaheadsw, 0 convenientshipqty
      ,0 convenientadjuppct, 0 convenientoverridethreshold, 0 roundingfactor
      ,' ' ordergroup, ' ' ordergroupmember, 0 lotsizesenabledsw
      ,0 convenientadjdownpct
from sourcing src, 
     /***********************************************************************
     ** Ranked Lanes Piece: Source Item, dest, dest_pc, source, source_pc
     ** ,max_dist, max_src, distance, rownum 
     ************************************************************************/
    (select all_lanes.item, all_lanes.dest, all_lanes.dest_pc, all_lanes.source
           ,ALL_LANES.SOURCE_PC, ALL_LANES.U_MAX_DIST, ALL_LANES.U_MAX_SRC
           ,all_lanes.distance, dense_rank()
           over ( partition by all_lanes.item, all_lanes.dest 
                  order by cost_pallet asc
                 ) as rank
    from  
    /**************************************************************************
    ** Getting All Lanes: item, dest, dest_pc, source, source_pc max_dist
    ** , max_src, dist and  cost(999 if null)
    ***************************************************************************/
    (select /*+ use_hash(lane_cost, lanes) parallel (lane_cost,4) parallel (lanes,4) */
            lanes.item, lanes.dest, lanes.dest_pc, lanes.source
            ,lanes.source_pc, lanes.u_max_dist, lanes.u_max_src
            ,lane_cost.distance, nvl(lane_cost.cost_pallet, 999) cost_pallet
            ,lane_cost.direction, lane_cost.u_equipment_type
        from
            /* Cost for the lanes from udt_cost_transit_na */ 
            (select direction
                   ,u_equipment_type u_equipment_type
                   ,substr(source_pc, 1, 5)        source_pc
                   ,source_geo       source_geo
                   ,substr(dest_pc, 1, 5)          dest_pc
                   ,dest_geo         dest_geo
                   ,source_co
                   ,distance         distance
                   ,cost_pallet      cost_pallet 
             from udt_cost_transit_na
             order by direction, u_equipment_type, source_pc, dest_pc, source_geo, dest_geo
            )  lane_cost, 
             /***********************************************************
             ** Lanes based on matching the source for producitonyield
             ** and dest for sku constraint. dest sku, max_dist, max_src
             ** ,dest_pc ,source, source_pc 
             *************************************************************/            
            (select /*+ use_hash(dest, source_sku, demand_group) parallel (dest,4)parallel (sku_source,4 ) */
                    ' ' direction
                   ,dest.item
                   ,dest.loc dest
                   ,dest.u_max_dist
                   ,dest.u_max_src
                   ,dest.dest_pc
                   ,dest.dest_geo
                   ,source_sku.loc source
                   ,source_sku.source_pc
                   ,source_sku.source_geo
                   ,case when dest.u_equipment_type='FB' then 'FB' 
                         else 'VN' 
                    end u_equipment_type
            
            from
                    /**********************************************************
                    ** Allowed Destinations (GLID) Based on SKUCONSTRAINT
                    ** ( OR ACTUAL DEMAND) Sku, max _dist, max _src, Postal Code
                    ***********************************************************/
                    (select distinct sku.item
                                    ,i.u_materialcode matcode
                                    ,sku.loc
                                    ,l.u_max_dist
                                    ,l.u_max_src
                                    ,substr(l.postalcode, 1, 5) dest_pc
                                    ,l.u_equipment_type u_equipment_type
                                    ,l.u_3digitzip dest_geo
                    from skuconstraint sku
                        ,loc l
                        ,item i
                    where sku.category = 1
                      and sku.loc = l.loc
                      and l.loc_type = 3
                      and l.U_AREA='NA'
                      and sku.item = i.item
                      and i.u_stock = 'C'
                      and sku.qty > 0
                      and sku.eff between u_14d_begin_skuconstraint 
                                      and u_14d_end_skuconstraint
                      and trim(l.postalcode ) is not null
                      and trim(l.u_3digitzip ) is not null
                    /* added by MAK - D not add extra unwanted lanes.*/
                      and not exists ( select '1' from udt_gidlimits_na gl 
                                        where gl.loc  = sku.loc 
                                          and gl.item = sku.item 
                                          and gl.mandatory_loc is not null )  
                    ) dest,
                    /***************************************************
                    ** Allowed Sources based on PRODUCITONYIELD (PLant).
                    ** sku, postalcode for the SOURCE SKU
                    ****************************************************/
                    (select distinct i.item
                          ,l.loc
                          ,substr(l.postalcode, 1, 5) source_pc
                          ,l.u_3digitzip source_geo
                          ,ps.status flatbed_status                        
                    from item i
                        ,loc l
                        ,sku sku
                        ,udt_plant_status ps                              
                    where l.loc=sku.loc
                    and l.loc_type in (2, 4)
                    and l.U_AREA='NA'
                    and l.postalcode  is not null
                    and l.u_3digitzip is not null
                    and is_5digit(l.postalcode) = 1
                    and is_3digit(l.u_3digitzip) = 1
                    and l.enablesw=1
                    and i.item=sku.item
                    and i.u_stock = 'C'
                    and i.enablesw=1
                    and ps.loc=sku.loc
                    and ps.res= 'SOURCEFLATBED'
                    and not exists
                       (select '1'
                          from udt_gidlimits_na gl
                         where   gl.exclusive_loc = sku.loc
                           and gl.item = sku.item
                       )
                    union 
                    select sku.item
                          ,sku.loc
                          ,substr(l1.postalcode, 1, 5) source_pc
                          ,l1.u_3digitzip source_geo
                          ,ps.status flatbed_status
                    from sku sku
                        ,loc l1
                        ,item i1
                        ,udt_plant_status ps       
                    where l1.loc_type in ( 2,4)
                      and i1.u_stock='C'
                      and sku.item=i1.item
                      and sku.oh > 0
                      and sku.loc=l1.loc
                      and trim(l1.postalcode )  is not null
                      and trim(l1.u_3digitzip ) is not null
                      and l1.U_AREA='NA'                       
                      and l1.loc=ps.loc
                      and ps.res= 'SOURCEFLATBED'
                      and not exists
                         (select '1'
                            from udt_gidlimits_na gl
                           where   gl.exclusive_loc = sku.loc
                             and gl.item = sku.item
                         )
                    ) source_sku
            where dest.loc <> source_sku.loc
              and dest.item = source_sku.item
              and ( ( u_equipment_type='FB'and source_sku.flatbed_status=1) 
                   or 
                    (u_equipment_type <> 'FB')
                  )
         ) lanes
        
      where lanes.u_equipment_type = lane_cost.u_equipment_type
        and lane_cost.direction     = ' '
        and lanes.dest_geo          = lane_cost.dest_geo
        and lanes.source_geo        = lane_cost.source_geo
        and lanes.u_max_dist       >= lane_cost.distance
        ) all_lanes
    ) ranked_lanes
/*******************************************************************************
**                      End of In Line Views
*******************************************************************************/
where ranked_lanes.rank <= ranked_lanes.u_max_src
and   ranked_lanes.item = src.item(+)
and   ranked_lanes.dest = src.dest(+)
and   ranked_lanes.source = src.source(+)
--and rownum <= ranked_lanes.u_max_src - ( select count(1)
--                                from sourcing src4
--                               where src4.dest=ranked_lanes.dest
--                                 and src4.item=ranked_lanes.item
--                            )
and not exists ( select '1' 
                   from udt_gidlimits_na gl1 
                  where gl1.loc  = src.dest
                    and gl1.item = src.item 
                    and gl1.forbidden_loc = src.source )
and not exists ( select '1'
                   from sourcing src3
                  where src3.source=ranked_lanes.source
                    and src3.dest=ranked_lanes.dest
                    and src3.item=ranked_lanes.item
                )
and src.item is null;

commit;

/*******************************************************************************
** Part 3: where no sourcing find closest loc_type = 2 location  ; less than 4k
**         Here, since I am looking for something not matched before
**===> I am doing this at the GeoCode level. If we want to do this at the 
**     5 digit zip code level, This code needs to be repeated at that level!!!!
*******************************************************************************/
insert into igpmgr.intins_sourcing 
                    ( integration_jobid
                      ,item, dest, source, transmode, eff,     factor, arrivcal
                      ,majorshipqty, minorshipqty, enabledyndepsw,shrinkagefactor
                      ,maxshipqty, abbr, sourcing, disc, maxleadtime, minleadtime
                      ,priority, enablesw, yieldfactor, supplyleadtime
                      ,costpercentage, supplytransfercost, nonewsupplydate
                      ,shipcal, ff_trigger_control, pullforwarddur, splitqty
                      ,loaddur, unloaddur, reviewcal, uselookaheadsw
                      ,convenientshipqty, convenientadjuppct
                      ,convenientoverridethreshold, roundingfactor, ordergroup
                      ,ordergroupmember, lotsizesenabledsw, convenientadjdownpct
                     )

SELECT DISTINCT 'U_30_SRC_DAILY_PART3' ,
  lanes.item,
  lanes.dest,
  lanes.source ,
  'TRUCK' transmode,
  v_initial_date eff,
  1 factor,
  ' ' arrivcal ,
  0 majorshipqty,
  0 minorshipqty,
  1 enabledyndepsw,
  0 shrinkagefactor ,
  0 maxshipqty,
  ' ' abbr,
  'ISSP1LANES-5ZIP' sourcing,
  v_initial_date disc ,
  1440 * 365 * 100 maxleadtime,
  0 minleadtime,
  1 priority,
  1 enablesw ,
  100 yieldfactor,
  0 supplyleadtime,
  100 costpercentage ,
  0 supplytransfercost,
  v_initial_date nonewsupplydate,
  ' ' shipcal ,
  '' ff_trigger_control,
  0 pullforwarddur,
  0 splitqty,
  0 loaddur ,
  0 unloaddur,
  ' ' reviewcal,
  1 uselookaheadsw,
  0 convenientshipqty ,
  0 convenientadjuppct,
  0 convenientoverridethreshold,
  0 roundingfactor ,
  ' ' ordergroup,
  ' ' ordergroupmember,
  0 lotsizesenabledsw ,
  0 convenientadjdownpct
FROM sourcing src,
  /*********************************************************************
  ** Getting All Lanes: item, dest, dest_pc, source, source_pc max_dist
  ** ,max_src, dist and  cost(999 if null)
  **********************************************************************/
(   SELECT direction ,
      u_equipment_type u_equipment_type ,
      SUBSTR(source_pc, 1, 5) source_pc ,
      source_geo source_geo ,
      SUBSTR(dest_pc, 1, 5) dest_pc ,
      dest_geo dest_geo ,
      source_co ,
      distance distance ,
      cost_pallet cost_pallet
    FROM udt_cost_transit_na
    ORDER BY direction,
      u_equipment_type,
      source_pc,
      dest_pc,
      source_geo,
      dest_geo
    ) lane_cost,
    ( SELECT DISTINCT llama.item item ,
      llama.dest dest,
      llama.source source,
      DECODE(ld.u_equipment_type,'FB','FB','VN') u_equipment_type,
      ls.postalcode source_pc,
      ld.postalcode dest_pc
    FROM skuconstraint sku ,
      udt_llamasoft_data llama,
      loc ls,
      loc ld
    WHERE sku.category IN (1,6)
    AND sku.loc         =llama.dest
    AND sku.item        =llama.item
    AND ld.loc          =sku.loc
    AND ld.loc_type     = 3
    AND ld.u_area       ='NA'
    AND sku.eff BETWEEN TRUNC(sysdate) AND TRUNC(sysdate) + 14
      --and sku.eff between u_14d_begin_skuconstraint and u_14d_end_skuconstraint
    AND sku.qty                > 0
    AND ls.loc                 =llama.source
    AND ls.loc_type           IN (1,2,4)
    AND trim(ld.postalcode )  IS NOT NULL
    AND trim(ld.u_3digitzip ) IS NOT NULL
    AND trim(ls.postalcode )  IS NOT NULL
    AND trim(ls.u_3digitzip ) IS NOT NULL
    ) lanes
where lane_cost.source_pc=lanes.source_pc
and   lane_cost.dest_pc=lanes.dest_pc
and   lane_cost.u_equipment_type=lanes.u_equipment_type
and src.source(+)=lanes.source
and src.dest(+)=lanes.dest
and src.item(+)=lanes.item
and src.item is null;


commit;



/*******************************************************************************
COMMENT OUT SUBSTITUTION UNTIL LATER DATE! 2016-02-11
** Part 4: where LOC:U_RUNEW_CUST = 1 for GID find the closest 
**         MFG location (LOC_TYPE = 1) and assign as a single source for RUNEW.
*******************************************************************************/
insert into intins_sourcing ( integration_jobid
    , item, dest, source, transmode, eff, factor, arrivcal, majorshipqty, minorshipqty, enabledyndepsw, shrinkagefactor, maxshipqty, abbr, sourcing, disc, 
    maxleadtime, minleadtime, priority, enablesw, yieldfactor, supplyleadtime, costpercentage, supplytransfercost, nonewsupplydate, shipcal, 
    ff_trigger_control, pullforwarddur, splitqty, loaddur, unloaddur, reviewcal, uselookaheadsw, convenientshipqty, convenientadjuppct, convenientoverridethreshold, 
    roundingfactor, ordergroup, ordergroupmember, lotsizesenabledsw, convenientadjdownpct)

select distinct 'U_30_SRC_DAILY_PART4'
    , u.item, u.dest, u.source, 'TRUCK' transmode, v_initial_date eff, 1 factor, ' ' arrivcal, 0 majorshipqty, 0 minorshipqty, 1 enabledyndepsw, 0 shrinkagefactor, 0 maxshipqty, 
    ' ' abbr, 'ISS4MFG' sourcing, v_initial_date disc, 1440 * 365 * 100 maxleadtime, 0 minleadtime, 1 priority, 1 enablesw, 100 yieldfactor, 0 supplyleadtime, 
    100 costpercentage, 0 supplytransfercost, v_initial_date nonewsupplydate, ' ' shipcal, ''  ff_trigger_control, 0 pullforwarddur, 0 splitqty, 0 loaddur, 0 unloaddur, 
    ' ' reviewcal, 1 uselookaheadsw, 0 convenientshipqty, 0 convenientadjuppct, 0 convenientoverridethreshold, 0 roundingfactor, ' ' ordergroup, ' ' ordergroupmember, 0 lotsizesenabledsw, 
    0 convenientadjdownpct
    
from sourcing c, 

    (select u.item, u.dest, u.dest_pc, u.source, u.source_pc, u.u_max_dist, u.u_max_src, u.distance, u.cost_pallet, dense_rank()
                            over (partition by u.item, u.dest order by cost_pallet asc) as rank
    from  

    (select c.item, c.dest, c.dest_pc, c.source, c.source_pc, c.u_max_dist, c.u_max_src, pc.distance,nvl(pc.cost_pallet, 999) cost_pallet
        from
                    
            (select distinct substr(source_pc, 1, 5) source_pc, substr(dest_pc, 1, 5) dest_pc, source_co, max(distance) distance, max(cost_pallet) cost_pallet 
            from udt_cost_transit_na  
            group by substr(source_pc, 1, 5), substr(dest_pc, 1, 5), source_co, dest_co
            )  pc, 
                        
            (select f.item, f.loc dest, f.u_max_dist, f.u_max_src, f.dest_pc, p.loc source, p.source_pc
            from

                    (select s.item, s.loc, l.u_max_dist, l.u_max_src, substr(l.postalcode, 1, 5) dest_pc
                    from sku s, loc l
                    where s.loc = l.loc
                    and l.u_area = 'NA'
                    and l.u_runew_cust = 1
                    and l.loc_type = 3
                    and s.item like '%RUNEW'
                    and not exists ( select '1' from udt_gidlimits_na gl 
                                      where gl.loc  = s.loc 
                                        and gl.item = s.item 
                                        and gl.mandatory_loc is not null )  
                    ) f,

                    (select s.item, s.loc, substr(l.postalcode, 1, 5) source_pc
                    from sku s, loc l, item i
                    where s.loc = l.loc
                    and l.u_area = 'NA'
                    and l.loc_type = 1
                    and s.item = i.item
                    and i.u_stock = 'C'
                    and not exists (select '1'
                                      from udt_gidlimits_na gl
                                     where gl.exclusive_loc = s.loc
                                       and gl.item = s.item
                         )
                    ) p
                    
            where f.item = p.item 
            ) c
                    
        where c.dest_pc = pc.dest_pc(+)
        and c.source_pc = pc.source_pc(+) 
        
        ) u
        
   --where u.distance < u.u_max_dist
   
    ) u
    
where u.rank = 1
and u.item = c.item(+)
and u.dest = c.dest(+)
and not exists ( select '1' 
                   from udt_gidlimits_na gl1 
                  where gl1.loc  = u.dest
                    and gl1.item = u.item 
                    and gl1.forbidden_loc = u.source )
and c.item is null;

commit;
/*******************************************************************************
** Part 5: where U_RUNEW_CUST = 1 and forecast exists for other 
**         non-RUNEW items then allow sourcing to LOC_TYPE = 1 
**         where substitution logic can be used to satisfy demand 
**         with RUNEW proxy
*******************************************************************************/
--insert into intins_sourcing ( integration_jobid
--   , item, dest, source, transmode, eff, factor, arrivcal, majorshipqty, minorshipqty, enabledyndepsw, shrinkagefactor, maxshipqty, abbr, sourcing, disc, 
--    maxleadtime, minleadtime, priority, enablesw, yieldfactor, supplyleadtime, costpercentage, supplytransfercost, nonewsupplydate, shipcal, 
--    ff_trigger_control, pullforwarddur, splitqty, loaddur, unloaddur, reviewcal, uselookaheadsw, convenientshipqty, convenientadjuppct, convenientoverridethreshold, 
--    roundingfactor, ordergroup, ordergroupmember, lotsizesenabledsw, convenientadjdownpct)
--
--select distinct 'U_30_SRC_DAILY_PART5'
--   , u.item, u.dest, u.source, 'TRUCK' transmode, v_initial_date eff, 1 factor, ' ' arrivcal, 0 majorshipqty, 0 minorshipqty, 1 enabledyndepsw, 0 shrinkagefactor, 0 maxshipqty, 
--    ' ' abbr, 'ISS5MFG' sourcing, v_initial_date disc, 1440 * 365 * 100 maxleadtime, 0 minleadtime, 1 priority, 1 enablesw, 100 yieldfactor, 0 supplyleadtime, 
--    100 costpercentage, 0 supplytransfercost, v_initial_date nonewsupplydate, ' ' shipcal, ''  ff_trigger_control, 0 pullforwarddur, 0 splitqty, 0 loaddur, 0 unloaddur, 
--    ' ' reviewcal, 1 uselookaheadsw, 0 convenientshipqty, 0 convenientadjuppct, 0 convenientoverridethreshold, 0 roundingfactor, ' ' ordergroup, ' ' ordergroupmember, 0 lotsizesenabledsw, 
--    0 convenientadjdownpct
--    
--from 
--
--    (select u.item, u.dest, u.dest_pc, u.source, u.source_pc, u.u_max_dist, u.u_max_src, u.distance, u.cost_pallet, dense_rank()
--                            over (partition by u.item, u.dest order by cost_pallet asc) as rank
--    from  
--
--    (select c.item, c.dest, c.dest_pc, c.source, c.source_pc, c.u_max_dist, c.u_max_src, pc.distance,nvl(pc.cost_pallet, 999) cost_pallet
--        from
--                    
--            (select distinct substr(source_pc, 1, 5) source_pc, substr(dest_pc, 1, 5) dest_pc, source_co, max(distance) distance, max(cost_pallet) cost_pallet 
--            from udt_cost_transit_na  
--            group by substr(source_pc, 1, 5), substr(dest_pc, 1, 5), source_co, dest_co
--            )  pc, 
--                        
--            (select f.item, f.loc dest, f.u_max_dist, f.u_max_src, f.dest_pc, p.loc source, p.source_pc
--            from
--
--                    (select k.item, k.loc, k.u_max_dist, k.u_max_src, k.dest_pc
--                    from
--
--                        (select c.item, c.dest, c.source
--                        from sourcing c, loc l
--                        where c.source = l.loc
--                        and l.loc_type = 1
--                        ) c,
--
--                        (select distinct k.item, k.loc, l.u_max_dist, l.u_max_src, substr(l.postalcode, 1, 5) dest_pc
--                        from skuconstraint k, loc l, item i
--                        where k.loc = l.loc
--                        and l.u_area = 'NA'
--                        and l.u_runew_cust = 1
--                        and k.item <> '4055RUNEW'
--                        and k.item = i.item
--                        and i.u_stock = 'C'
--                        and not exists ( select '1' from udt_gidlimits_na gl, loc l 
--                                          where gl.loc  = k.loc 
--                                            and gl.item = k.item 
--                                            and gl.mandatory_loc is not null
--                                            and l.loc=gl.mandatory_loc
--                                            and l.loc_type=1
--                         )  
--                        ) k
--
--                    where k.item = c.item(+)
--                    and k.loc = c.dest(+)
--                    and c.item is null
--                    ) f,
--
--                    (select s.item, s.loc, substr(l.postalcode, 1, 5) source_pc
--                    from sku s, loc l, item i
--                    where s.loc = l.loc
--                    and l.u_area = 'NA'
--                    and l.loc_type = 1
--                    and s.item = i.item
--                    and i.u_stock = 'C'
--                    and not exists (select '1'
--                                      from udt_gidlimits_na gl
--                                     where gl.exclusive_loc = s.loc
--                                       and gl.item = s.item
--                         )
--                    ) p
--                    
--            where f.item = p.item 
--            ) c
--                    
--        where c.dest_pc = pc.dest_pc(+)
--        and c.source_pc = pc.source_pc(+) 
--        
--        ) u
--        
--   --where u.distance < u.u_max_dist
--   
--    ) u
--    
--where u.rank = 1
--and not exists ( select '1' 
--                   from udt_gidlimits_na gl1 
--                  where gl1.loc  = u.dest
--                    and gl1.item = u.item 
--                    and gl1.forbidden_loc = u.source );
--
--commit;
/*******************************************************************************
** Part 6: collections
**         Find all possible sources within loc.u_max_dist nullu_max_srcs 
**         where UDT_COST_TRANSIT_NA matches source_pc and dest_pc or source_geo 
**         and dest_geo; 16k
*******************************************************************************/
insert into igpmgr.intins_sourcing
( integration_jobid
  ,item, dest, source, transmode, eff, factor, arrivcal, majorshipqty, minorshipqty
  ,enabledyndepsw,shrinkagefactor, maxshipqty, abbr, sourcing, disc, maxleadtime
  ,minleadtime, priority, enablesw, yieldfactor, supplyleadtime, costpercentage
  ,supplytransfercost, nonewsupplydate, shipcal, ff_trigger_control
  ,pullforwarddur, splitqty, loaddur, unloaddur, reviewcal, uselookaheadsw
  ,convenientshipqty, convenientadjuppct, convenientoverridethreshold
  ,roundingfactor, ordergroup, ordergroupmember, lotsizesenabledsw
  ,convenientadjdownpct
)
select distinct 'U_30_SRC_DAILY_PART6'
   ,u.item, u.dest, u.source, 'TRUCK' transmode, v_initial_date eff
   ,1 factor, ' ' arrivcal, 0 majorshipqty, 0 minorshipqty, 1 enabledyndepsw
   ,0 shrinkagefactor, 0 maxshipqty, ' ' abbr, 'COLL0FIXED' sourcing
   ,v_initial_date disc, 1440 * 365 * 100 maxleadtime, 0 minleadtime
   ,1 priority, 1 enablesw, 100 yieldfactor, 0 supplyleadtime, 100 costpercentage
   ,0 supplytransfercost, v_initial_date nonewsupplydate, ' ' shipcal
   ,''  ff_trigger_control, 0 pullforwarddur, 0 splitqty, 0 loaddur, 0 unloaddur
   ,' ' reviewcal, 1 uselookaheadsw, 0 convenientshipqty, 0 convenientadjuppct
   ,0 convenientoverridethreshold, 0 roundingfactor, ' ' ordergroup
   ,' ' ordergroupmember, 0 lotsizesenabledsw, 
    0 convenientadjdownpct
from (select i.item item 
      ,l1.loc source
      ,substr(l1.postalcode, 1, 5) source_pc
      ,l2.loc dest
      ,substr(l2.postalcode, 1, 5) dest_pc
      ,l1.u_max_dist max_dist
      ,l1.u_max_src  max_src
from udt_fixed_coll coll, item i, loc l1, loc l2
where i.u_stock = 'A'
  and coll.loc=l1.loc
  and l1.loc_type = '3'
  and coll.plant = l2.loc
  and l2.loc_type in ('2','4')
  and exists ( select '1'
                from skuconstraint skc 
               where skc.loc=l1.loc 
                 and skc.item=i.item
                 and skc.category=10
                 and skc.qty>0
             )
    ) u
where exists (select 1 
              from sku sku1, sku sku2 
             where sku1.item=u.item 
               and sku1.loc=u.dest
               and sku2.item=u.item 
               and sku2.loc=u.source)
and not exists ( select 1
                   from sourcing src
                  where src.item=u.item
                    and src.source=u.source
                    and src.dest=u.dest
                );
commit;

/*******************************************************************************
** Part 7: collections: Build collection based on udt_default_zip
*******************************************************************************/
insert into igpmgr.intins_sourcing
( integration_jobid
    ,item, dest, source, transmode, eff,     factor, arrivcal,     majorshipqty,     minorshipqty,     enabledyndepsw,     shrinkagefactor,     maxshipqty,     abbr,     sourcing,     disc,     
    maxleadtime,     minleadtime,     priority,     enablesw,     yieldfactor,     supplyleadtime,     costpercentage,     supplytransfercost,     nonewsupplydate,     shipcal,     
    ff_trigger_control,     pullforwarddur,     splitqty,     loaddur,     unloaddur,     reviewcal,     uselookaheadsw,     convenientshipqty,     convenientadjuppct,     convenientoverridethreshold,     
    roundingfactor,     ordergroup,     ordergroupmember,     lotsizesenabledsw,     convenientadjdownpct
)
select distinct 'U_30_SRC_DAILY_PART7'
   ,u.item, u.dest, u.source, 'TRUCK' transmode, v_initial_date eff,     1 factor,    ' ' arrivcal,     0 majorshipqty,     0 minorshipqty,     1 enabledyndepsw,     0 shrinkagefactor,     0 maxshipqty,     
    ' ' abbr, 'COLL5ZIPCODE' sourcing,     v_initial_date disc,     1440 * 365 * 100 maxleadtime,     0 minleadtime,     1 priority,     1 enablesw,     100 yieldfactor,     0 supplyleadtime,     
    100 costpercentage,     0 supplytransfercost,     v_initial_date nonewsupplydate,     ' ' shipcal,    ''  ff_trigger_control,     0 pullforwarddur,     0 splitqty,     0 loaddur,     0 unloaddur,     
    ' ' reviewcal,     1 uselookaheadsw,     0 convenientshipqty,     0 convenientadjuppct,     0 convenientoverridethreshold,     0 roundingfactor,     ' ' ordergroup,     ' ' ordergroupmember,     0 lotsizesenabledsw,     
    0 convenientadjdownpct
from 

    (SELECT k.item, k.loc source, k.postalcode, z.loc dest, k.qty
         FROM sourcing c, udt_default_zip z, sku s,
         
              (  SELECT DISTINCT k.item, k.loc, substr(l.postalcode, 1, 5) postalcode, SUM (qty) qty
                   FROM skuconstraint k, item i, loc l
                  WHERE     k.category = 10
                        AND k.item = i.item
                        AND i.u_stock = 'A'
                        AND k.loc = l.loc
                        AND l.loc_type = 3
               GROUP BY k.item, k.loc, l.postalcode
                 HAVING SUM (qty) > 0
                 ) k
                 
        WHERE k.item = c.item(+) 
        AND k.loc = c.source(+)
        and k.postalcode = z.postalcode
        and k.item = s.item
        and z.loc = s.loc 
        AND c.item IS NULL
    ) u;

commit;

/*******************************************************************************
** Part 8: TPM relocations (modified 06/19/2015)
*******************************************************************************/
insert into igpmgr.intins_sourcing
( integration_jobid
   ,item, dest, source, transmode, eff,     factor, arrivcal,     majorshipqty,     minorshipqty,     enabledyndepsw,     shrinkagefactor,     maxshipqty,     abbr,     sourcing,     disc,     
    maxleadtime,     minleadtime,     priority,     enablesw,     yieldfactor,     supplyleadtime,     costpercentage,     supplytransfercost,     nonewsupplydate,     shipcal,     
    ff_trigger_control,     pullforwarddur,     splitqty,     loaddur,     unloaddur,     reviewcal,     uselookaheadsw,     convenientshipqty,     convenientadjuppct,     convenientoverridethreshold,     
    roundingfactor,     ordergroup,     ordergroupmember,     lotsizesenabledsw,     convenientadjdownpct
)
with 
source_skus ( source,  postal_code, item, stocktype)
 as
  ( select l.loc source, substr(l.postalcode, 1, 5) postalcode, i.item, ps.u_stock
  from scpomgr.loc l, scpomgr.udt_plant_status ps, item i, sku sku
     where l.loc_type in ('2','4')
       and l.u_area='NA'
       and l.loc=ps.loc
       and (ps.res like '%RUSOURCE' or ps.res like '%ARSOURCE')
       and ps.status=1
       and ps.u_materialcode=i.u_materialcode
       and ps.u_stock in ('B','C')
       and ps.u_stock=i.u_stock
       and sku.item=i.item
       and sku.loc=l.loc
   ),
dest_skus ( dest,  postal_code,  item, max_dist, max_src, stocktype)
 as  
  ( select l.loc, substr(l.postalcode, 1, 5) postalcode, i.item, l.u_max_dist, l.u_max_src, ps.u_stock
  from scpomgr.loc l, scpomgr.udt_plant_status ps, item i, sku sku
     where l.loc_type in ('2','4')
       and l.u_area='NA'
       and l.loc=ps.loc
       and (ps.res like '%RUDEST' or ps.res like '%ARDEST')
       and ps.status=1
       and ps.u_materialcode=i.u_materialcode
       and ps.u_stock in ('B','C')
       and ps.u_stock=i.u_stock
       and sku.item=i.item
       and sku.loc=l.loc
),
lanes (source, dest, item, max_src, cost_pallet)
   as   
   (  
  select src.source, dest.dest, src.item, dest.max_src, max(ct.cost_pallet)
   from source_skus src, dest_skus dest, udt_cost_transit_na ct
  where src.source <> dest.dest
    and src.item=dest.item
    and src.stocktype=dest.stocktype
    and src.postal_code  = ct.source_pc
    and dest.postal_code = ct.dest_pc
    having max(ct.distance) < 800 -- dest.max_dist
      group by src.source, dest.dest, src.item, dest.max_src
 ),
ranked_lanes ( source, dest, item, max_src, rank)
  as 
   (
 SELECT LANE.SOURCE, LANE.DEST, LANE.ITEM, LANE.MAX_SRC
 ,dense_rank() over (partition by lane.item, lane.dest order by lane.cost_pallet asc) as rank
 from lanes lane
)
select distinct 'U_30_SRC_DAILY_PART8' 
   ,rl.item, rl.dest, rl.source, 'TRUCK' transmode, v_initial_date eff, 1 factor, ' ' arrivcal, 0 majorshipqty,     0 minorshipqty,     1 enabledyndepsw,     0 shrinkagefactor,     0 maxshipqty,     
    ' ' abbr, 'STOCKXFER' sourcing, v_initial_date disc,     1440 * 365 * 100 maxleadtime,     0 minleadtime,     1 priority,     1 enablesw,     100 yieldfactor,     0 supplyleadtime,     
    100 costpercentage,     0 supplytransfercost,  v_initial_date nonewsupplydate,     ' ' shipcal,    ''  ff_trigger_control,     0 pullforwarddur,     0 splitqty,     0 loaddur,     0 unloaddur,     
    ' ' reviewcal,     1 uselookaheadsw,     0 convenientshipqty,     0 convenientadjuppct,     0 convenientoverridethreshold,     0 roundingfactor,     ' ' ordergroup,     ' ' ordergroupmember,     0 lotsizesenabledsw,     
    0 convenientadjdownpct
   from ranked_lanes rl
   where rl.rank <= rl.max_src
   order by rl.dest, rl.item;
      
     
commit;

/*******************************************************************************
** Part 8B: Intra Plant Pairs
*******************************************************************************/
-- remove unwanted lanes between the intra tpm sites.
delete from sourcing src
where exists ( select 1 from udt_tpm_plant_pairs pp where pp.source=src.source and pp.dest=src.dest)
and src.sourcing like 'STOCK%';
commit;

insert into igpmgr.intins_sourcing
( integration_jobid
   ,item, dest, source, transmode, eff,     factor, arrivcal,     majorshipqty,     minorshipqty,     enabledyndepsw,     shrinkagefactor,     maxshipqty,     abbr,     sourcing,     disc,     
    maxleadtime,     minleadtime,     priority,     enablesw,     yieldfactor,     supplyleadtime,     costpercentage,     supplytransfercost,     nonewsupplydate,     shipcal,     
    ff_trigger_control,     pullforwarddur,     splitqty,     loaddur,     unloaddur,     reviewcal,     uselookaheadsw,     convenientshipqty,     convenientadjuppct,     convenientoverridethreshold,     
    roundingfactor,     ordergroup,     ordergroupmember,     lotsizesenabledsw,     convenientadjdownpct
)
with 
source_skus ( source,  postal_code, item, stocktype)
 as
  ( select l.loc source, substr(l.postalcode, 1, 5) postalcode, i.item, i.u_stock
  from scpomgr.loc l, item i, sku sku, udt_tpm_plant_pairs pp
     where l.loc_type in ('4')
       and l.u_area='NA'
       and sku.item=i.item
       and i.u_stock='B'
       and sku.loc=l.loc
       and l.loc=pp.source
   ),
dest_skus ( dest,  postal_code,  item, max_dist, max_src, stocktype)
 as  
  ( select l.loc, substr(l.postalcode, 1, 5) postalcode, i.item, l.u_max_dist, l.u_max_src, i.u_stock
  from scpomgr.loc l, item i, sku sku, udt_tpm_plant_pairs pp
     where l.loc_type in ('4')
       and l.u_area='NA'
       and sku.item=i.item
       and i.u_stock='B'
       and sku.loc=l.loc
       and l.loc=pp.dest
),
lanes (source, dest, item)
   as   
   (  
  select src.source, dest.dest, src.item
   from source_skus src, dest_skus dest
  where src.source <> dest.dest
    and src.item=dest.item
    and src.stocktype=dest.stocktype
    and exists ( select 1 from udt_tpm_plant_pairs pp where pp.source=src.source and pp.dest=dest.dest)
      group by src.source, dest.dest, src.item, dest.max_src
 )
select distinct 'U_30_SRC_DAILY_PART8B' 
   ,lanes.item, lanes.dest, lanes.source, 'TRUCK' transmode, v_initial_date eff, 1 factor, ' ' arrivcal, 0 majorshipqty,     0 minorshipqty,     1 enabledyndepsw,     0 shrinkagefactor,     0 maxshipqty,     
    ' ' abbr, 'INTRATPM' sourcing, v_initial_date disc,     1440 * 365 * 100 maxleadtime,     0 minleadtime,     1 priority,     1 enablesw,     100 yieldfactor,     0 supplyleadtime,     
    100 costpercentage,     0 supplytransfercost,  v_initial_date nonewsupplydate,     ' ' shipcal,    ''  ff_trigger_control,     0 pullforwarddur,     0 splitqty,     0 loaddur,     0 unloaddur,     
    ' ' reviewcal,     1 uselookaheadsw,     0 convenientshipqty,     0 convenientadjuppct,     0 convenientoverridethreshold,     0 roundingfactor,     ' ' ordergroup,     ' ' ordergroupmember,     0 lotsizesenabledsw,     
    0 convenientadjdownpct
   from lanes lanes;
      
      
commit;

/*******************************************************************************
** Part 9A: Delete moves to/from HI and PR to other states except PR to zip 32226
*******************************************************************************/
--COMMENT OUT UNTIL THEY ARE SATISFIED THIS IS NOT NEEDED!!!!!!!!!!!!!!!!!!!!!
delete  from sourcing 
where (item, source, dest, sourcing ) in
( select distinct item, source,  dest, sourcing
from sourcing src, loc ls, loc ld
where ls.loc=src.source
  and ld.loc=src.dest
  and ls.u_area ='NA'
  and LD.U_AREA ='NA'
  and ( LS.LOC_TYPE = 3 or ld.loc_type=3 )
  and ( (    ( ls.u_state='PR' and  ld.u_state <> 'PR'  )
          or ( ls.u_state<>'PR' and  ld.u_state = 'PR')
        )
      or 
      (    (  ls.u_state='HI' and  ld.u_state <> 'HI')
        or ( ls.u_state<>'HI' and  ld.u_state = 'HI')
      )
    )
);
--
--commit;

    
/*******************************************************************************
** Part 9: Update Sourcing Min LeadTime
*******************************************************************************/
declare
  cursor cur_selected is
    select c.item, c.dest, c.source, c.sourcing, t.transittime,
    case when t.transittime < 1 then 0 else round(t.transittime, 0)*1440 end transittime_new
    from sourcing c, u_42_src_costs_na2 t
    where c.item = t.item
    and c.dest = t.dest
    and c.source = t.source 
for update of c.minleadtime;

begin
  for cur_record in cur_selected loop
  
    update sourcing
    set minleadtime = cur_record.transittime_new
    where current of cur_selected;
    
  end loop;
  commit;
end;

/*******************************************************************************
** Part 10: Add Sourcing Draw Records
*******************************************************************************/
insert into igpmgr.intins_sourcingdraw 
( integration_jobid, sourcing, eff, item, dest, source, drawqty, qtyuom)
select 'U_30_SRC_DAILY_PART10'
       ,c.sourcing, v_initial_date eff, c.item, c.dest, c.source
       ,1 drawqty, 18 qtyuom 
from sourcing c, sourcingdraw d
where c.item = d.item(+)
and c.dest = d.dest(+)
and c.source = d.source(+)
and c.sourcing = d.sourcing(+)
and d.item is null;

commit;

/*******************************************************************************
** Part 11: Add Sourcing Yield Records
*******************************************************************************/
insert into igpmgr.intins_sourcingyield 
( integration_jobid, sourcing, eff, item, dest, source, yieldqty, qtyuom)
select 'U_30_SRC_DAILY_PART11'
       ,c.sourcing, v_initial_date eff, c.item, c.dest, c.source
       ,1 yieldqty, 18 qtyuom 
from sourcing c, sourcingyield d
where c.item = d.item(+)
and c.dest = d.dest(+)
and c.source = d.source(+)
and c.sourcing = d.sourcing(+)
and d.item is null;

commit;

/*******************************************************************************
** Part 12: Add Res Records
*******************************************************************************/
insert into igpmgr.intins_res 
(integration_jobid, loc, type,     res,    cal,  cost,     descr,  avgskuchg
  ,avgfamilychg,  avgskuchgcost,  avgfamilychgcost,     levelloadsw,     
    levelseqnum,  criticalitem, checkmaxcap,  unitpenalty,  adjfactor,  source,  enablesw,  subtype,   qtyuom,   currencyuom,     productionfamilychgoveropt
)
select distinct 'U_30_SRC_DAILY_PART12'
  ,u.dest loc
  , 5 type
  , u.res
  , ' ' cal
  , 0 cost
  , ' ' descr
  , 0 avgskuchg
  , 0 avgfamilychg
  , 0 avgskuchgcost
  , 0 avgfamilychgcost
  , 0 levelloadsw
  , 1 levelseqnum
  , ' ' criticalitem
  , 1 checkmaxcap
  , 0 unitpenalty
  , 1 adjfactor
  , u.source
  , 1 enablesw
  , 6 subtype
  , 18 qtyuom
  , 15 currencyuom
  , 0 productionfamilychgoveropt
from res r
  , (select distinct c.source
       , C.DEST
      , c.sourcing
        || '_'
        || c.source
        ||'->'
        ||c.dest res
    from sourcing c
    ) u
where u.res = r.res(+)
    and r.res is null;

commit;

/*******************************************************************************
** Part 13: Add SourcingRequirement Records
*******************************************************************************/
insert into igpmgr.intins_sourcingreq
( integration_jobid, stepnum,     nextsteptiming,     rate,     leadtime,     offset,     enablesw,     sourcing,     eff,     res,     item,     dest,     source,     qtyuom
)

select 'U_30_SRC_DAILY_PART13'
  ,1 stepnum
  , 3 nextsteptiming
  , 1 rate
  , 0 leadtime
  , 0 offset
  , 1 enablesw
  , u.sourcing
  , v_initial_date eff
  , u.res
  , u.item
  , u.dest
  , u.source
  , 18 qtyuom
from sourcingrequirement r
  , (select c.item
      , c.dest
      , c.source
      , c.sourcing
      , c.sourcing
        || '_'
        || c.source
        ||'->'
        ||c.dest res
    from sourcing c
    ) u
where u.item = r.item(+)
    and u.dest = r.dest(+)
    and u.source = r.source(+)
    and u.sourcing = r.sourcing(+)
    and r.item is null;

commit;

/*******************************************************************************
** Part 14: Add Cost Records
*******************************************************************************/
insert into igpmgr.intins_cost 
( integration_jobid, cost,  enablesw,   cumulativesw,  groupedsw,  sharedsw
  ,  qtyuom,  currencyuom,   accumcal,  maxqty,     maxutilization
)
select distinct 'U_30_SRC_DAILY_PART14'
  ,u.cost
  , 1 enablesw
  , 0 cumulativesw
  , 0 groupedsw
  , 0 sharedsw
  , 18 qtyuom
  , 15 currencyuom
  , ' ' accumcal
  , 0 maxqty
  , 0 maxutilization
from cost c
  , (select c.item
      , c.dest
      , c.source
      , c.sourcing
        || '_'
        || c.source
        ||'->'
        ||c.dest
        || '-202' cost
    from sourcing c
    ) u
where u.cost = c.cost(+)
    and c.cost is null;

commit;

/*******************************************************************************
** Part 15: Now insert costtier records for 5 digit lanes 
*******************************************************************************/
insert into igpmgr.intins_costtier 
(integration_jobid, breakqty, category, value, eff, cost)
select distinct 'U_30_SRC_DAILY_PART15'
  ,0 breakqty
  ,303 category
  ,lane_5zip_costed.value
  ,v_initial_date eff
  ,lane_5zip_costed.cost
from costtier costtier
  , cost cost
  , (select distinct lane_5zip.source source
      ,lane_5zip.dest dest
      ,lane_5zip.sourcing
        || '_'
        ||lane_5zip.source
        ||'->'
        ||lane_5zip.dest
        ||'-202' cost
      ,nvl(round(tranit_cost.cost_pallet/480, 3), 10) value
    from udt_cost_transit_na tranit_cost
      , (select distinct src.source
          ,src.sourcing
          ,src.dest
          ,substr(ls.postalcode, 1, 5) source_pc
          ,substr(ld.postalcode, 1, 5) dest_pc
          ,case
                when ld.u_equipment_type = 'FB'
                then 'FB'
                else 'VN'
            end u_equipment_type
        from sourcing src
          , loc ls
          , loc ld
        where src.source = ls.loc
            and src.dest = ld.loc
        ) lane_5zip
    where tranit_cost.direction(+)=' '
        and tranit_cost.u_equipment_type(+)=lane_5zip.u_equipment_type
        and lane_5zip.dest_pc = tranit_cost.dest_pc(+)
        and lane_5zip.source_pc = tranit_cost.source_pc(+)
    order by source
      , dest
    ) lane_5zip_costed
where cost.cost = lane_5zip_costed.cost
    and lane_5zip_costed.cost = costtier.cost(+)
    and costtier.cost is null;

commit;


/**********************************************************
** Part 16: Now insert costtier records for 3 digit lanes 
**          where the 5 digit lanes were defaulted 
**          or have a higher cost
***********************************************************/
insert into intups_costtier 
(integration_jobid, breakqty, category, value, eff, cost)
select distinct 'U_30_SRC_DAILY_PART16'
  ,0 breakqty
  ,303 category
  ,lane_3zip_costed.value
  ,v_initial_date eff
  ,lane_3zip_costed.cost
from costtier costtier
  , cost cost
  , (select distinct lane_3zip.source source
      ,lane_3zip.dest dest
      ,lane_3zip.sourcing
        ||'_'
        ||lane_3zip.source
        ||'->'
        ||lane_3zip.dest
        ||'-202' cost
      ,nvl(round(tranit_cost.cost_pallet/480, 3), 10) value
    from udt_cost_transit_na tranit_cost
      , ( select distinct src.source
          ,src.sourcing
          ,src.dest
          ,ls.u_3digitzip source_geo
          ,ld.u_3digitzip dest_geo
          ,case
                when ld.u_equipment_type = 'FB'
                then 'FB'
                else 'VN'
            end u_equipment_type
        from sourcing src
          , loc ls
          , loc ld
        where src.source = ls.loc
            and src.dest = ld.loc
        ) lane_3zip
    where tranit_cost.direction(+)=' '
        and lane_3zip.u_equipment_type = tranit_cost.u_equipment_type(+)
        and lane_3zip.source_geo = tranit_cost.source_geo(+)
        and lane_3zip.dest_geo = tranit_cost.dest_geo(+)
    order by source
      , dest
    ) lane_3zip_costed
where cost.cost = lane_3zip_costed.cost
    and lane_3zip_costed.cost = costtier.cost(+)
    and costtier.value >= 10
    --- Added by MAK ---
    and costtier.cost is null;

commit;

/**********************************************************
** Part 16B: Now insert costtier records for INTRATPM Lanes
***********************************************************/
insert into intups_costtier 
(integration_jobid, breakqty, category, value, eff, cost)
select distinct 'U_30_SRC_DAILY_PART16B'
  ,0 breakqty
  ,303 category
  ,0
  ,v_initial_date eff
  ,src.sourcing ||'_' ||src.source ||'->' ||src.dest ||'-202' cost
from sourcing src
where src.sourcing like 'INTRATPM%';

/**********************************************************
** Part 17: Now Populate teh ResCost table
***********************************************************/
insert into  intups_rescost 
(integration_jobid, category, res, localcost, tieredcost)
select distinct 'U_30_SRC_DAILY_PART17'
  ,202 category
  , u.res
  , u.cost localcost
  , ' ' tieredcost
from rescost r
  , costtier t
  , (select distinct c.dest
      , c.source
      , c.sourcing
        ||'_'
        || c.source
        ||'->'
        ||c.dest res
      , c.sourcing
        ||'_'
        || c.source
        ||'->'
        ||c.dest
        ||'-202' cost
    from sourcing c
    ) u
where u.cost = t.cost
    and u.cost = r.localcost(+)
    and r.localcost is null;

commit;

end;
