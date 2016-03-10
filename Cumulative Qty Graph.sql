select
   qty Order_Qty, sum(qty) as sum_qty_at_ord_qty,
   SUM(SUM(qty)) OVER
    (order by qty rows between unbounded preceding and current row)
    as cumulative_qty
  ,   round(sum(sum(qty)) over
    (order by qty rows between unbounded preceding and current row)/7677998*100,4)
    as cumulative_percent
from custorder co
where u_ship_condition='Z2' and u_dmdgroup_code='ISS' and u_sales_document='Z1AA'
and item like '4%' --and shipdate between trunc(sysdate)  and trunc(sysdate) + 7
  GROUP BY qty
  order by qty;
