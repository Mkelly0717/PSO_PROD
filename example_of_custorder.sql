select *
from sim_sourcingmetric sm
where sm.simulation_name='AD'
and sm.dest='4000053676'
and sm.value > 0
and sm.item='4055RUPLUS'
and sm.eff=trunc(sysdate)+1
and category=418
order by sm.eff asc

