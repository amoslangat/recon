/******************************************************************************************
Date        Developer   Version      Description
04-07-2023 Amos Langat  1.0         Kenya re journal Achat

*******************************************************************************************/
SELECT DISTINCT
       INVOICE_DATE,
       DOC_SEQUENCE_VALUE,
       CODE_COMINATION  ACCOUNT_NO,     
       SEGMENT1,       
       DESCRIPTION,
        SUM(nvl(DR,0) ) DR,
        SUM(nvl(CR,0) ) CR,
        OPERATINGUNIT,
        VENDOR_NAME,        
        JE_NAME,        
        JE_CATEGORY,
        MRN_NO,
        BATCH_NAME,      
        JE_SOURCE,     
        PERIOD,
        EFFECTIVE_DATE,
        CURRENCY_CODE,       
        VENDOR_SITE_CODE,         
        GL_DATE ,       
        PERIOD_NAME,       
              NAME    
 FROM        (
           SELECT    
             distinct 
              JEH.NAME JE_NAME,
              jeh.LAST_UPDATE_DATE,
             JEH.JE_CATEGORY,
             hou.name Operatingunit,        
        nvl((select distinct receipt_num from rcv_shipment_headers
where shipment_header_id=(select shipment_header_id from rcv_transactions
where transaction_id=(SELECT MAX(RCV_TRANSACTION_ID) FROM AP_INVOICE_distributions_ALL
WHERE INVOICE_ID=AIA.INVOICE_ID
AND AMOUNT=XAL.ACCOUNTED_DR))),(select distinct receipt_num from rcv_shipment_headers
where shipment_header_id=(select  distinct  shipment_header_id from rcv_transactions
where transaction_id=(SELECT MAX(RCV_TRANSACTION_ID) FROM AP_INVOICE_distributionS_ALL
WHERE INVOICE_ID=AIA.INVOICE_ID)))) MRN_NO,
        AIA.DESCRIPTION,
        AIA.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        POV.VENDOR_NAME,
        PSSA.VENDOR_SITE_CODE,
        AIA.INVOICE_NUM,
         JE_SOURCE,
         (select segment1 from po_headers_all
        where po_header_id=(select max(po_header_id) from ap_invoice_lines_all
        where invoice_id=aia.invoice_id)) PO,
        AIA.INVOICE_DATE,
        AIA.GL_DATE ,
        nvl(XAL.ENTERED_DR,0)  ENTERED_DR,
        nvl(XAL.ENTERED_CR,0)  ENTERED_CR,
        nvl(XAL.ACCOUNTED_DR,0)  DR,
        nvl(XAL.ACCOUNTED_CR,0)  CR,
        nvl(XAL.ACCOUNTED_DR,0) -nvl(XAL.ACCOUNTED_CR,0)  bal,      
        POV.SEGMENT1,
        JEB.NAME BATCH_NAME,
        JEL.PERIOD_NAME,
        TO_CHAR(JEL.EFFECTIVE_DATE,'Mon-YY') PERIOD,
        'AP_INVOICE' NAME,
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT3  CODE_COMINATION, GCC.segment2, 
        NULL TYPE,
        NULL DES
FROM
        gl_code_combinations_kfv GCC,
        GL_JE_LINES JEL,
        GL_JE_HEADERS JEH,
        GL_JE_BATCHES JEB,
        GL_IMPORT_REFERENCES GIR,
        XLA.XLA_AE_LINES XAL,
        XLA.XLA_TRANSACTION_ENTITIES XEH,
        XLA.XLA_AE_HEADERS XAH
        ,AP_INVOICES_ALL AIA,
        ap_supplier_sites_all PSSA,
        ap_supplierS POV,
        hr_operating_units hou       
WHERE   JEH.JE_HEADER_ID=JEL.JE_HEADER_ID
        AND JEB.JE_BATCH_ID=JEH.JE_BATCH_ID
        AND jel.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
        AND JEH.STATUS='P'        
		AND JEH.actual_flag = 'A'           
        AND XEH.ENTITY_CODE='AP_INVOICES'      
        and hou.organization_id= nvl(:p_Operating_Unit,hou.organization_id)
        AND  jeh.PERIOD_NAME =:TO_DATE  
        and POV.VENDOR_NAME=nvl(:P_Supp_Name,POV.VENDOR_NAME)
        and POV.SEGMENT1=nvl(:P_Supp_No,pov.segment1)
        AND GIR.JE_HEADER_ID=JEH.JE_HEADER_ID
        AND GIR.JE_LINE_NUM=JEL.JE_LINE_NUM
        AND JEB.NAME LIKE '%OHADA LEDGE2108(XOF):%'       
        AND XAL.GL_SL_LINK_ID =GIR.GL_SL_LINK_ID
        AND AIA.VENDOR_ID=PSSA.VENDOR_ID
         AND POV.VENDOR_ID=PSSA.VENDOR_ID
        AND AIA.VENDOR_SITE_ID=PSSA.VENDOR_SITE_ID
        AND XAL.AE_HEADER_ID=XAH.AE_HEADER_ID
        AND XAH.ENTITY_ID=XEH.ENTITY_ID
        AND AIA.INVOICE_ID=XEH.SOURCE_ID_INT_1
        AND POV.VENDOR_ID=AIA.VENDOR_ID
        and aia.cancelled_date is null
        and hou.organization_id = aia.org_id
      
)
GROUP BY JE_NAME,
        JE_CATEGORY,
         MRN_NO,
        DESCRIPTION,
        DOC_SEQUENCE_VALUE,
        EFFECTIVE_DATE,
        CURRENCY_CODE,
        VENDOR_NAME,
        VENDOR_SITE_CODE,            
        INVOICE_DATE,
        GL_DATE ,
        JE_SOURCE,
        PERIOD,
        NAME,      
        PERIOD_NAME,
        CODE_COMINATION,       
        SEGMENT1,
        BATCH_NAME,
        operatingunit
        order by
        BATCH_NAME
        ;