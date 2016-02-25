--------------------------------------------------------
--  DDL for Procedure U_99_SKU_TPM_FCST_ADJ
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_99_SKU_TPM_FCST_ADJ" as

begin

/******************************************************************
** Part 1: Create New DFUTOSKU TPM_REPLACE RECORDS.               * 
******************************************************************/
insert into igpmgr.intins_dfutoskufcst (integration_jobid, item, skuloc, dmdunit, dmdgroup, dfuloc, startdate, dur, type, totfcst, supersedesw, ff_trigger_control)

select 'U_12_SKU_TPM_FCST_ADJ_PART1'
       ,g.item, p.loc skuloc, g.item dmdunit, 'TPM_REPLACE' dmdgroup, p.loc dfuloc, p.startdate, 10800 dur, 1 type, round(p.tpm_fcst-g.gid_fcst, 1) new_fcst, 0 supersedesw, '' ff_trigger_control
from

    (select distinct startdate, loc, dmdgroup, sum(totfcst) tpm_fcst
    from

        (select f.startdate, t.loc, f.skuloc, f.item, f.dmdgroup, f.totfcst
        from  dfutoskufcst f, item i,
        
            (select distinct loc from tmp_tpm_fcst 
            ) t
        
        where t.loc = f.skuloc
        and f.item = i.item --and f.startdate = '27-SEP-15' and t.loc = 'USNE'
        and f.dmdgroup = 'TPM'
        )

    group by startdate, loc, dmdgroup
    ) p, 

    (select distinct startdate, loc, item, dmdgroup, sum(totfcst) gid_fcst
    from

        (select f.startdate, t.loc, f.skuloc, f.item, f.dmdgroup, f.totfcst
        from  tmp_tpm_fcst t, dfutoskufcst f, item i
        where t.gid = f.skuloc
        and f.item = i.item --and f.startdate = '27-SEP-15'
        and i.u_stock = 'A'
        and f.dmdgroup = 'COL'
        )

    group by startdate, loc, item, dmdgroup
    ) g

where p.loc = g.loc
and p.startdate = g.startdate;

commit;

/******************************************************************
** Part 2: Update and insert TPM_DELTE.
******************************************************************/
declare
  cursor cur_selected is
        select f.startdate, t.loc, f.skuloc, f.item, f.dmdgroup, f.totfcst
        from  dfutoskufcst f, item i,
                
            (select distinct loc from tmp_tpm_fcst 
            ) t
                
        where t.loc = f.skuloc
        and f.item = i.item 
        and f.dmdgroup = 'TPM'
   for update of f.dmdgroup;
begin
  for cur_record in cur_selected loop
  
    update dfutoskufcst
    set dmdgroup = 'TPM_DELETE'
    where current of cur_selected;
    
  end loop;
  commit;
end;

/******************************************************************
** Part 3: Delete the TPM_DELETE Marked Records. 
******************************************************************/
delete dfutoskufcst where dmdgroup = 'TPM_DELETE';

commit;

update dfutoskufcst set dmdgroup = 'TPM' where dmdgroup = 'TPM_REPLACE';

commit;

end;
