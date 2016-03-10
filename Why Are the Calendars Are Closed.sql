select sm.*, src.sourcing, src.minleadtime, minleadtime/1440
from sim_sourcingmetric sm, sourcing src
where sm.simulation_name='AD'
 and category='417'
 and sm.item like '4055RU%'
 and trim(to_char(sm.eff,'Day'))in ('Saturday', 'Sunday')
 and src.item=sm.item
 and src.dest=sm.dest
 and src.source=sm.source
 and src.sourcing=sm.sourcing
 and src.minleadtime/1440 > 0
 and sm.value > 0 and sm.dest='6101018678' and sm.item='4055RUPLUS' and sm.source='UT1F'
 order by sm.eff asc