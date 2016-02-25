--------------------------------------------------------
--  DDL for Function IS_IN_GIDLIMITS_NA
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."IS_IN_GIDLIMITS_NA" (IN_LOC varchar2)
RETURN number 
is
v_number number :=0;
BEGIN
  SELECT COUNT(1) INTO V_NUMBER
  FROM UDT_GIDLIMITS_NA ML
  WHERE ML.LOC = IN_LOC;
  If ( V_NUMBER > 0    ) then
     v_number := 1;
  else 
     v_number := 0;
  end if;
  
  return v_number;

  exception
    WHEN OTHERS THEN RETURN 0;
END IS_IN_GIDLIMITS_NA;
