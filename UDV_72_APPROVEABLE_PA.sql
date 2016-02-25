--------------------------------------------------------
--  DDL for View UDV_72_APPROVEABLE_PA
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_72_APPROVEABLE_PA" ("ITEM", "DEST", "SOURCE", "SOURCING", "U_CUSTORDERID", "FCSTADJRULE", "COD", "OHPOST", "LT", "SCHEDSHIPDATE", "SCHEDARRIVDATE", "QTY", "CO_AVG_QTY", "CO_CNT", "CO_QTY", "CHK_QTY", "CHK_INT", "CHK_LT", "CHK") AS 
  select item, dest, source, sourcing, u_custorderid, fcstadjrule, cod, ohpost, lt, schedshipdate, schedarrivdate, qty, co_avg_qty, co_cnt, co_qty, 
    chk_qty, chk_int, chk_lt, chk_qty+chk_int+chk_lt chk
from

    (select p.item, p.dest, p.source, p.sourcing, p.u_custorderid, s.fcstadjrule, s.custorderdur/1440 cod, sku.ohpost, cc.minleadtime/1440 lt, p.schedshipdate, p.schedarrivdate, round(p.qty, 1) qty, c.co_avg_qty, c.cnt co_cnt, c.qty co_qty, 
        case when p.qty <= c.qty then 1 else 0 end chk_qty,
        case when trunc(p.qty/c.co_avg_qty) =  p.qty/c.co_avg_qty then 1 else 0 end chk_int,
        case when p.schedarrivdate-p.schedshipdate =  (cc.minleadtime/1440) then 1 else 0 end chk_lt
    from planarriv p, skudemandparam s, sku sku, sourcing cc, loc l,

        (select distinct item, loc, shipdate, avg(qty) co_avg_qty, sum(qty) qty, count(*) cnt
        from custorder
        group by item, loc, shipdate
        ) c

    where p.dest = l.loc
    and l.u_area = 'NA'
    and l.loc_type = 3
    and p.item = s.item --and p.source = 'US86' 
    --and p.item = '4055RUPLUS'
    and p.dest = s.loc --and p.dest = '4000282703'   --  4000086109
    and p.schedshipdate between trunc(sysdate) and trunc(sysdate)+(s.custorderdur/1440-1) --and schedarrivdate = to_date('12/18/2015', 'MM/DD/YYYY')
    and p.u_custorderid is not null
    and s.fcstadjrule = 6
    and s.custorderdur <= 4320
    and p.item = c.item
    and p.dest = c.loc
    and p.schedarrivdate = c.shipdate
    and p.item = sku.item
    and p.dest = sku.loc
    and p.item = cc.item
    and p.dest = cc.dest
    and p.source = cc.source
    and p.sourcing = cc.sourcing
    )
    
--where chk_qty+chk_int+chk_lt >= 1
order by schedarrivdate
