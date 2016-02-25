--------------------------------------------------------
--  DDL for View UDV_SKUCONSTR_SRC_MISSING
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_SKUCONSTR_SRC_MISSING" ("ITEM", "LOC", "TOTALDEMAND", "TOTALSRC", "LOC_TYPE", "POSTALCODE", "U_3DIGITZIP", "COUNTRY", "U_AREA", "U_MAX_SRC", "U_MAX_DIST", "ENABLESW", "VALID_POSTAL", "VALID_3ZIP", "IS_IN_GIDLIMITS_NA", "IS_MANDATORY_LOC", "IS_EXCLUSIVE_LOC", "IS_FORBIDDEN_LOC", "IS_LOC_VALID", "SKU_EXISTS", "IS_5DIGIT_LANE_EXISTS", "#_valid_5zip_lanes", "IS_3DIGIT_LANE_EXISTS", "#_valid_3zip_lanes", "IS_5ZIP_GT_MAX_DIST", "IS_3ZIP_GT_MAX_DIST", "IS_SKUEFF_IN_EFFECT") AS 
  SELECT item ,
    loc ,
    totaldemand ,
    totalsrc ,
    loc_type ,
    postalcode ,
    u_3digitzip ,
    country ,
    u_area ,
    u_max_src ,
    u_max_dist ,
    enablesw ,
    CASE is_5digit(postalcode)
      WHEN 1
      THEN 'Y'
      ELSE 'N'
    END valid_postal ,
    CASE is_3digit(u_3digitzip)
      WHEN 1
      THEN 'Y'
      ELSE 'N'
    END valid_3zip ,
    CASE is_in_gidlimits_na(loc)
      WHEN 1
      THEN 'Y'
      ELSE 'N'
    END is_in_gidlimits_na ,
    CASE is_mandatory_loc(loc)
      WHEN 1
      THEN 'Y'
      ELSE 'N'
    END is_mandatory_loc ,
    CASE is_exclusive_loc(loc)
      WHEN 1
      THEN 'Y'
      ELSE 'N'
    END is_exclusive_loc ,
    CASE is_forbidden_loc(loc)
      WHEN 1
      THEN 'Y'
      ELSE 'N'
    END is_forbidden_loc ,
    CASE is_loc_valid(loc)
      WHEN 1
      THEN 'Y'
      ELSE 'N'
    END is_loc_valid ,
    CASE v_sku_exists(loc, item)
      WHEN 1
      THEN 'Y'
      ELSE 'N'
    END sku_exists ,
    CASE is_5digit_lane_exists(loc)
      WHEN 1
      THEN 'Y'
      ELSE 'N'
    END is_5digit_lane_exists ,
    v_number_valid_5zip_lanes(loc) "#_valid_5zip_lanes" ,
    CASE is_3digit_lane_exists(loc)
      WHEN 1
      THEN 'Y'
      ELSE 'N'
    END is_3digit_lane_exists ,
    v_number_valid_3zip_lanes(loc) "#_valid_3zip_lanes" ,
    CASE is_5zip_gt_max_dist(loc)
      WHEN 1
      THEN 'Y'
      ELSE 'N'
    END is_5zip_gt_max_dist ,
    CASE is_3zip_gt_max_dist(loc)
      WHEN 1
      THEN 'Y'
      ELSE 'N'
    END is_3zip_gt_max_dist ,
    CASE is_skueff_in_effect(loc, item)
      WHEN 1
      THEN 'Y'
      ELSE 'N'
    END is_skueff_in_effect
  FROM udv_skuconstr_src_all
  WHERE totalsrc=0
  ORDER BY totaldemand DESC
