--------------------------------------------------------
--  DDL for Procedure U_00_UPDATE_UDT_NA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_00_UPDATE_UDT_NA" as

begin

execute immediate 'truncate table TMP_STORAGE_CAPACITY';

insert into TMP_STORAGE_CAPACITY

select * 
from SCPOMGR.TMP_STORAGE_CAPACITY@SCPOMGR_CHPTSTDB.JDADELIVERS.COM;

commit;

delete UDT_AREA where u_area = 'NA';

commit;

insert into UDT_AREA

select * 
from SCPOMGR.UDT_AREA@SCPOMGR_CHPTSTDB.JDADELIVERS.COM
where u_area = 'NA';

commit;

insert into udt_area_type

select * 
from SCPOMGR.UDT_AREA_TYPE@SCPOMGR_CHPTSTDB.JDADELIVERS.COM
where u_area not in (select u_area from udt_area_type);

commit;

execute immediate 'truncate table UDT_COST_TRANSIT_NA';

insert into UDT_COST_TRANSIT_NA

select * 
from SCPOMGR.UDT_COST_TRANSIT_NA@SCPOMGR_CHPTSTDB.JDADELIVERS.COM;

commit;

execute immediate 'truncate table UDT_COST_UNIT_NA';

insert into UDT_COST_UNIT_NA

select * 
from SCPOMGR.UDT_COST_UNIT@SCPOMGR_CHPTSTDB.JDADELIVERS.COM  --table needs to be renamed in tst
where loc in (select loc from loc where u_area = 'NA');

commit;

execute immediate 'truncate table UDT_DEFAULT_PARAMETERS';

insert into UDT_DEFAULT_PARAMETERS

select * 
from SCPOMGR.UDT_DEFAULT_PARAMETERS@SCPOMGR_CHPTSTDB.JDADELIVERS.COM;

commit;

execute immediate 'truncate table UDT_DEFAULT_ZIP';

insert into UDT_DEFAULT_ZIP

select * 
from SCPOMGR.UDT_DEFAULT_ZIP@SCPOMGR_CHPTSTDB.JDADELIVERS.COM;

commit;

execute immediate 'truncate table UDT_DIRECTION';

insert into UDT_DIRECTION

select * 
from SCPOMGR.UDT_DIRECTION@SCPOMGR_CHPTSTDB.JDADELIVERS.COM;

commit;

execute immediate 'truncate table UDT_EQUIPMENT_CONVERSION';

insert into UDT_EQUIPMENT_CONVERSION

select * 
from SCPOMGR.UDT_EQUIPMENT_CONVERSION@SCPOMGR_CHPTSTDB.JDADELIVERS.COM;

commit;

execute immediate 'truncate table UDT_EQUIPMENT_TYPE';

insert into UDT_EQUIPMENT_TYPE

select * 
from SCPOMGR.UDT_EQUIPMENT_TYPE@SCPOMGR_CHPTSTDB.JDADELIVERS.COM;

commit;

execute immediate 'truncate table UDT_FIXED_COLL';

insert into  UDT_FIXED_COLL

select c.loc, c.plant, c.percen 
from SCPOMGR.UDT_FIXED_COLL@SCPOMGR_CHPTSTDB.JDADELIVERS.COM c, loc l
where c.loc = l.loc;

commit;

execute immediate 'truncate table UDT_GIDLIMITS_NA';

insert into UDT_GIDLIMITS_NA

select g.*
from SCPOMGR.UDT_GIDLIMITS_NA@SCPOMGR_CHPTSTDB.JDADELIVERS.COM g, loc l
where g.loc = l.loc;

commit;

execute immediate 'truncate table UDT_LANE_TYPE';

insert into UDT_LANE_TYPE

select * 
from SCPOMGR.UDT_LANE_TYPE@SCPOMGR_CHPTSTDB.JDADELIVERS.COM;

commit;

execute immediate 'truncate table UDT_PLANT_CAPABILITIES';

insert into UDT_PLANT_CAPABILITIES

select * 
from SCPOMGR.UDT_PLANT_CAPABILITIES@SCPOMGR_CHPTSTDB.JDADELIVERS.COM;

commit;

execute immediate 'truncate table UDT_PLANT_STATUS';

insert into UDT_PLANT_STATUS

select * 
from SCPOMGR.UDT_PLANT_STATUS@SCPOMGR_CHPTSTDB.JDADELIVERS.COM;

commit;

execute immediate 'truncate table UDT_RATE_TYPE';

insert into UDT_RATE_TYPE

select * 
from SCPOMGR.UDT_RATE_TYPE@SCPOMGR_CHPTSTDB.JDADELIVERS.COM;

commit;

execute immediate 'truncate table UDT_STOCK_TARGET_NA';

insert into UDT_STOCK_TARGET_NA

select * 
from SCPOMGR.UDT_STOCK_TARGET@SCPOMGR_CHPTSTDB.JDADELIVERS.COM  --table needs to be renamed in tst
where loc in (select loc from loc where u_area = 'NA');

commit;

execute immediate 'truncate table UDT_YIELD_NA';

insert into UDT_YIELD_NA

select * 
from SCPOMGR.UDT_YIELD_NA@SCPOMGR_CHPTSTDB.JDADELIVERS.COM;

commit;

-- udt_loc_type - what is the purpose of this??

end;
