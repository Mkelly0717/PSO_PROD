--------------------------------------------------------
--  DDL for Function V_EFF_DAY_NAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."V_EFF_DAY_NAME" ( v_eff integer , v_format varchar2 ) RETURN varchar2 IS
dayname varchar2(9);
/******************************************************************************
   NAME:       v_eff_day_name
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2/25/2008          1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     v_eff_day_name
      Sysdate:         2/25/2008
      Date and Time:   2/25/2008, 1:09:07 PM, and 2/25/2008 1:09:07 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
dayname:=rtrim (to_char (  to_date ('19700101', 'YYYYMMDD'
                          )
                 + (  v_eff/ 1440),v_format
			   ) 
	  );
   RETURN dayname;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END v_eff_day_name;
