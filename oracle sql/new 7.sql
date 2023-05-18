ELECT
substr(BT.BALANCE_NAME,1,20) bal_name,
substr(BF.EFFECTIVE_START_DATE,1,15) start_date ,
substr(BF.EFFECTIVE_END_DATE,1,15) end_date,
substr(IV.NAME,1,15) INPUT_VAL_NAME ,
substr(HL.MEANING,1,10) ADD_OR_SUBTR ,
substr(HL2.MEANING,1,10) UOM
FROM PAY_BALANCE_FEEDS_F BF,
PAY_BALANCE_TYPES BT,
PAY_INPUT_VALUES_F IV,
PAY_ELEMENT_TYPES_F ET,
HR_LOOKUPS HL,
HR_LOOKUPS HL2
WHERE ET.ELEMENT_NAME = 'Gross Salary'
AND BT.BALANCE_TYPE_ID = BF.BALANCE_TYPE_ID
AND IV.INPUT_VALUE_ID = BF.INPUT_VALUE_ID
AND ET.ELEMENT_TYPE_ID = IV.ELEMENT_TYPE_ID
AND HL.LOOKUP_TYPE = 'KR_PAYSLIP_LABEL'
AND HL.LOOKUP_CODE = BF.SCALE
AND HL2.LOOKUP_TYPE = 'UNITS'
AND HL2.LOOKUP_CODE = IV.UOM
AND sysdate BETWEEN BF.EFFECTIVE_START_DATE AND BF.EFFECTIVE_END_DATE
AND sysdate BETWEEN IV.EFFECTIVE_START_DATE AND IV.EFFECTIVE_END_DATE
AND sysdate BETWEEN ET.EFFECTIVE_START_DATE AND ET.EFFECTIVE_END_DATE ;


SELECT   paf.assignment_number,
           ppf.full_name,
           gr.name grade,
           paygr.payroll_name payroll,
           pbt.balance_name,
           ppa.effective_date,
           prv.result_value
    FROM   Pay_Element_Types_F PET,
           Pay_Input_Values_F PIV,
           Pay_Run_Result_Values PRV,
           Pay_Run_Results PRR,
           Pay_assignment_actions PAA,
           Pay_payroll_actions PPA,
           Pay_balance_types pbt,
           Pay_balance_feeds_f pbff,
           Per_people_f ppf,
           Per_assignments_f paf,
           Per_grades gr,
           Pay_all_payrolls_f paygr
   WHERE       PRR.Element_Type_ID = PET.Element_Type_ID
           AND PRR.STATUS IN ('P', 'PA')
           AND PIV.Element_Type_ID = PET.Element_Type_ID
           AND PRV.Input_Value_ID = PIV.Input_Value_ID
           AND PRV.Run_Result_ID = PRR.Run_Result_ID
           AND PRR.Assignment_Action_ID = PAA.Assignment_Action_ID
           AND PAA.Payroll_Action_ID = PPA.Payroll_Action_ID
           --AND (PAF.Person_ID = '&&1' OR '&&1' IS NULL)
           AND PBFF.balance_type_id = PBT.balance_type_id
           AND PIV.input_value_id = PBFF.input_value_id
           AND PIV.Name IN ('Pay Value')
           --AND PPA.EFFECTIVE_DATE BETWEEN '&&3' AND '&&4'
           AND PPF.PERSON_ID = PAF.PERSON_ID
           AND SYSDATE BETWEEN ppf.effective_start_date
                           AND  ppf.effective_end_date
           AND paf.effective_start_date =
                 (SELECT   MAX (effective_start_date)
                    FROM   per_assignments_f paf1
                   WHERE   paf.assignment_id = paf1.assignment_id)
           AND PAA.ASSIGNMENT_ID = PAF.ASSIGNMENT_ID
           AND GR.GRADE_ID = PAF.GRADE_ID
           AND PAYGR.PAYROLL_ID = 122
           AND SYSDATE BETWEEN PAYGR.EFFECTIVE_START_DATE
                           AND  PAYGR.EFFECTIVE_END_DATE
ORDER BY   paf.assignment_number,
           ppf.full_name,
           gr.name,
           paygr.payroll_name,
           pbt.balance_name,
           ppa.effective_date