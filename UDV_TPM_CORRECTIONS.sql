--------------------------------------------------------
--  DDL for View UDV_TPM_CORRECTIONS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_TPM_CORRECTIONS" ("ITEM", "LOC", "EFF", "QTY") AS 
  SELECT s.item item,
            s.dest loc,
            skc.eff eff,
            SUM (fc.percen * skc.qty) AS qty
       FROM sourcing s,
            udt_fixed_coll fc,
            skuconstraint skc,
            loc l
      WHERE     s.sourcing LIKE '%COL%'
            AND s.source = fc.loc
            --    and fc.plant='USZR'
            AND s.dest = fc.plant
            AND s.source = skc.loc
            AND s.item = skc.item
            AND l.loc = s.dest
            AND l.loc_type IN ('2', '4')
            AND l.u_area = 'NA'
            AND l.enablesw = 1
            AND skc.qty > 0
            AND skc.category = 10
   GROUP BY s.item, s.dest, skc.eff
   ORDER BY s.item, s.dest ASC, eff
