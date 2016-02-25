--------------------------------------------------------
--  DDL for Procedure U_60_CREATE_PLANARRIV_EXTRACT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_60_CREATE_PLANARRIV_EXTRACT" as

begin

execute immediate 'truncate table scpomgr.udt_planarriv_extract';

execute immediate 'insert into udt_planarriv_extract
  ( 
    needshipdate ,
    sourcing ,
    sourcestatus ,
    u_rate_type ,
    dest ,
    item ,
    u_custorderid ,
    schedarrivdate ,
    source ,
    schedshipdate ,
    deststatus ,
    recnum ,
    firmsw ,
    needarrivdate ,
    qty ,
    loadid
  )
  (select needshipdate ,
      sourcing ,
      sourcestatus ,
      u_rate_type ,
      dest ,
      item ,
      u_custorderid ,
      schedarrivdate ,
      source ,
      schedshipdate ,
      deststatus ,
      recnum ,
      firmsw ,
      needarrivdate ,
      qty ,
      loadid
    from udv_planarriv_extract
  )';
  
commit;
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
and pi.recnum=po.recnum
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
and pi.u_custorderid = po.u_custorderid
and co.orderid=pi.u_custorderid
and pi.qty >= 0.8*co.qty
);

commit; 


/* Update the U_RATE_TYPE field in UDT_PLANARRIV_EXTRACT */
merge into udt_planarriv_extract peo
using
( select recnum, u_rate_type
  from ( select pe.recnum, ct.u_rate_type
  from udt_planarriv_extract pe, loc ld, loc ls,
       udt_sourcing_definitions sd   , udt_cost_transit_na ct
 where ld.loc            = pe.dest
   and ls.loc            = pe.source
   and ct.u_equipment_type = decode( ld.u_equipment_type, 'FB', 'FB', 'VN')
   and pe.sourcing    = sd.sourcing
   and( 
       ( sd.zip_type in( '5', 'NA' ) and ct.source_pc   = ls.postalcode and ct.dest_pc = ld.postalcode )
       or( sd.zip_type    = '3' and ct.source_geo  = ls.u_3digitzip and ct.dest_geo    = ld.u_3digitzip )
   ))
) ta on (ta.recnum = peo.recnum)
when matched then update 
    set peo.u_rate_type = ta.u_rate_type;
    
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
