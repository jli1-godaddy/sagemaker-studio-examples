SELECT
cast(bill_id as bigint) as order_id,
sum(month_18_pltv) as v2_18m
FROM default.monthly_actual_and_predicted_ltv_2021_03_17
WHERE prediction_type = 'NC'
AND bill_mst_date BETWEEN date('2021-03-10') AND date('2021-03-16')
GROUP BY 1
HAVING sum(month_18_pltv) > 0