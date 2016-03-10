--------------------------------------------------------
--  DDL for Procedure U_8D_IGPTABLES_OLD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_8D_IGPTABLES_OLD" as

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

execute immediate 'truncate table igpmgr.interr_sourcingmetric';

execute immediate 'truncate table igpmgr.interr_storagereq';

/* reset BOM Records */
update igpmgr.intjobs ij
   set insertct=0,
       updatect=0,
       totalrowsct=0
   where ij.int_tablename in (  'INTINS_BOM'
                               ,'INTUPD_BOM'
                               ,'INTUPS_BOM')
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
   where ij.int_tablename in (  'INTINS_CAL'
                               ,'INTUPD_CAL'
                               ,'INTUPS_CAL'
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
   where ij.int_tablename in (  'INTINS_CALDATA'
                               ,'INTUPD_CALDATA'
                               ,'INTUPS_CALDATA'
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
   where ij.int_tablename in (  'INTINS_COST'
                               ,'INTUPD_COST'
                               ,'INTUPS_COST'
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
   where ij.int_tablename in ('INTINS_COSTTIER','INTUPS_COSTTIER')
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
   where ij.int_tablename in (  'INTINS_DFUTOSKUFCST'
                               ,'INTUPD_DFUTOSKUFCST'
                               ,'INTUPS_DFUTOSKUFCST'
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
   where ij.int_tablename in (  'INTINS_PRODMETHOD'
                               ,'INTUPD_PRODMETHOD'
                               ,'INTUPS_PRODMETHOD'
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
   where ij.int_tablename in (  'INTINS_PRODUCTIONSTEP'
                               ,'INTUPS_PRODUCTIONSTEP'
                               ,'INTUPS_PRODUCTIONSTEP'
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
   where ij.int_tablename in (  'INTINS_PRODYIELD'
                               ,'INTUPS_PRODYIELD'
                               ,'INTUPD_PRODYIELD'
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
   where ij.int_tablename in ('INTINS_RES','INTUPS_RES')
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
   where ij.int_tablename in ('INTINS_RESCONSTRAINT','INTUPS_RESCONSTRAINT')
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
   where ij.int_tablename in ('INTINS_RESCOST','INTUPS_RESCOST')
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
   where ij.int_tablename in ('INTINS_RESPENALTY','INTUPS_RESPENALTY')
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
   where ij.int_tablename in ('INTINS_SKU','INTUPS_SKU')
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
   where ij.int_tablename in ('INTINS_SKUCONSTRAINT','INTUPS_SKUCONSTRAINT')
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
   where ij.int_tablename in ('INTINS_SKUDEMANDPARAM','INTUPS_SKUDEMANDPARAM')
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
   where ij.int_tablename in ('INTINS_SKUDEPLOYPARAM','INTUPS_SKUDEPLOYPARAM')
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
   where ij.int_tablename in ('INTINS_SKUPENALTY','INTUPS_SKUPENALTY')
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
   where ij.int_tablename in ('INTINS_SKUPLANNPARAM','INTUPSKU_SKUPLANPARAM')
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
   where ij.int_tablename in ('INTINS_SKUSSPARAM','INTUPSKU_SKUSSPARAM')
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
   where ij.int_tablename in ('INTINS_SOURCING','INTUPD_SOURCING','INTUPS_SOURCING')
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
   where ij.int_tablename in (  'INTINS_SOURCINGMETRIC'
                               ,'INTUPD_SOURCINGMETRIC'
                               ,'INTUPS_SOURCINGMETRIC'
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
   where ij.int_tablename in (  'INTINS_STORAGEREQ'
                               ,'INTUPD_STORAGEREQ'
                               ,'INTUPS_STORAGEREQ'
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
