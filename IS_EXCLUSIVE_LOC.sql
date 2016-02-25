--------------------------------------------------------
--  DDL for Function IS_EXCLUSIVE_LOC
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."IS_EXCLUSIVE_LOC" (
            in_loc varchar2)
        return number
    is
        v_number number :=0;
    begin
        select count(1)
        into v_number
        from udt_gidlimits_na ml
        where ml.loc = in_loc
            and exclusive_loc is not null;
        if ( v_number > 0 ) then
            v_number := 1;
        else
            v_number := 0;
        end if;
        return v_number;
    exception
    when others then
        return 0;
    end is_exclusive_loc;
