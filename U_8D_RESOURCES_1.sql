--------------------------------------------------------
--  DDL for Procedure U_8D_RESOURCES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_8D_RESOURCES" as

begin

delete res where res in  

    (select r.res
    from res r, sourcingrequirement t
    where r.subtype = 6
    and r.res = t.res(+)
    and t.res is null);

commit;

delete res where res in  

    (select r.res
    from res r, productionstep t
    where r.subtype = 1
    and r.res = t.res(+)
    and t.res is null);
    
commit;

delete res where res in  

    (select r.res
    from res r, storagerequirement t
    where r.subtype = 5
    and r.res = t.res(+)
    and t.res is null);
    
commit;

end;
