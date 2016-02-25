--------------------------------------------------------
--  DDL for Function IS_PLANT_VALID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."IS_PLANT_VALID" (IN_LOC varchar2)
RETURN number 
is
v_number number :=0;
BEGIN
  select count(1) into v_number
  FROM LOC L
  where l.loc = in_loc
    and l.loc_type in (2,4,5)
    and l.enablesw=1
    and is_5digit(l.postalcode)=1
    and is_3digit(l.u_3digitzip)=1;
  If ( V_NUMBER > 0    ) then
     v_number := 1;
  else 
     v_number := 0;
  end if;
  
  return v_number;

  exception
    when others then return 0;
END IS_PLANT_VALID;
