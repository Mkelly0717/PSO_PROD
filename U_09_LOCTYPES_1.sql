--------------------------------------------------------
--  DDL for Procedure U_09_LOCTYPES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_09_LOCTYPES" as

    /* 1: This process is limited to loc.u_area='NA'
    2: All locs are set to 6
    3: All locations with ISS Demand for are set to 3
    4: All locs with TPM demand at level 1 are set to 4
    5: All locations with a valid Buy process are set to 1
    6: All locations with a valid Plant process
    which do not have TPM demand are set to 2
    */
    
    begin_date date;
    end_date date;
    
begin

    select v_demand_start_date into begin_date from dual;
    select v_demand_end_date+7 into end_date from dual;  --12/16/2015 - needed to make adjustment to v_demand_end_date; it was developed for weekly model
    /* Reset All Loc Types to 6 */
    
    update loc loc
    set loc.loc_type=6
    where loc.u_area='NA';
    
    commit;
    
    /* Assign Customer Locations with Demand */
    
    update loc loc1
    set loc1.loc_type =3
    where loc1.loc_type=6
        and loc1.u_area='NA'
        and exists
        
        ( select distinct fcst.loc
        from fcst fcst
          , loc loc
          , dfuview dfuview
        where fcst.startdate between begin_date and end_date
            and fcst.dmdgroup in ('ISS','COL')
            and loc.loc=fcst.loc
            and loc.u_area='NA'
            and dfuview.loc=fcst.loc
            and dfuview.dmdunit=fcst.dmdunit
            and dfuview.dmdgroup=fcst.dmdgroup
            and dfuview.u_dfulevel = 0
            and fcst.qty > 0
            and loc.loc=loc1.loc
        );
        
    commit;
    
    /* Assign TPM Locations with TPM Demand at level 1 */
    update loc loc1
    set loc1.loc_type =4
    where loc1.loc_type=6
        and loc1.u_area='NA'
        and exists
        
        ( select distinct fcst.loc
        from fcst fcst
          , loc loc
          , dfuview dfuview
        where loc.loc=loc1.loc
            and fcst.startdate between begin_date and end_date
            and fcst.dmdunit = 'PALLET'
            and fcst.dmdgroup = 'TPM'
            and loc.loc=fcst.loc
            and loc.u_area='NA'
            and dfuview.loc=fcst.loc
            and dfuview.dmdunit=fcst.dmdunit
            and dfuview.dmdgroup=fcst.dmdgroup
            and dfuview.u_dfulevel = 1
            and fcst.qty > 0
            and exists
            
            (select 1
            from udt_yield_na y
              , udt_plant_status ps
            where y.productionmethod in ('INS', 'REP','HTR')
                and y.yield > 0
                and y.maxcap > 0
                and ps.loc=y.loc
                and ps.status=1
                and ps.u_materialcode=y.matcode
                and ps.res = any ('4055RUSOURCE' ,'4055ARDEST' ,'REPAIR' ,'SORT' ,'HEATTREAT' ,'4055ARSOURCE' ,'4055RUDEST' ,'SOURCEFLATBED' ,'WASH' ,'CPU')
                and y.loc=loc1.loc
            )
        );
        
    commit;
    
    /* Assign Manufacturer Locations with BUY Processes */
    
    update loc loc1
    set loc1.loc_type =1
    where loc1.loc_type=6
        and loc1.u_area='NA'
        and exists
        (select *
        from udt_yield_na y
        where y.productionmethod='BUY'
            and y.yield > 0
            and y.maxcap > 0
            and y.loc=loc1.loc
        );
        
    commit;
    
    /* Assign Service Center Locations with valid INS, REP, or HTR processes */
    
    update loc loc1
    set loc1.loc_type =2
    where loc1.loc_type=6
        and loc1.u_area='NA'
        and exists
        
        (select 1
        from udt_yield_na y
          , udt_plant_status ps
        where y.productionmethod in ('INS', 'REP','HTR')
            and y.yield > 0
            and y.maxcap > 0
            and ps.loc=y.loc
            and ps.status=1
            and ps.u_materialcode=y.matcode
            and ps.res = any ('4055RUSOURCE' ,'4055ARDEST' ,'REPAIR' ,'SORT' ,'HEATTREAT' ,'4055ARSOURCE' ,'4055RUDEST' ,'SOURCEFLATBED' ,'WASH' ,'CPU')
            and y.loc=loc1.loc
        );
        
    commit;
    
    /* Codes to check the counts of the loc types assigned
    select loc_type, count(1)
    from loc
    where u_area='NA'
    group by loc_type
    order by loc_type asc;
    */
    
    
    update loc l
    set u_max_dist =
      case
        when u_max_dist <= 800
        then 800
        else u_max_dist
      end
    where l.u_area='NA'; 
end;
