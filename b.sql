select vll.loadid 
     , case when v_transitleadtime(vll.source, vll.dest)< 1 then 0
            else round(v_transitleadtime(vll.source, vll.dest))*1440
     end transittime
   from vehicleloadline vll, loc ld
  where vll.item like '4%'
   and ld.loc            = vll.dest
   and ld.u_area='NA'
