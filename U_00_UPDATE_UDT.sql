--------------------------------------------------------
--  DDL for Procedure U_00_UPDATE_UDT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_00_UPDATE_UDT" as

begin

execute immediate 'truncate table stgmgr.udt_yield';

insert into stgmgr.udt_yield

select *
from scpomgr.udt_yield

commit;

execute immediate 'truncate table stgmgr.udt_yieldrate';

insert into stgmgr.udt_yieldrate

select *
from scpomgr.udt_yieldrate

commit;

execute immediate 'truncate table stgmgr.udt_substitute';

insert into stgmgr.udt_substitute

select *
from scpomgr.udt_substitute

commit;

execute immediate 'truncate table stgmgr.udt_srclimits';

insert into stgmgr.udt_srclimits

select *
from scpomgr.udt_srclimits

commit;

execute immediate 'truncate table stgmgr.udt_gidlimits';

insert into stgmgr.udt_gidlimits

select *
from scpomgr.udt_gidlimits

commit;

execute immediate 'truncate table stgmgr.udt_cost_unit';

insert into stgmgr.udt_cost_unit

select *
from scpomgr.udt_cost_unit

commit;

execute immediate 'truncate table stgmgr.udt_cost_transit';

insert into stgmgr.udt_cost_transit

select *
from scpomgr.udt_cost_transit

commit;

execute immediate 'truncate table stgmgr.udt_loc'; 

insert into stgmgr.udt_loc 

select *
from scpomgr.loc 
where u_area = 'EU';

commit;

execute immediate 'truncate table stgmgr.udt_translate_dmdunit';

insert into stgmgr.udt_translate_dmdunit

select *
from scpomgr.udt_translate_dmdunit;

commit;

execute immediate 'truncate table stgmgr.udt_stock_target';

insert into stgmgr.udt_stock_target

select *
from scpomgr.udt_stock_target;

commit;

execute immediate 'truncate table stgmgr.udt_parameters';

insert into stgmgr.udt_parameters

select *
from scpomgr.udt_parameters;

commit;

execute immediate 'truncate table stgmgr.udt_dfuview';

insert into stgmgr.udt_dfuview

select v.*
from scpomgr.dfuview v, loc l
where v.loc = l.loc
and l.u_area = 'EU'
and v.u_dfulevel = 0;

commit; 

execute immediate 'truncate table stgmgr.udt_dfu';

insert into stgmgr.udt_dfu 

select d.*
from scpomgr.dfu d, scpomgr.dfuview v, loc l
where d.loc = l.loc
and l.u_area = 'EU'
and l.loc_type = 3
and d.dmdunit = v.dmdunit
and d.dmdgroup = v.dmdgroup
and d.loc = v.loc
and v.u_dfulevel = 0;

commit;

execute immediate 'truncate table stgmgr.udt_fcst';

insert into stgmgr.udt_fcst

select f.*
from scpomgr.fcst f, scpomgr.dfuview v, loc l
where f.loc = l.loc
and l.u_area = 'EU'
and l.loc_type = 3
and f.dmdunit = v.dmdunit
and f.dmdgroup = v.dmdgroup
and f.loc = v.loc
and v.u_dfulevel = 0;

commit; 

end;
