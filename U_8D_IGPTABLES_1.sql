--------------------------------------------------------
--  DDL for Procedure U_8D_IGPTABLES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_8D_IGPTABLES" as

begin

execute immediate 'truncate table igpmgr.interr_bom';

execute immediate 'truncate table igpmgr.interr_cal';

execute immediate 'truncate table igpmgr.interr_caldata';

execute immediate 'truncate table igpmgr.interr_cost';

execute immediate 'truncate table igpmgr.interr_costtier';

execute immediate 'truncate table igpmgr.interr_prodmethod';

execute immediate 'truncate table igpmgr.interr_productionstep';

execute immediate 'truncate table igpmgr.interr_prodyield';

execute immediate 'truncate table igpmgr.interr_res';

execute immediate 'truncate table igpmgr.interr_resconstraint';

execute immediate 'truncate table igpmgr.interr_rescost';

execute immediate 'truncate table igpmgr.interr_respenalty';

execute immediate 'truncate table igpmgr.interr_sku';

execute immediate 'truncate table igpmgr.interr_skudemandparam';

execute immediate 'truncate table igpmgr.interr_skudeployparam';

execute immediate 'truncate table igpmgr.interr_skussparam';

execute immediate 'truncate table igpmgr.interr_skuplannparam';

execute immediate 'truncate table igpmgr.interr_skupenalty';

execute immediate 'truncate table igpmgr.interr_sourcing';

execute immediate 'truncate table igpmgr.interr_sim_sourcingmetric';

execute immediate 'truncate table igpmgr.interr_storagereq';

/* reset BOM Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in (  'intins_sim_BOM'
                               ,'intupd_sim_BOM'
                               ,'intups_sim_BOM')
      and (    ij.jobid='INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or ij.jobid like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
           ); 
commit;

/* reset Cal Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in (  'intins_sim_CAL'
                               ,'intupd_sim_CAL'
                               ,'intups_sim_CAL'
                              )
      and (    IJ.JOBID='INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or ij.jobid like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
           ); 
commit;

/* reset Caldata Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in (  'intins_sim_CALDATA'
                               ,'intupd_sim_CALDATA'
                               ,'intups_sim_CALDATA'
                              )
      and (    ij.jobid='INT_JOB' 
            or IJ.JOBID like 'U_10_SKU_BASE_%'
            or IJ.JOBID like 'U_11_SKU_STORAGE_%'
            or ij.jobid like 'U_15_SKU_WEEKLY_%'
            or ij.jobid like 'U_20_PRD_BUY_%'
            or ij.jobid like 'U_22_PRD_INSPECT_%'
            or ij.jobid like 'U_23_PRD_REPAIR_%'
            or ij.jobid like 'U_25_PRD_HEAT_%'
            or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
            or ij.jobid like 'U_30_SRC_DAILY_%'
           ); 
commit;

/* reset Cost Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in (  'intins_sim_COST'
                               ,'intupd_sim_COST'
                               ,'intupd_sim_COST'
                             )
      and (    ij.jobid='INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or ij.jobid like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
           ); 
commit;

/* reset Costier Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in ('intins_sim_COSTTIER','intins_sim_COSTTIER')
      and (    ij.jobid='INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
           ); 
commit;


/* reset DFUTOSKUFCST Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in (  'intins_sim_DFUTOSKUFCST'
                               ,'intupd_sim_DFUTOSKUFCST'
                               ,'intups_sim_DFUTOSKUFCST'
                              )
      and (    ij.jobid='INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or ij.jobid like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
           ); 
commit;

/* reset PRODMETHOD Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in (  'intins_sim_PRODMETHOD'
                               ,'intupd_sim_PRODMETHOD'
                               ,'intups_sim_PRODMETHOD'
                              )
     and ( ij.jobid = 'INT_JOB'
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or ij.jobid like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
          );
commit;

/* reset PRODSTEP Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in (  'intins_sim_PRODUCTIONSTEP'
                               ,'intupd_sim_PRODUCTIONSTEP'
                               ,'intups_sim_PRODUCTIONSTEP'
                              )
     and ( IJ.JOBID = 'INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or IJ.JOBID like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
          );
commit;

/* reset PROD YIELD Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in (  'intins_sim_PRODYIELD'
                               ,'intupd_sim_PRODYIELD'
                               ,'intups_sim_PRODYIELD'
                              )
     and ( IJ.JOBID = 'INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or ij.jobid like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
          );
commit;

/* reset RES Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in ('intins_sim_RES','intins_sim_RES')
     and ( ij.jobid = 'INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or ij.jobid like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
          );
commit;

/* reset RES CONSTRAINT Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in ('intins_sim_RESCONSTRAINT','intins_sim_RESCONSTRAINT')
     and ( ij.jobid = 'INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or ij.jobid like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
          );
commit;

/* reset RESCOST Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in ('intins_sim_RESCOST','intins_sim_RESCOST')
     and ( ij.jobid = 'INT_JOB'
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or ij.jobid like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
          );
commit;


/* reset RES PENALATY Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in ('intins_sim_RESPENALTY','intins_sim_RESPENALTY')
     and ( ij.jobid = 'INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or ij.jobid like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
          );
commit;

/* reset SKU Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in ('intins_sim_SKU','intins_sim_SKU')
      and (    ij.jobid='INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or ij.jobid like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
           ); 
commit;


/* reset SKU CONSTRAINT Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in ('intins_sim_SKUCONSTRAINT','intins_sim_SKUCONSTRAINT')
      and (    ij.jobid='INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or IJ.JOBID like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
           ); 
commit;

/* reset SKU Demand Param Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in ('intins_sim_SKUDEMANDPARAM','intins_sim_SKUDEMANDPARAM')
      and (    ij.jobid='INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or ij.jobid like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
           ); 
commit;

/* reset SKU Deployment Param Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in ('intins_sim_SKUDEPLOYPARAM','intins_sim_SKUDEPLOYPARAM')
      and (    ij.jobid='INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or ij.jobid like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
           ); 
commit;

/* reset SKU PENALTY Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in ('intins_sim_SKUPENALTY','intins_sim_SKUPENALTY')
      and (    ij.jobid='INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or IJ.JOBID like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
           ); 
commit;

/* reset SKU PLanning Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in ('intins_sim_SKUPLANNPARAM','INTUPSKU_SKUPLANPARAM')
      and (    ij.jobid='INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or IJ.JOBID like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
           ); 
commit;

/* reset SKU Saftey Stock Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in ('intins_sim_SKUSSPARAM','INTUPSKU_SKUSSPARAM')
      and (    ij.jobid='INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or IJ.JOBID like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
           ); 
commit;

/* reset Sourcing Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in ('intins_sim_SOURCING','intins_sim_SOURCING','intins_sim_SOURCING')
     and ( ij.jobid = 'INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or IJ.JOBID like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
          );
commit;

/* reset Sourcing Metric Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in (  'intins_sim_SOURCINGMETRIC'
                               ,'intupd_sim_SOURCINGMETRIC'
                               ,'intups_sim_SOURCINGMETRIC'
                              )
     and ( ij.jobid = 'INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or IJ.JOBID like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
          );
commit;

/* reset Storage Requirement Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in (  'intins_sim_STORAGEREQ'
                               ,'intupd_sim_STORAGEREQ'
                               ,'intups_sim_STORAGEREQ'
                              )
     and ( ij.jobid = 'INT_JOB' 
           or IJ.JOBID like 'U_10_SKU_BASE_%'
           or IJ.JOBID like 'U_11_SKU_STORAGE_%'
           or ij.jobid like 'U_15_SKU_WEEKLY_%'
           or ij.jobid like 'U_20_PRD_BUY_%'
           or ij.jobid like 'U_22_PRD_INSPECT_%'
           or IJ.JOBID like 'U_23_PRD_REPAIR_%'
           or ij.jobid like 'U_25_PRD_HEAT_%'
           or IJ.JOBID like 'U_29_PRD_RESCONSTR_%'
           or ij.jobid like 'U_30_SRC_DAILY_%'
          );
commit;

end;
