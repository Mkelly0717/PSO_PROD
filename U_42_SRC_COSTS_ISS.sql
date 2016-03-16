--------------------------------------------------------
--  DDL for View U_42_SRC_COSTS_ISS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."U_42_SRC_COSTS_ISS" ("ITEM", "MATCODE", "DEST", "DEST_DESCR", "DEST_CO", "DEST_PC", "DEST_GEO", "SOURCE", "LOC_TYPE", "SOURCE_DESCR", "SOURCE_CO", "SOURCE_PC", "SOURCE_GEO", "SOURCING", "DATA_SOURCE", "DISTANCE", "TRANSITTIME", "U_FREIGHT_FACTOR", "FREIGHT", "U_RATE_TYPE", "OH", "IH", "TOTAL_COST") AS 
  SELECT DISTINCT
          c.item,
          c.matcode,
          c.dest,
          c.dest_descr,
          c.dest_co,
          c.dest_pc,
          c.dest_geo,
          c.source,
          c.loc_type,
          c.source_descr,
          c.source_co,
          c.source_pc,
          c.source_geo,
          c.sourcing,
          c.data_source,
          c.distance,
          c.transittime,
          c.u_freight_factor,
          c.freight,
          c.u_rate_type,
          NVL (o.unit_cost, 0) oh,
          0 ih,
          ROUND ( ( (c.freight * c.u_freight_factor) + NVL (o.unit_cost, 0)),
                 4)
             total_cost
     FROM (SELECT DISTINCT
                  c.item,
                  c.matcode,
                  c.dest,
                  c.dest_descr,
                  c.dest_co,
                  c.dest_pc,
                  c.dest_geo,
                  c.source,
                  c.loc_type,
                  c.source_descr,
                  c.source_co,
                  c.source_pc,
                  c.source_geo,
                  c.sourcing,
                  c.u_freight_factor,
                  CASE
                     WHEN pc.cost_pallet IS NOT NULL THEN 'PC'
                     WHEN geo.cost_pallet IS NOT NULL THEN 'GEO'
                     ELSE 'CO'
                  END
                     data_source,
                  CASE
                     WHEN pc.cost_pallet IS NOT NULL THEN pc.cost_pallet
                     WHEN geo.cost_pallet IS NOT NULL THEN geo.cost_pallet
                     ELSE NVL (co.cost_pallet, 99)
                  END
                     freight,
                  CASE
                     WHEN pc.transittime IS NOT NULL THEN pc.transittime
                     WHEN geo.transittime IS NOT NULL THEN geo.transittime
                     ELSE NVL (co.transittime, 0)
                  END
                     transittime,
                  CASE
                     WHEN pc.distance IS NOT NULL THEN pc.distance
                     WHEN geo.distance IS NOT NULL THEN geo.distance
                     ELSE NVL (co.distance, 0)
                  END
                     distance,
                  CASE
                     WHEN pc.u_rate_type IS NOT NULL THEN pc.u_rate_type
                     WHEN geo.u_rate_type IS NOT NULL THEN geo.u_rate_type
                     ELSE co.u_rate_type
                  END
                     u_rate_type
             FROM (  SELECT DISTINCT source_pc,
                                     dest_pc,
                                     source_co,
                                     dest_co,
                                     MIN (distance) distance,
                                     MIN (cost_pallet) cost_pallet,
                                     MIN (transittime) transittime,
                                     MIN (u_rate_type) u_rate_type
                       FROM udt_cost_transit
                      WHERE     source_pc <> ' '
                            AND dest_pc <> ' '
                            AND direction IN ('Z1AA', 'ALL')
                   GROUP BY source_pc,
                            dest_pc,
                            source_co,
                            dest_co) pc,
                  (  SELECT DISTINCT source_geo,
                                     dest_geo,
                                     source_co,
                                     dest_co,
                                     MIN (distance) distance,
                                     MIN (cost_pallet) cost_pallet,
                                     MIN (transittime) transittime,
                                     MIN (u_rate_type) u_rate_type
                       FROM udt_cost_transit
                      WHERE     source_geo IS NOT NULL
                            AND dest_geo IS NOT NULL
                            AND direction IN ('Z1AA', 'ALL')
                   GROUP BY source_geo,
                            dest_geo,
                            source_co,
                            dest_co) geo,
                  (  SELECT DISTINCT source_co,
                                     dest_co,
                                     MIN (distance) distance,
                                     MIN (cost_pallet) cost_pallet,
                                     MIN (transittime) transittime,
                                     MIN (u_rate_type) u_rate_type
                       FROM udt_cost_transit
                      WHERE     direction IN ('Z1AA', 'ALL')
                            AND source_geo IS NULL
                            AND dest_geo IS NULL
                            AND source_pc = ' '
                            AND dest_pc = ' '
                   GROUP BY source_co, dest_co) co,
                  (SELECT DISTINCT c.item,
                                   i.u_materialcode matcode,
                                   c.dest,
                                   ld.descr dest_descr,
                                   ld.country dest_co,
                                   ld.postalcode dest_pc,
                                   ld.u_geocode dest_geo,
                                   c.source,
                                   ls.loc_type,
                                   ls.descr source_descr,
                                   ls.country source_co,
                                   ls.postalcode source_pc,
                                   ls.u_geocode source_geo,
                                   c.sourcing,
                                   i.u_freight_factor
                     FROM sourcing c,
                          loc ld,
                          loc ls,
                          item i
                    WHERE     c.dest = ld.loc
                          AND c.source = ls.loc
                          AND c.item = i.item
                          AND (SUBSTR (c.sourcing, 1, 3) = 'ISS'  or SUBSTR (c.sourcing, 1, 8) = 'REBALISS')) c
            WHERE     c.dest_pc = pc.dest_pc(+)
                  AND c.source_pc = pc.source_pc(+)
                  AND c.dest_co = pc.dest_co(+)
                  AND c.source_co = pc.source_co(+)
                  AND c.dest_geo = geo.dest_geo(+)
                  AND c.source_geo = geo.source_geo(+)
                  AND c.dest_co = geo.dest_co(+)
                  AND c.source_co = geo.source_co(+)
                  AND c.dest_co = co.dest_co(+)
                  AND c.source_co = co.source_co(+)) c,
          (SELECT loc,
                  matcode,
                  process,
                  unit_cost
             FROM udt_cost_unit
            WHERE process = 'HO'
                  AND loc IN (SELECT loc
                                FROM loc
                               WHERE loc_type IN (2, 4))) o
    WHERE c.source = o.loc(+) AND c.matcode = o.matcode(+)
