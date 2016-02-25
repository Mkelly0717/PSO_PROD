--------------------------------------------------------
--  DDL for Function V_SKU_EXISTS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."V_SKU_EXISTS" (IN_LOC varchar2, IN_ITEM varchar2)
RETURN number 
is
v_number number :=0;
BEGIN
  SELECT COUNT(1) INTO V_NUMBER
  FROM SKU SKU
  WHERE SKU.LOC = IN_LOC
    and SKU.ITEM= IN_ITEM;
  If ( V_NUMBER > 0    ) then
     v_number := 1;
  else 
     v_number := 0;
  end if;
  
  return v_number;

  exception
    WHEN OTHERS THEN RETURN 0;
END V_SKU_EXISTS;
