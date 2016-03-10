--------------------------------------------------------
--  DDL for Procedure U_35_TPM_CORRECTIONS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_35_TPM_CORRECTIONS" 
as
begin
    /*************************************************************
    ** Part 1: Truncate UDT_TPM_CORRECTIONS
    *************************************************************/
    execute immediate 'truncate table udt_tpm_corrections';
    /*************************************************************
    ** Part 2: Create UDT_TPM_CORRECTIONS records from
    **         SKUCONSTRAINT table
    *************************************************************/
    --insert into igpmgr.intins_udt_tpm_corrections
    --( integration_jobid, loc, item, eff, orig_qty, category )
    --select 'U_35_TPM_CORRECTIONS_PART2'
    --         ,skc.loc
    --           ,skc.item
    --           ,skc.eff
    --           ,skc.qty
    --           ,skc.category
    insert
    into udt_tpm_corrections
        (
            loc
          , item
          , eff
          , orig_qty
          , category
        )
    select skc.loc
      , skc.item
      , skc.eff
      , skc.qty
      , skc.category
    from skuconstraint skc
      , loc l
    where l.loc=skc.loc
        and l.loc_type in (2,4)
        and l.enablesw=1
        and skc.category=10
        and skc.policy=1;
    commit;
    /*************************************************************
    ** Part 3: Calculate the Adjustment Qty and update
    **         UDT_TPM_CORRECTIONS
    *************************************************************/
    update udt_tpm_corrections udt
    set adjustment_qty =
        (select qty
        from udv_tpm_corrections udv
        where udv.loc=udt.loc
            and udv.item=udt.item
            and udv.eff=udt.eff
        );
    commit;
    /*************************************************************
    ** Part 4: Update UDT_TPM_CORRECTIONS with Corrected QTY
    *************************************************************/
    update udt_tpm_corrections udt
    set corrected_qty = (
        case
            when orig_qty - adjustment_qty < 0
            then 0
            else orig_qty - adjustment_qty
        end );
    commit;
    /*************************************************************
    ** Part 5: Update SKUCONSTRAINT with Corrected value
    *************************************************************/
    update skuconstraint skc
    set skc.qty =
        (select udtx.corrected_qty
        from udt_tpm_corrections udtx
        where udtx.loc =skc.loc
            and udtx.item=skc.item
            and udtx.category=skc.category
            and udtx.eff=skc.eff
            and trim(udtx.adjustment_qty) is not null
        )
    where exists
        (select udtx.corrected_qty
        from udt_tpm_corrections udtx
        where udtx.loc =skc.loc
            and udtx.item=skc.item
            and udtx.category=skc.category
            and udtx.eff=skc.eff
            and trim(udtx.adjustment_qty) is not null
        );
    commit;
    /*************************************************************
    ** Part 6: Create ResConstraint Records
    *************************************************************/
    delete resconstraint
    where substr(res, 1, 10) in ('COLL0FIXED');
    commit;
    insert
    into igpmgr.intins_resconstraint
        (
            integration_jobid
          , eff
          , policy
          , qty
          , dur
          ,category
          , res
          , qtyuom
          , timeuom
        )
    select 'U_35_TPM_CORRECTIONS_PART6'
      ,u.eff
      , 1 policy
      , u.qty*1*1 qty
      , 1440 *1*1 dur
      , u.category
      ,u.res
      , 18 qtyuom
      , 0 timeuom
    from resconstraint c
      , (select r.res
          , r.loc
          , lqty.eff eff
          , lqty.lane_qty qty
          , 12 category
        from res r
          , udv_lane_qty_calculation lqty
        where r.type = 5
            and r.res like 'COLL0FIXED%'
            and r.loc=lqty.loc
            and r.res=lqty.res
        union
        select r.res
          , r.loc
          , lqty.eff eff
          , lqty.lane_qty qty
          , 11 category
        from res r
          , udv_lane_qty_calculation lqty
        where r.type = 5
            and r.res like 'COLL0FIXED%'
            and r.loc=lqty.loc
            and r.res=lqty.res
        ) u
    where u.res = c.res(+)
        and u.eff = c.eff(+)
        and u.category = c.category(+)
        and c.res is null
    order by u.res
      , u.eff;
    commit;
    /******************************************************************
    ** Part 7: Create Resource Penalty Records
    ******************************************************************/
    delete respenalty
    where substr(res, 1, 10) = 'COLL0FIXED';
    commit;
    insert
    into igpmgr.intins_respenalty
        (
            integration_jobid
          , eff
          , rate
          , category
          , res
          , currencyuom
          , qtyuom
          , timeuom
        )
    select distinct 'U_15_SKU_WEEKLY_PART5'
      ,rc.eff eff
      , 45000 rate
      , 112 category
      , rc.res
      , 15 currencyuom
      , 18 qtyuom
      , 0 timeuom
    from resconstraint rc
    where substr(rc.res, 1, 10) = 'COLL0FIXED'
      and category=12
    union
     select distinct 'U_15_SKU_WEEKLY_PART5'
      ,rc.eff eff
      , 45000 rate
      , 111 category
      , rc.res
      , 15 currencyuom
      , 18 qtyuom
      , 0 timeuom
    from resconstraint rc
    where substr(rc.res, 1, 10) = 'COLL0FIXED'
      and category=11;
    commit;
end;
