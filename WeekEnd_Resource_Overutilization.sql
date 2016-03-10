select rm.eff, rm.category, rm.res, round(rm.value,2) value, rc.qty, rc.category, rc.qtyuom
from sim_resmetric rm, resconstraint rc
where rm.simulation_name='AD'
and rm.res like '%INSCAP%'
and rm.eff between trunc(sysdate) + 2 and  trunc(sysdate)+3
and rm.category=402
and rm.value > 0
and rm.value > rc.qty
and rc.res=rm.res
and rc.eff=rm.eff
and rc.category in (12)
order by rm.eff asc