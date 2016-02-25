--------------------------------------------------------
--  DDL for Procedure U_60_PST_STOREMETRICS_BACKUP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_60_PST_STOREMETRICS_BACKUP" as

begin

execute immediate 'truncate table udt_skumetric_dy';

insert into udt_skumetric_dy

select *  
from skumetric;

commit;

execute immediate 'truncate table udt_sourcingmetric_dy';

insert into udt_sourcingmetric_dy

select *  
from sourcingmetric;

commit;

execute immediate 'truncate table udt_productionmetric_dy';

insert into udt_productionmetric_dy

select *  
from productionmetric;

commit;

--about five minutes; must run this before running u_60_pst_validation

execute immediate 'truncate table udt_resmetric_dy';

insert into udt_resmetric_dy 
 
select *  
from resmetric;

commit;

execute immediate 'truncate table udt_productionresmetric_dy';

insert into  udt_productionresmetric_dy  

select *  
from productionresmetric;

commit;



execute immediate 'truncate table udt_sourcingresmetric_dy';

insert into udt_sourcingresmetric_dy  

select *  
from sourcingresmetric;

commit;

end;
