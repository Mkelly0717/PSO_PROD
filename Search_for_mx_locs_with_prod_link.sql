select *
from mak_mx_hist_locs hf
where not exists
             ( select 1
                 from loc@scpomgr_chptstdb.jdadelivers.com l
                where l.loc=hf.loc
             )