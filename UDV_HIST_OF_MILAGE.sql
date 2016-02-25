--------------------------------------------------------
--  DDL for View UDV_HIST_OF_MILAGE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_HIST_OF_MILAGE" ("Milage Group", "MIN_DT", "MAX_DT", "MIN_DIST", "MAX_DIST", "LOADS", "AVG_DIST") AS 
  select
    case to_char( width_bucket( ct.distance, 0, 1000, 20 ) )
      when '1'
      then '000-049'
      when '2'
      then '050-099'
      when '3'
      then '100-149'
      when '4'
      then '150-199'
      when '5'
      then '200-249'
      when '6'
      then '250-299'
      when '7'
      then '300-349'
      when '8'
      then '350-399'
      when '9'
      then '400-449'
      when '10'
      then '450-499'
      when '11'
      then '500-549'
      when '12'
      then '550-599'
      when '13'
      then '600-649'
      when '14'
      then '650-699'
      when '15'
      then '700-749'
      when '16'
      then '750-799'
      when '17'
      then '800-849'
      when '18'
      then '900-949'
      when '19'
      then '950-999'
      when '20'
      then '1000-1049'
      when '21'
      then '1051-1100'
      when '22'
      then '1050-1099'
      else to_char( width_bucket( ct.distance, 0, 1000, 20 ) )
    end "Milaget Group", min( pe.schedshipdate ) min_dt, max( pe.schedshipdate
    ) max_dt           , min( ct.distance ) min_dist   , max( ct.distance )
    max_dist           , count( 1 ) loads              , round( avg(
    ct.distance ) ) avg_dist
     from udt_planarriv_extract pe, loc ls, loc ld, udt_cost_transit_na ct
    where pe.firmsw         = 1
    and ls.loc              = pe.source
    and ld.loc              = pe.dest
    and ls.u_area           = 'NA'
    and ld.u_area           = 'NA'
    and ct.source_pc        = ls.postalcode
    and ct.dest_pc          = ld.postalcode
    and ct.u_equipment_type = decode( ld.u_equipment_type, 'FB', 'FB', 'VN' )
    and pe.schedshipdate   <= trunc( sysdate ) + 3
 group by width_bucket( ct.distance, 0, 1000, 20 )
 order by 1 asc
