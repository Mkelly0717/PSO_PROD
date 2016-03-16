/* Update the Vehicleloadline.schedshipdate to the leadtime from udt_cost_transit_na */
merge into vehicleloadline vll0
using
(select vll.loadid 
     , case when v_transitleadtime(vll.source, vll.dest)< 1 then 0
            else round(v_transitleadtime(vll.source, vll.dest))*1440
     end transittime
   from vehicleloadline vll, loc ld
  where vll.item like '4%'
   and ld.loc            = vll.dest
   and ld.u_area='NA'
) ta on (ta.loadid = vll0.loadid)
when matched then update 
    set vll0.schedshipdate = vll0.schedarrivdate - ta.transittime;