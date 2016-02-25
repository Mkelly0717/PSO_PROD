--------------------------------------------------------
--  DDL for Function IS_NUMBER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."IS_NUMBER" (p_string varchar2) return number
is v_number number;

begin
   if  LENGTH(TRIM(TRANSLATE(p_string, ' +-.0123456789', ' '))) > 0 then
       v_number := 0;
    else
      v_number := 1;
   end if;
   
   return v_number;
    exception
    when others then return 0;
    
end;
