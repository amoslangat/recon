/******************************************************************************************
Date        Developer   Version      Description
03-07-2023 Amos Langat  1.0         TKH Integrated Doctor Invoices Reconciliation

*******************************************************************************************/
SELECT
	DISTINCT 
		rcta.trx_number	 "InstaBillNumber",
	
		rcta.trx_date 	"Bill Date",

	DECODE (
		rcta.attribute_category,
		'PATIENT AND SPONSER DETAILS',
		rcta.attribute2,
		NULL
	) "PatientName",
	DECODE (
		hca.account_name,
		'TKH CASHIER',
		NULL,
		hca.account_name
	) "Sponsor Name",
	rctl.interface_line_attribute2 "Doctor ID",
	rctl.DESCRIPTION  "Doctor Name",
	rctl.interface_line_attribute4 "Doctor Amount",(
		SELECT
			SUM(rctll.extended_amount)
		FROM
			ra_customer_trx_all rct,
			ra_customer_trx_lines_all rctll
		WHERE
			1 = 1
			AND rct.customer_trx_id = rctll.customer_trx_id
			AND rct.trx_number LIKE rcta.trx_number || '%'
			AND rctl.interface_line_context = 'Doctor Charges'
	) "Oracle Bill Amount",
	(
		SELECT
			SUM(arps.amount_due_remaining)
		FROM
			ra_customer_trx_all trx,
			ar_payment_schedules_all arps
		WHERE
			1 = 1
			AND trx.customer_trx_id = arps.customer_trx_id
			AND trx.customer_trx_id = rcta.customer_trx_id
	) "Oracle Bill Balance",
	NVL(
		(
			select
				'Y'
			FROM
			ap_invoices_all aia,
			ap_invoice_lines_all aila,
			poz_suppliers supplier
		WHERE
			aia.invoice_num LIKE NVL(
				substr(
					rcta.trx_number,
					1,
					instr(rcta.trx_number, '.') -1
				),
				rcta.trx_number
			) || '%'
			AND aia.CANCELLED_DATE is NULL
			AND aila.LINE_TYPE_LOOKUP_CODE = 'ITEM'
			AND aia.invoice_id = aila.invoice_id
			AND aila.amount = TO_NUMBER(rctl.INTERFACE_LINE_ATTRIBUTE4)
			AND aia.vendor_id = supplier.vendor_id
			and rownum<2
		),
		'N'
	) "AP Invoice Generated",(
		CASE
			WHEN (
				select
					'Y'
				FROM
			ap_invoices_all aia,
			ap_invoice_lines_all aila,
			poz_suppliers supplier
		WHERE
			aia.invoice_num LIKE NVL(
				substr(
					rcta.trx_number,
					1,
					instr(rcta.trx_number, '.') -1
				),
				rcta.trx_number
			) || '%'
			AND aia.CANCELLED_DATE is NULL
			AND aila.LINE_TYPE_LOOKUP_CODE = 'ITEM'
			AND aia.invoice_id = aila.invoice_id
			AND aila.amount = TO_NUMBER(rctl.INTERFACE_LINE_ATTRIBUTE4)
			AND aia.vendor_id = supplier.vendor_id
			and rownum<2
			) = 'Y' THEN rctl.description 
			ELSE NULL
		END
	) "AP Doctor Name",(
		select  distinct 
		aia.INVOICE_NUM
		FROM
			ap_invoices_all aia,
			ap_invoice_lines_all aila,
			poz_suppliers supplier
		WHERE
			aia.invoice_num LIKE NVL(
				substr(
					rcta.trx_number,
					1,
					instr(rcta.trx_number, '.') -1
				),
				rcta.trx_number
			) || '%'
			AND aia.CANCELLED_DATE is NULL
			AND aila.LINE_TYPE_LOOKUP_CODE = 'ITEM'
			AND aia.invoice_id = aila.invoice_id
			AND aila.amount = TO_NUMBER(rctl.INTERFACE_LINE_ATTRIBUTE4)
			AND aia.vendor_id = supplier.vendor_id
			AND ROWNUM < 2
	) "AP Invoice Number",(
		select
			
				AIA.INVOICE_DATE
		FROM
			ap_invoices_all aia,
			ap_invoice_lines_all aila,
			poz_suppliers supplier
		WHERE
			aia.invoice_num LIKE NVL(
				substr(
					rcta.trx_number,
					1,
					instr(rcta.trx_number, '.') -1
				),
				rcta.trx_number
			) || '%'
			AND aia.CANCELLED_DATE is NULL
			AND aila.LINE_TYPE_LOOKUP_CODE = 'ITEM'
			AND aia.invoice_id = aila.invoice_id
			AND aila.amount = TO_NUMBER(rctl.INTERFACE_LINE_ATTRIBUTE4)
			AND aia.vendor_id = supplier.vendor_id
			and rownum<2
	) "AP Invoice Date",
	(
			select  distinct 
		aia.invoice_amount
		FROM
			ap_invoices_all aia,
			ap_invoice_lines_all aila,
			poz_suppliers supplier
		WHERE
			aia.invoice_num LIKE NVL(
				substr(
					rcta.trx_number,
					1,
					instr(rcta.trx_number, '.') -1
				),
				rcta.trx_number
			) || '%'
			AND aia.CANCELLED_DATE is NULL
			AND aila.LINE_TYPE_LOOKUP_CODE = 'ITEM'
			AND aia.invoice_id = aila.invoice_id
			AND aila.amount = TO_NUMBER(rctl.INTERFACE_LINE_ATTRIBUTE4)
			AND aia.vendor_id = supplier.vendor_id
			and rownum<2
	) "AP Invoice Amount",
	(
		select
			aia.AMOUNT_PAID
		FROM
			ap_invoices_all aia,
			ap_invoice_lines_all aila,
			poz_suppliers supplier
		WHERE
			aia.invoice_num LIKE NVL(
				substr(
					rcta.trx_number,
					1,
					instr(rcta.trx_number, '.') -1
				),
				rcta.trx_number
			) || '%'
			AND aia.CANCELLED_DATE is NULL
			AND aila.LINE_TYPE_LOOKUP_CODE = 'ITEM'
			AND aia.invoice_id = aila.invoice_id
			AND aila.amount = TO_NUMBER(rctl.INTERFACE_LINE_ATTRIBUTE4)
			AND aia.vendor_id = supplier.vendor_id
			and rownum<2
	) "AP Invoice Amount Paid",
	(
		CASE
			WHEN (
				select
					aia.AMOUNT_PAID
				FROM
			ap_invoices_all aia,
			ap_invoice_lines_all aila,
			poz_suppliers supplier
		WHERE
			aia.invoice_num LIKE NVL(
				substr(
					rcta.trx_number,
					1,
					instr(rcta.trx_number, '.') -1
				),
				rcta.trx_number
			) || '%'
			AND aia.CANCELLED_DATE is NULL
			AND aila.LINE_TYPE_LOOKUP_CODE = 'ITEM'
			AND aia.invoice_id = aila.invoice_id
			AND aila.amount = TO_NUMBER(rctl.INTERFACE_LINE_ATTRIBUTE4)
			AND aia.vendor_id = supplier.vendor_id
			and rownum<2
			) = 0 THEN 'Not Paid Or Amount Pending'
		 WHEN (	select
					aia.AMOUNT_PAID
				FROM
			ap_invoices_all aia,
			ap_invoice_lines_all aila,
			poz_suppliers supplier
		WHERE
			aia.invoice_num LIKE NVL(
				substr(
					rcta.trx_number,
					1,
					instr(rcta.trx_number, '.') -1
				),
				rcta.trx_number
			) || '%'
			AND aia.CANCELLED_DATE is NULL
			AND aila.LINE_TYPE_LOOKUP_CODE = 'ITEM'
			AND aia.invoice_id = aila.invoice_id
			AND aila.amount = TO_NUMBER(rctl.INTERFACE_LINE_ATTRIBUTE4)
			AND aia.vendor_id = supplier.vendor_id
			and rownum<2
			) >0 THEN 'Paid'
			ELSE 'Not Paid Or Amount Pending'
		END
	) as "AP Invoice Paid Status"
FROM
	hz_cust_accounts hca,
	ra_customer_trx_all rcta,
	ra_customer_trx_lines_all rctl
WHERE
	1 = 1
	AND hca.cust_account_id = rcta.bill_to_customer_id
	AND rcta.customer_trx_id = rctl.customer_trx_id
	AND rctl.interface_line_context = 'Doctor Charges'
	AND (
		rctl.interface_line_attribute2 <> 'No'
		OR rctl.interface_line_attribute3 <> 'No'
	)         
	AND (
		NVL(TO_NUMBER(rctl.interface_line_attribute4), 0) != 0
		OR NVL(TO_NUMBER(rctl.interface_line_attribute4), 0) != 0.0
	)
and rctl.DESCRIPTION  = NVL(:p_doc_name, rctl.DESCRIPTION )
AND TRUNC(rcta.trx_date) between :p_from_date	and :p_to_date
	---AND rcta.trx_number like  '%BL1463679%'