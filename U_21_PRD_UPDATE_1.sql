--------------------------------------------------------
--  DDL for Procedure U_21_PRD_UPDATE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_21_PRD_UPDATE" as

begin

/*
updated .csv files for tmp_yieldrates, tmp_yieldminmax and tmp_costs are first and then this procedure is executed to populate tmp_yield which is used by following procedures u_22_prd_inspect and u_23_prd_repair

the first insert statement creates needed records while the following cursor updates existing records  
*/

insert into tmp_yield (loc, matcode, qb, item, pc_util, hrsperday, buycost, inspcosthr, repcosthr, pscosthr, hi_volinsp, hi_volrepair, perceninsp, percenrepair, placeholder)

select distinct u.plant loc, u.matcode, u.qb, u.matcode||u.qb item, c.pc_util, c.hrsperday, c.buycost, c.inspcosthr, c.repcosthr, c.pscosthr, 
    nvl(r.hi_volinsp, 0) hi_volinsp, nvl(r.hi_volrepair, 0) hi_volrepair, nvl(u.perceninsp, 0) perceninsp, nvl(u.percenrepair, 0) percenrepair, u.placeholder  
from tmp_yield t, tmp_costs c,

    (select distinct plant, matcode, qb, 
        max(case when productionmethod = 'INS' then yield end) perceninsp, 
        max(case when productionmethod = 'REP' then yield end) percenrepair, 1 placeholder
    from
        (select u.plant, u.matcode, t.sup_qb qb, 
                        case when u.productionmethod = '1' then 'INS' else 'REP' end productionmethod, u.yield 
        from tmp_qb t, 

            (select n.plant, substr(n.material, -5) matcode, n.batch, n.productionmethod, round(n.n/d.d, 4) yield 
            from

                (select distinct plant, material, batch, substr(purchorder, 1, 1) productionmethod, sum(quantity) n
                from                             
                    (select plant, material, mvt,  
                                case when batch in ('AD', 'AP', 'AW') then 'AR' else batch end batch, purchorder, quantity
                     from tmp_yieldrate)
                where mvt in ('531', '532')
                and substr(purchorder, 1, 1) in ('1', '2')  
                group by plant, material, substr(purchorder, 1, 1), batch) n, 
                
                (select plant, material, productionmethod, d
                from
                    (select distinct plant, material, substr(purchorder, 1, 1) productionmethod, sum(abs(quantity)) d
                    from tmp_yieldrate
                    where mvt in ('531', '532')
                    and substr(purchorder, 1, 1) in ('1', '2')  
                    group by plant, material, substr(purchorder, 1, 1))) d

            where n.plant = d.plant
            and n.material = d.material
            and n.productionmethod = d.productionmethod) u
            
        where t.dmd_qb = u.batch
        and t.sup_qb is not null
        and u.yield > 0 
        and u.productionmethod||t.sup_qb <> '1AI') 

    group by plant, matcode, qb) u,
    
    (select distinct plant, 
        max(case when productionmethod = 'INS' then qtymax end) hi_volinsp,   
        max(case when productionmethod = 'REP' then qtymax end) hi_volrepair
    from
        (select distinct plant, activitycat, productionmethod,   
            max(case when rnkmin = 3 then qty end) qtymin, 
            max(case when rnkmax = 3 then qty end) qtymax
        from
            (select distinct week, plant, activitycat, productionmethod, qty, 
                dense_rank() over (partition by plant, activitycat order by qty asc) rnkmin,
                dense_rank() over (partition by plant, activitycat order by qty desc) rnkmax
            from

                (select distinct to_char(docdate, 'ww') week, plant, activitycat, 
                    case when activitycat = '30' then 'INS' else 'REP' end productionmethod, sum(activqty2) qty
                from tmp_yieldminmax q
                where activitycat in ('30', '40')   
                group by to_char(docdate, 'ww'), plant, activitycat))
                
            where rnkmin = 3 or rnkmax = 3
        group by plant, activitycat, productionmethod)
    group by plant) r
    
where u.qb = c.qb 
and u.plant = r.plant(+)
and u.plant = t.loc(+)
and u.matcode = t.matcode(+)
and u.qb = t.qb(+)
and t.loc is null;

commit;

declare
  cursor cur_selected is
    select u.loc, u.matcode, u.qb, u.item, u.pc_util, u.hrsperday, u.buycost, u.inspcosthr, u.repcosthr, u.pscosthr, 
        u.hi_volinsp, u.hi_volrepair, u.perceninsp, u.percenrepair, u.placeholder
    from tmp_yield y,

        (select distinct u.plant loc, u.matcode, u.qb, u.matcode||u.qb item, c.pc_util, c.hrsperday, c.buycost, c.inspcosthr, c.repcosthr, c.pscosthr, 
            nvl(r.hi_volinsp, 0) hi_volinsp, nvl(r.hi_volrepair, 0) hi_volrepair, nvl(u.perceninsp, 0) perceninsp, nvl(u.percenrepair, 0) percenrepair, u.placeholder  
        from tmp_yield t, tmp_costs c,

            (select distinct plant, matcode, qb, 
                max(case when productionmethod = 'INS' then yield end) perceninsp, 
                max(case when productionmethod = 'REP' then yield end) percenrepair, 1 placeholder
            from
                (select u.plant, u.matcode, t.sup_qb qb, 
                                case when u.productionmethod = '1' then 'INS' else 'REP' end productionmethod, u.yield 
                from tmp_qb t, 

                    (select n.plant, substr(n.material, -5) matcode, n.batch, n.productionmethod, round(n.n/d.d, 4) yield 
                    from

                        (select distinct plant, material, batch, substr(purchorder, 1, 1) productionmethod, sum(quantity) n
                        from 
                            (select plant, material, mvt,  
                                        case when batch in ('AD', 'AP', 'AW') then 'AR' else batch end batch, purchorder, quantity
                             from tmp_yieldrate)
                        where mvt in ('531', '532')
                        and substr(purchorder, 1, 1) in ('1', '2')  
                        group by plant, material, substr(purchorder, 1, 1), batch) n, 
                        
                        (select plant, material, productionmethod, d
                        from
                            (select distinct plant, material, substr(purchorder, 1, 1) productionmethod, sum(abs(quantity)) d
                            from tmp_yieldrate
                            where mvt in ('531', '532')
                            and substr(purchorder, 1, 1) in ('1', '2')  
                            group by plant, material, substr(purchorder, 1, 1))) d

                    where n.plant = d.plant
                    and n.material = d.material
                    and n.productionmethod = d.productionmethod) u
                    
                where t.dmd_qb = u.batch
                and t.sup_qb is not null
                and u.yield > 0 
                and u.productionmethod||t.sup_qb <> '1AI') 

            group by plant, matcode, qb) u,
            
            (select distinct plant, 
                max(case when productionmethod = 'INS' then qtymax end) hi_volinsp,   
                max(case when productionmethod = 'REP' then qtymax end) hi_volrepair
            from
                (select distinct plant, activitycat, productionmethod,   
                    max(case when rnkmin = 3 then qty end) qtymin, 
                    max(case when rnkmax = 3 then qty end) qtymax
                from
                    (select distinct week, plant, activitycat, productionmethod, qty, 
                        dense_rank() over (partition by plant, activitycat order by qty asc) rnkmin,
                        dense_rank() over (partition by plant, activitycat order by qty desc) rnkmax
                    from

                        (select distinct to_char(docdate, 'ww') week, plant, activitycat, 
                            case when activitycat = '30' then 'INS' else 'REP' end productionmethod, sum(activqty2) qty
                        from tmp_yieldminmax q
                        where activitycat in ('30', '40')   
                        group by to_char(docdate, 'ww'), plant, activitycat))
                        
                    where rnkmin = 3 or rnkmax = 3
                group by plant, activitycat, productionmethod)
            group by plant) r
            
        where u.qb = c.qb 
        and u.plant = r.plant(+)
        and u.plant = t.loc(+)
        and u.matcode = t.matcode(+)
        and u.qb = t.qb(+)
        and t.loc is not null) u
        
    where u.item = y.item
    and u.loc = y.loc
    for update of y.pc_util;
begin
  for cur_record in cur_selected loop
  
    update tmp_yield
    set pc_util = cur_record.pc_util
    where current of cur_selected;
    
    update tmp_yield
    set hrsperday = cur_record.hrsperday
    where current of cur_selected;
    
    update tmp_yield
    set buycost = cur_record.buycost
    where current of cur_selected;
    
    update tmp_yield
    set inspcosthr = cur_record.inspcosthr
    where current of cur_selected;
    
    update tmp_yield
    set repcosthr = cur_record.repcosthr
    where current of cur_selected;
    
    update tmp_yield
    set pscosthr = cur_record.pscosthr
    where current of cur_selected;
    
    update tmp_yield
    set hi_volinsp = cur_record.hi_volinsp
    where current of cur_selected;
    
    update tmp_yield
    set hi_volrepair = cur_record.hi_volrepair
    where current of cur_selected;
    
    update tmp_yield
    set perceninsp = cur_record.perceninsp
    where current of cur_selected;
    
    update tmp_yield
    set percenrepair = cur_record.percenrepair
    where current of cur_selected;
    
    update tmp_yield
    set placeholder = cur_record.placeholder
    where current of cur_selected;
    
  end loop;
  commit;
end;

end;
