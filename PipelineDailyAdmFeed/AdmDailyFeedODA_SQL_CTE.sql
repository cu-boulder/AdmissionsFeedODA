
/***********************************
*
*
* Admmissions Daily Feed for ODA
* Robert Stubbs, Pavan Kumar Narayanan
*
*
*
************************************/

insert into
    ADMDAILYODA WITH CuAdmMainFinal as (
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
    ),
    ExtOrg as (
        select
            emplid,
            hs1_ext_org_descr
        from
            sysadm.cu_ext_ed_hs_ugrd_grad
    ),
    PersonAddress as (
        select
            person_id,
            home_state,
            home_country_cd
        from
            sysadm.ps_cu_d_persn_addr
    )
Select
    CuAdmMainFinal.emplid,
    --person id 
    /**************************************
     *
     * PeopleSoft Campus Solutions PersonID
     * PersonID and Emplid are the same
     *  
     **************************************/
    CuAdmMainFinal.adm_appl_nbr,
    --admissions application number
    CuAdmMainFinal.admit_term,
    --term of admittance
    CuAdmMainFinal.admit_type,
    --type of admittance
    CuAdmMainFinal.prog_status,
    --program status
    CuAdmMainFinal.AP,
    --University of Colorado IR custom variable for reporting
    CuAdmMainFinal.institution,
    --institution
    CuAdmMainFinal.acad_prog,
    --academic program
    CuAdmMainFinal.admit,
    --University of Colorado IR custom variable - admit flag
    CuAdmMainFinal.completed,
    --University of Colorado IR custom variable - completed flag
    ExtOrg.hs1_ext_org_descr,
    --high school name information
    PersonAddress.home_state,
    --home state
    /********************************************
     *
     * resa - University of Colorado IR custom variable 
     * residency determination based 
     * business logic extracted from SAS Code
     *
     *********************************************/
    case
        when CuAdmMainFinal.tuition_res = 'RES'
        or PersonAddress.home_state = 'CO' then 'r'
        when (
            CuAdmMainFinal.citizenship_status in ('-', '4')
            or CuAdmMainFinal.citizenship_status is null
        )
        or (PersonAddress.home_country_cd = 'USA') then 'n'
        when (CuAdmMainFinal.citizenship_status = 2)
        or (
            PersonAddress.home_country_cd != 'USA'
            and (
                CuAdmMainFinal.citizenship_status in ('-', '4')
                or CuAdmMainFinal.citizenship_status is null
            )
        ) then 'i'
        else 'i'
    end resa --residency status
from
    CuAdmMainFinal,
    ExtOrg,
    PersonAddress
where
    CuAdmMainFinal.emplid = ExtOrg.emplid
    and ExtOrg.emplid = PersonAddress.person_id
    and PersonAddress.person_id = CuAdmMainFinal.emplid