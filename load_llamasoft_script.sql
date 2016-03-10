update udt_llamasoft_data_temp
set item=replace(replace(item,'-',''),' ','')
;
commit;
update udt_llamasoft_data_temp
set item=replace(item,'04055','4055')
;
commit;
update udt_llamasoft_data_temp
set item=replace(item,'04001','4001')
;
commit;


merge into udt_llamasoft_data mt using
(select item, source       , source_pc, dest
, dest_pc   , transleadtime, priority , u_equipment_type
   from udt_llamasoft_data_temp t
  where exists
  (select 1
     from loc ls, loc ld, item i
    where ls.loc = t.dest and ld.loc = t.source and i.item = t.item
  )
) ss on( mt.item = ss.item and mt.source = ss.source and mt.dest = ss.dest and mt.u_equipment_type=ss.u_equipment_type )
when not matched then
   insert
    (
      mt.item   , mt.source       , mt.source_pc, mt.dest
    , mt.dest_pc, mt.transleadtime, mt.priority , mt.u_equipment_type
    )
    values
    (
      ss.item   , ss.source       , ss.source_pc, ss.dest
    , ss.dest_pc, ss.transleadtime, ss.priority , ss.u_equipment_type
    ) ;



/* Find destination locations which do not exists in the loc table */
select *
from udt_llamasoft_data_temp ls
where not exists ( select 1 
                     from loc l
                    where l.loc=ls.dest);