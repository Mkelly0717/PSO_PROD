--------------------------------------------------------
--  DDL for Function IS_SKUEFF_IN_EFFECT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."IS_SKUEFF_IN_EFFECT" (
            in_loc  varchar2,
            in_item varchar2)
        return number
    is
        v_number number :=0;
    begin
        select count(1)
        into v_number
        from skuconstraint sku
        where sku.loc=in_loc
            and sku.item=in_item
            and sku.eff <= v_demand_end_date +6
;
        if ( v_number > 0 ) then
            v_number := 1;
        else
            v_number := 0;
        end if;
        return v_number;
    exception
    when others then
        return 0;
    end is_skueff_in_effect;
