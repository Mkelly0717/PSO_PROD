--------------------------------------------------------
--  DDL for Procedure U_8D_SOURCING
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_8D_SOURCING" as

--about 12 minutes, (line 35 almost all)

begin

delete optimizersourcingexception
    where dest in (select loc from loc where u_area = 'NA');

delete sourcingconstraint
    where dest in (select loc from loc where u_area = 'NA');

delete sourcingcost
    where dest in (select loc from loc where u_area = 'NA');

delete sourcingdraw
    where dest in (select loc from loc where u_area = 'NA');

delete sourcingyield
    where dest in (select loc from loc where u_area = 'NA');

delete sourcingleadtime
    where dest in (select loc from loc where u_area = 'NA');

delete from sim_sourcingmetric
    where dest in (select loc from loc where u_area = 'NA')
	  and simulation_name='AD';

delete sim_sourcingresmetric
    where dest in (select loc from loc where u_area = 'NA')
	  and simulation_name='AD';

delete sourcingpenalty
    where dest in (select loc from loc where u_area = 'NA');

delete sourcingtarget
    where dest in (select loc from loc where u_area = 'NA');

delete marginalpriceandslacksrcng
    where dest in (select loc from loc where u_area = 'NA');

delete reducedcostsourcing
    where dest in (select loc from loc where u_area = 'NA');

delete sourcingproj
    where dest in (select loc from loc where u_area = 'NA');

delete sourcingrequirement
    where dest in (select loc from loc where u_area = 'NA');


LOOP

  delete res where type = 5 and res <> ' ' and rownum < 10000 and loc in (select loc from loc where u_area = 'NA');
    
  EXIT WHEN SQL%ROWCOUNT = 0;
  COMMIT;
END LOOP; 


LOOP

  delete sourcing where rownum < 10000 and dest in (select loc from loc where u_area = 'NA');
    
  EXIT WHEN SQL%ROWCOUNT = 0;
  COMMIT;
END LOOP; 


commit;

end;
