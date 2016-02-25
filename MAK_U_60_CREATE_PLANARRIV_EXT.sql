--------------------------------------------------------
--  DDL for Procedure MAK_U_60_CREATE_PLANARRIV_EXT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."MAK_U_60_CREATE_PLANARRIV_EXT" as

begin

execute immediate 'drop table scpomgr.udt_planarriv_extract';


execute immediate 'create table scpomgr.udt_planarriv_extract 
                      as select * from udv_planarriv_extract';

/* Firm PLanned Arrivals Where qty >= 80% of the order qty */
update scpomgr.udt_planarriv_extract po
set firmsw=1
where exists (
select u_custorderid
FROM udt_planarriv_extract pi, custorder co
WHERE pi.u_custorderid IS NOT NULL
and PI.LOADID          is null
AND pi.schedshipdate   <= TRUNC(sysdate) +5 and pi.schedshipdate >= TRUNC(sysdate) -2 
AND ( pi.sourcing LIKE 'ISS%')
AND pi.sourcing NOT LIKE '%DEL%'
and pi.u_custorderid = po.u_custorderid
and co.orderid=pi.u_custorderid
and pi.qty >= 0.8*co.qty
);

/* Firm PLanned Deliveries as 2's Where qty >= 80% of the order qty 
   -- Added 01-20-2016
*/
update scpomgr.udt_planarriv_extract po
set firmsw=2
where exists (
select u_custorderid
FROM udt_planarriv_extract pi, custorder co
where pi.u_custorderid is not null
and PI.LOADID          is not null
AND pi.schedshipdate   <= TRUNC(sysdate) +5 and pi.schedshipdate >= TRUNC(sysdate) -2 
AND ( pi.sourcing LIKE 'ISS%')
AND pi.sourcing LIKE '%DEL%'
and pi.u_custorderid = po.u_custorderid
and co.orderid=pi.u_custorderid
and pi.qty >= 0.8*co.qty
);

commit; 

/* Update the U_RATE_TYPE field in UDT_PLANARRIV_EXTRACT 
  NOTE!!!!! This is very inefficient and needs to be improved
*/
update udt_planarriv_extract peo
set peo.u_rate_type =   (SELECT ct.U_rate_type
  FROM udt_planarriv_extract pe,
    loc ld,
    loc ls,
    udt_sourcing_definitions sd,
    udt_cost_transit_na ct
  WHERE ld.loc           =pe.dest
  AND ls.loc             =pe.source
  AND ct.u_equipment_type=DECODE(ld.u_equipment_type,'FB','FB','VN')
  AND pe.sourcing        =sd.sourcing
  AND ( ( sd.zip_type   IN ('5','NA')
  AND ct.source_pc       =ls.postalcode
  AND ct.dest_pc         =ld.postalcode )
  OR ( sd.zip_type       ='3'
  AND ct.source_geo      =ls.u_3digitzip
  AND ct.dest_geo        =ld.u_3digitzip ) )
  and pe.recnum=peo.recnum
)
where exists 
  (SELECT ct.U_rate_type
  FROM udt_planarriv_extract pe,
    loc ld,
    loc ls,
    udt_sourcing_definitions sd,
    udt_cost_transit_na ct
  WHERE ld.loc           =pe.dest
  AND ls.loc             =pe.source
  AND ct.u_equipment_type=DECODE(ld.u_equipment_type,'FB','FB','VN')
  AND pe.sourcing        =sd.sourcing
  AND ( ( sd.zip_type   IN ('5','NA')
  AND ct.source_pc       =ls.postalcode
  AND ct.dest_pc         =ld.postalcode )
  OR ( sd.zip_type       ='3'
  AND ct.source_geo      =ls.u_3digitzip
  AND ct.dest_geo        =ld.u_3digitzip ) )
  );
commit;

commit;



/* Now Set the FIRMPLANSW in the PLANARRIV table for the ones we set in UDT_PLANARRIV_EXTRACT */
--update planarriv pa
--set firmplansw=1
--where exists (
--select *
--from udt_planarriv_extract pe
--where pa.u_custorderid=pe.u_custorderid
--and pa.qty=pe.qty
--and pe.firmsw=1
--and pa.sourcing=pe.sourcing
--);

Commit;


end;
