/***********************************
*
* Adm Daily Feed for ODA 
* Robert Stubbs, Pavan Kumar Narayanan
*
************************************/

insert into
    ADMDAILYODA
select
    a.emplid,
    --person id 
    /**************************************
     *
     * PeopleSoft Campus Solutions PersonID
     * PersonID and Emplid are the same
     *  
     **************************************/
    a.adm_appl_nbr,
    --admissions application number
    a.admit_term,
    --term of admittance
    a.admit_type,
    --type of admittance
    a.prog_status,
    --program status
    a.AP,
    --University of Colorado IR custom variable for reporting
    a.institution,
    --institution
    a.acad_prog,
    --academic program
    a.admit,
    --University of Colorado IR custom variable - admit flag
    a.completed,
    --University of Colorado IR custom variable - completed flag
    b.hs1_ext_org_descr,
    --high school name information
    c.home_state,
    --home state
    /********************************************
     *
     * resa - University of Colorado IR custom variable 
     * residency determination based 
     * business logic extracted from SAS Code
     *
     *********************************************/
    case
        when (
            a.tuition_res = 'RES'
            or c.home_state = 'CO'
        ) then 'r'
        when (
            a.citizenship_status in ('-', '4')
            or a.citizenship_status is null
        )
        or (c.home_country_cd = 'USA') then 'n'
        when (a.citizenship_status = 2)
        or (
            c.home_country_cd != 'USA'
            and (
                a.citizenship_status in ('-', '4')
                or a.citizenship_status is null
            )
        ) then 'i'
        else 'i'
    end resa --residency status
from
    (
        Select
            /****************************
             *
             * CU_ADM_MAIN_FINAL from CIW
             *
             *****************************/
            emplid,
            adm_appl_nbr,
            admit_term,
            admit_type,
            prog_status,
            institution,
            acad_prog,
            citizenship_status,
            --resa compute variable
            tuition_res,
            --resa compute variable 
            /********************************************
             *
             * Aps, all cases w/o readmits and non-degree R*, N*, PRE 
             * (Readmit, Non-degree, Professional (law readmits)
             * contact Robert Stubbs for more information
             *
             ********************************************/
            case
                when admit_type not in ('R', 'PRE', 'NRU', 'N') then 1
                else 0
            end AP,
            /********************************************
             *
             * admit flag determind using 
             * program status and program reason
             * contact Robert Stubbs 
             *
             *********************************************/
            case
                when (
                    prog_status in ('AD', 'PM', 'AC')
                    or (
                        prog_status = 'CN'
                        and prog_reason in ('CINT', 'CADM', 'SELF', 'ADMT')
                    )
                ) then 1
                else 0
            end Admit,
            /********************************************
             *
             * completion flag based on various data points 
             * consult Robert Stubbs and Perry Sailor  
             * for any updates since March 2022
             *
             *********************************************/
            case
                when (
                    (prog_status in ('AD', 'PM', 'AC')) -- program status is accepted
                    or (
                        prog_status = 'CN' -- program status is cancelled
                        and prog_reason in ('CINT', 'CADM', 'SELF', 'ADMT')
                    )
                ) -- program reason code  
                or (
                    (
                        prog_reason in ('REVD', 'CMTE', 'COMP')
                        and acad_career != 'GRAD'
                    ) -- academic career set to graduate 
                    or (
                        prog_reason in ('APDP', 'COMP')
                        and acad_career = 'GRAD'
                    )
                    or (
                        (prog_status in ('PM', 'AC'))
                        or (prog_action = 'DENY')
                        or (prog_status = 'WT')
                        or (prog_action = 'DEFR')
                    )
                ) -- program deferral code
                then 1
                else 0
            end Completed
        from
            sysadm.cu_adm_main_final
    ) a,
    (
        select
            emplid,
            hs1_ext_org_descr
        from
            sysadm.cu_ext_ed_hs_ugrd_grad
    ) b,
    (
        select
            person_id,
            home_state,
            home_country_cd
        from
            sysadm.ps_cu_d_persn_addr
    ) c
where
    a.emplid = b.emplid
    and b.emplid = c.person_id
    and c.person_id = a.emplid