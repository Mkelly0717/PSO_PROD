--------------------------------------------------------
--  DDL for Procedure U_100_IGPERROR_HIST_TABLE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_100_IGPERROR_HIST_TABLE" 
is 
   v_bom number;
   v_cal number;
   v_caldata number;
   v_cost number;
   v_costtier number;
   v_custorder number;
   v_loc number;
   v_prodmethod number;
   v_productionstep number;
   v_prodyield number;
   v_res number;
   v_resconstraint number;
   v_rescost number;
   v_respenalty number;
   v_sku number;
   v_skudemandparam number;
   v_skudeployparam number;
   v_skupenalty number;
   v_skuplannparam number;
   v_skussparam number;
   v_sourcing number;
   v_sourcingmetric number;
   v_storagereq number;
   v_vehicleloadln number;
   v_date date := sysdate;
begin
  select count(1) into  v_bom from  igpmgr.interr_bom;
  select count(1) into  v_cal from  igpmgr.interr_cal;
  select count(1) into  v_caldata from  igpmgr.interr_caldata;
  select count(1) into  v_cost from  igpmgr.interr_cost;
  select count(1) into  v_costtier from  igpmgr.interr_costtier;
  select count(1) into  v_custorder from  igpmgr.interr_custorder;
  select count(1) into  v_loc from  igpmgr.interr_loc;  
  select count(1) into  v_prodmethod from  igpmgr.interr_prodmethod;
  select count(1) into  v_productionstep  from igpmgr.interr_productionstep;
  select count(1) into  v_prodyield from igpmgr.interr_prodyield;
  select count(1) into  v_res from igpmgr.interr_res;
  select count(1) into  v_resconstraint from  igpmgr.interr_resconstraint;
  select count(1) into  v_rescost from  igpmgr.interr_rescost;
  select count(1) into  v_respenalty from  igpmgr.interr_respenalty;
  select count(1) into  v_sku from  igpmgr.interr_sku;
  select count(1) into  v_skudemandparam from  igpmgr.interr_skudemandparam;
  select count(1) into  v_skudeployparam from  igpmgr.interr_skudeployparam;
  select count(1) into  v_skussparam from  igpmgr.interr_skussparam;
  select count(1) into  v_skuplannparam from  igpmgr.interr_skuplannparam;
  select count(1) into  v_skupenalty from igpmgr.interr_skupenalty;
  select count(1) into  v_sourcing from  igpmgr.interr_sourcing;
  select count(1) into  v_sourcingmetric from  igpmgr.interr_sim_sourcingmetric;
  select count(1) into  v_storagereq from  igpmgr.interr_storagereq;
  select count(1) into  v_vehicleloadln from  igpmgr.interr_vehicleloadln;
   
   insert into udt_igperror_hist 
   (run_date
   ,bom
   ,cal
   ,caldata
   ,cost
   ,costtier
   ,custorder
   ,loc
   ,prodmethod
   ,productionstep
   ,prodyield
   ,res
   ,resconstraint
   ,rescost
   ,respenalty
   ,sku
   ,skudemandparam
   ,skudeployparam
   ,skupenalty
   ,skuplannparam
   ,skussparam
   ,sourcing
   ,sourcingmetric
   ,storagereq
   ,VEHICLELOADLINE
   )
   values ( v_date
   ,v_bom 
   ,v_cal
   ,v_caldata
   ,v_cost
   ,v_costtier
   ,v_custorder
   ,v_loc
   ,v_prodmethod
   ,v_productionstep
   ,v_prodyield
   ,v_res
   ,v_resconstraint
   ,v_rescost
   ,v_respenalty
   ,v_sku
   ,v_skudemandparam
   ,v_skudeployparam
   ,v_skupenalty
   ,v_skuplannparam
   ,v_skussparam
   ,v_sourcing
   ,v_sourcingmetric
   ,v_storagereq
   ,v_vehicleloadln
   );
   
   commit;
end;
