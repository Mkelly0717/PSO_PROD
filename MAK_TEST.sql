--------------------------------------------------------
--  DDL for View MAK_TEST
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_TEST" ("RUNDATE", "U_CUSTORDERID", "LOADID", "QTY", "SCHEDSHIPDATE", "PLANNDAY", "000-049", "050-099", "100-149", "150-199", "200-249", "250-299", "300-349", "350-399", "400-449", "450-499", "500+") AS 
  select trunc( sysdate ) rundate                                            , pe.u_custorderid, pe.loadid, pe.qty,
    pe.schedshipdate                                                          ,( pe.schedshipdate - trunc( sysdate ) )
    plannday                                                                  , decode( to_char( width_bucket( ct.distance,
    0, 1000, 20 ) ), '1', 1, 0 ) "000-049"                                    , decode( to_char( width_bucket(
    ct.distance, 0, 1000, 20 ) ), '2', 1, 0 ) "050-099"                       , decode( to_char(
    width_bucket( ct.distance, 0, 1000, 20 ) ), '3', 1, 0 ) "100-149"         , decode(
    to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '4', 1, 0 ) "150-199",
    decode( to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '5', 1, 0 )
    "200-249"                                                         , decode( to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '6'
    , 1, 0 ) "250-299"                                                , decode( to_char( width_bucket( ct.distance, 0, 1000, 20
    ) ), '7', 1, 0 ) "300-349"                                        , decode( to_char( width_bucket( ct.distance, 0,
    1000, 20 ) ), '8', 1, 0 ) "350-399"                               , decode( to_char( width_bucket(
    ct.distance, 0, 1000, 20 ) ), '9', 1, 0 ) "400-449"               , decode( to_char(
    width_bucket( ct.distance, 0, 1000, 20 ) ), '10', 1, 0 ) "450-499", decode(
    to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '11', 1, 0 ) "500+"
     from udt_planarriv_extract pe, loc ls, loc ld, udt_cost_transit_na ct
    where pe.firmsw        in( 1 )
    and ls.loc              = pe.source
    and ld.loc              = pe.dest
    and ls.u_area           = 'NA'
    and ld.u_area           = 'NA'
    and ct.source_pc        = ls.postalcode
    and ct.dest_pc          = ld.postalcode
    and ct.u_equipment_type = decode( ld.u_equipment_type, 'FB', 'FB', 'VN' )
    and pe.schedshipdate   <= trunc( sysdate ) + 3
    ---------------------------
    ----------------------------
 order by 1, 2 asc
