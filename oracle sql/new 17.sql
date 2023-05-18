select * from pay_cost_allocation_keyflex order by last_update_date desc;

select * from gl_interface where date_created>sysdate-150 and currency_code='XOF';

UPDATE pay_cost_allocation_keyflex
    SET
    concatenated_segments = '21.70701.218008.00000.0000.00000000000.000000'
    ,segment1 = '21'
    ,segment2 = '70701'
    ,segment3 = '21800'
    ,segment4 = '00000'
    ,segment5 = '0000'
    ,segment6 = '00000000000'
    ,segment7 = '000000'
    WHERE cost_allocation_keyflex_id = 96207; -- make sure 1 row is updated;
    
    
    Delete from PAY_COST_ALLOCATION_KEYFLEX where
    COST_ALLOCATION_KEYFLEX_ID=97207;
	
	
	
	SELECT 
    TO_CHAR(DTTM,'YYYY-MM-DD') as "DATE"
    ,COUNT(CASE WHEN TO_CHAR(DTTM, 'HH24:MI') BETWEEN '14:00' AND '22:00' THEN TKTNUM ELSE NULL END) AS "DAYS"
    ,COUNT(CASE WHEN TO_CHAR(DTTM, 'HH24:MI') BETWEEN '06:00' AND '14:00' THEN TKTNUM ELSE NULL END) AS "MIDS"
    ,COUNT(CASE WHEN TO_CHAR(DTTM, 'HH24:MI') NOT BETWEEN '06:00' AND '22:00' THEN TKTNUM ELSE NULL END) AS "SWINGS"
    ,COUNT(TKTNUM) AS "TOTAL"
    FROM TKTHISTORY
    GROUP BY TO_CHAR(DTTM,'YYYY-MM-DD')
    ORDER BY TO_CHAR(DTTM,'YYYY-MM-DD')