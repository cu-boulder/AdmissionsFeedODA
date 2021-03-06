select
    *
from
    sysadm.cu_adm_main_final;

select
    *
From
    sysadm.cu_adm_main_final
where
    emplid = 'test'
select
    *
from
    sysadm.cu_adm_main_final
where
    NAME = 'XX'
select
    *
from
    sysadm.cu_adm_main_final_type2
select
    *
from
    sysadm.cu_adm_main_final
where
    emplid not in (
        select
            *
        from
            cu_bld_ir.oda_adm_testid
    );

select
    max(LASTUPD_EW_DTTM)
from
    sysadm.cu_adm_main_final
select
    *
from
    sysadm.cu_adm_main_final
where
    institution = 'CUBLD'
    and admit_term in ('2201', '2204', '2207');

select
    *
from
    sysadm.ps_cu_d_index_scor


select
    *
from
    sysadm.cu_ext_ed_hs_ugrd_grad;

select
    emplid,
    hs1_ls_school_type,
    hs1_state,
    hs1_act_cd,
    hs1_ext_org_descr,
    hs1_country,
    hs1_gpa_type,
    hs1_ext_gpa,
    hs1_percentile,
    hs1_convert_gpa
from
    sysadm.cu_ext_ed_hs_ugrd_grad;

select
    person_id,
    home_city,
    home_state,
    home_country_cd
from
    sysadm.ps_cu_d_persn_addr;

desc sysadm.cu_adm_main_final;

select
    *
from
    cu_bld_ir.oda_adm_testid;

--April 20 2022
select
    cu_as_pgpa,
    cu_pgpa
from
    sysadm.ps_cu_d_index_scor
where
    institution_cd = 'CUBLD'
    and cu_as_pgpa >= 4 
    --and admit_term in ('2151','2154','2157')  
    --some pgpas are college based with different factors entering into compared to arts and sciences
    --max number of characters
select
    max(hs1_act_cd)
from
    sysadm.cu_ext_ed_hs_ugrd_grad
where
    REGEXP_LIKE (hs1_act_cd, '^[^a-zA-Z\/\\()-]+$') 
    --hs1_act_cd not like '%A%' 
    -- and hs1_act_cd not like '%LEESBU%'