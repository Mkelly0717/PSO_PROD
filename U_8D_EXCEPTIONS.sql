--------------------------------------------------------
--  DDL for Procedure U_8D_EXCEPTIONS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_8D_EXCEPTIONS" as

begin


delete optimizerskuexception where loc in (select loc from loc where u_area = 'NA');

commit;

delete optimizersourcingexception where dest in (select loc from loc where u_area = 'NA');

commit;

delete optimizerprodexception where loc in (select loc from loc where u_area = 'NA');

commit;

execute immediate 'truncate table optimizercostexception';

execute immediate 'truncate table optimizerresexception';

delete optimizerexception;

commit;

execute immediate 'truncate table optimizerlocmap';

execute immediate 'truncate table optimizerresmap';

execute immediate 'truncate table optimizerskumap';

execute immediate 'truncate table optimizersourcingmap';

execute immediate 'truncate table optimizerproductionmap';

execute immediate 'truncate table processsku';

execute immediate 'truncate table optimizerbasiscount';

execute immediate 'truncate table optimizerbasis';

commit;

delete resexception;

commit;

delete from sim_skumetric 
      where loc in (select loc from loc where u_area = 'NA')
	    and simulation_name = 'AD';

commit;

delete from sim_resmetric 
      where res in (select res from res where loc in (select loc from loc where u_area = 'NA'))
	    and simulation_name='AD';

commit;

delete from sim_productionmetric 
      where loc in (select loc from loc where u_area = 'NA')
        and simulation_name='AD';

commit;

delete from sim_productionresmetric 
      where loc in (select loc from loc where u_area = 'NA')
	    and simulation_name='AD';

commit;

delete from sim_sourcingresmetric 
      where dest in (select loc from loc where u_area = 'NA')
	    and simulation_name='AD';

commit;

delete from sim_sourcingmetric 
      where dest in (select loc from loc where u_area = 'NA')
	    and simulation_name='AD';

commit;

end;
