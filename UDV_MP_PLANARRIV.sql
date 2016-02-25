--------------------------------------------------------
--  DDL for View UDV_MP_PLANARRIV
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_MP_PLANARRIV" ("ITEM", "DEST", "SOURCE", "SOURCE_PSO", "ORDERID", "SHIPDATE", "SCHEDSHIPDATE", "SOURCING", "QTY", "CHK_SHIP", "CHK_SOURCE", "CHK_QTY", "CHK_3", "CHK_P1SRC") AS 
  select m.item, m.dest, m.source, p.source source_pso, m.orderid, m.shipdate, p.schedshipdate, p.sourcing, p.qty,
        case when m.shipdate <> p.schedshipdate then 1 else 0 end chk_ship,
        case when m.source <> p.source then 1 else 0 end chk_source,
        case when p.qty not in (540, 570) then 1 else 0 end chk_qty,
        case when m.shipdate <> p.schedshipdate or m.source <> p.source or p.qty not in (540, 570) then 1 else 0 end chk_3,  
        case when c.item is null then 1 else 0 end chk_p1src
    from

        (select m.item, m.dest, m.source, m.shipdate, m.orderid
        from udt_mp_planarriv m, custorder c, loc l, item i
        where m.dest = l.loc
        and l.u_area = 'NA'
        and m.item = i.item
        and i.u_stock = 'C'
        and m.dest = c.loc 
        and m.item = c.item
        and m.arrivdate = c.shipdate
        and m.orderid = c.orderid
        ) m,

        (select m.item, m.dest, m.source, m.sourcing, m.u_custorderid orderid, m.schedshipdate, m.schedarrivdate, m.qty
        from planarriv m, loc l, item i
        where m.dest = l.loc
        and l.u_area = 'NA'
        and m.item = i.item
        and i.u_stock = 'C'
        and m.u_custorderid is not null
        and schedshipdate between trunc(sysdate) and trunc(sysdate)+13
        ) p,
        
        (select distinct item, dest, source
        from sourcing 
        ) c
        
    where m.item = p.item(+)
    and m.dest = p.dest(+)
    and m.orderid = p.orderid(+)
    and m.item = c.item(+)
    and m.dest = c.dest(+)
    and m.source = c.source(+)
    and p.item is not null
