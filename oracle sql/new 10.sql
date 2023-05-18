SELECT DISTINCT
    papf.employee_number,
    papf.full_name,
    (ppa.effective_date),
    pp.payroll_name,
    pet.element_name,
    piv.name input_value,
    prrv.result_value,
  
	xxkri_get_gross_sal
 SUM(prrv.result_value)
  OVER(
  ORDER BY
     ROWNUM
 )        AS "CUMULATIVE  SALARY"
FROM
    apps.pay_payroll_actions   ppa,
    pay_assignment_actions     paa,
    pay_payrolls_f             pp,
    pay_run_results            prr,
    pay_run_result_values      prrv,
    pay_input_values_f         piv,
    pay_element_types_f        pet,
    apps.per_all_assignments_f paaf,
    apps.per_all_people_f      papf
WHERE
        ppa.payroll_id = :payroll_id
    AND ppa.payroll_action_id = paa.payroll_action_id
    AND ppa.payroll_id = pp.payroll_id
    AND paa.assignment_action_id = prr.assignment_action_id
    AND prr.run_result_id = prrv.run_result_id
    AND prrv.input_value_id = piv.input_value_id
    AND piv.element_type_id = pet.element_type_id
    AND paaf.assignment_id = paa.assignment_id
    AND paaf.person_id = papf.person_id
    AND trunc(sysdate) BETWEEN pp.effective_start_date AND pp.effective_end_date
    AND trunc(sysdate) BETWEEN pet.effective_start_date AND pet.effective_end_date
    AND trunc(sysdate) BETWEEN piv.effective_start_date AND piv.effective_end_date
    AND trunc(sysdate) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
    AND trunc(sysdate) BETWEEN papf.effective_start_date AND papf.effective_end_date
    AND papf.employee_number = '1057'  
--and ppa.effective_date = '31-DEC-2022'
    AND piv.name = 'Pay Value'
    AND element_name = 'Gross Salary'
ORDER BY
    employee_number;
    
    select *  from pay_payroll_actions;
