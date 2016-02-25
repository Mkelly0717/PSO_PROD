--------------------------------------------------------
--  DDL for Function IS_5DIGIT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."IS_5DIGIT" (Zip_Code varchar2)
RETURN number 
is
v_number number :=0;
BEGIN
  
  if (  Length(Zip_Code) = 5 
      and regexp_like( Zip_Code, '[0-9][0-9][0-9][0-9][0-9]')) then
     v_number := 1;
  else 
     v_number := 0;
  end if;
  
  return v_number;

  exception
    When Others Then Return 0;
END IS_5DIGIT;
