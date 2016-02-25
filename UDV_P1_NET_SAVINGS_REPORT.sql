--------------------------------------------------------
--  DDL for View UDV_P1_NET_SAVINGS_REPORT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_P1_NET_SAVINGS_REPORT" ("TOTAL_LOSSES", "TOTAL_SAVINGS", "TOTAL_NET", "PERCENT_SAVED") AS 
  with losses as
    ( select sum(loss) loss from udv_p1_report_sm1_gt_p1
    )
  , savings as
    ( select sum(savings) saving from udv_p1_report_sm1_lt_p1
    )
select round(loss) total_losses
  , round(saving) total_savings
  , round(saving+loss) total_net
  , round(saving/(saving+loss) *100) percent_saved
from losses
  , savings
