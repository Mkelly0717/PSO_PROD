/* Substract the qty from cat 6 */
with dels as (
select vll.item, vll.dest, vll.schedarrivdate, sum(vll.qty) qty
from vehicleloadline vll, loc l
where u_overallsts='C'
  and l.loc=vll.dest
  and l.u_area='NA'
  and l.loc_type=3
group by vll.item, vll.dest, vll.schedarrivdate
)
select d.item, d.dest, d.schedarrivdate, d.qty vll_qty, skc.qty skc_qty
from dels d, skuconstraint skc
where skc.loc=d.dest
and skc.item=d.item
and skc.eff=d.schedarrivdate
and skc.category=6;

/* delete Vehicleloads where status='C' and arrives after the custorder date. */
select s.item, s.loc, 6 category, trunc(s.startdate) startdate, round(s.adjfcstcustorders, 1)  qty
        from skuprojstatic s, item i, loc l
        where s.item = i.item
        and i.u_stock = 'C'
        and s.loc = l.loc
        and l.u_area = 'NA' 
        and l.loc_type = 3
        and trunc(s.startdate) <=  (select min(startdate)+14 from skuprojstatic);