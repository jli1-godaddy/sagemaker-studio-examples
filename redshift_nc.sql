SELECT bb.order_id as order_id, parent_channel_name, campaign_name, sum(actual_18m) as actual_18m, sum(v1_18m) as v1_18m
FROM
(SELECT order_id, sum(month_18_prediction) as v1_18m
FROM bi.dna_approved.v_nc_nru_ec_ltv_predictions 
WHERE prediction_type = 'NC'
AND order_date BETWEEN '2021-03-10' AND '2021-03-16'
GROUP BY 1)aa

INNER JOIN

(SELECT g.order_id, parent_channel_name, campaign_name, sum(actual_18m) as actual_18m
FROM

(SELECT cast(order_id as bigint) as order_id, parent_channel_name, campaign_name
FROM bi.ba_marketing.mrd_attribution_beta10
WHERE order_date BETWEEN '2021-03-10' AND '2021-03-16'
AND parent_channel_name NOT IN ('TV')
GROUP BY 1,2,3)g

INNER JOIN

(SELECT a.order_id, b.shopper_id, sum(b.margin_gcr_amt) as actual_18m
FROM

(SELECT order_id, shopper_id
FROM bi.dna_approved.uds_order
WHERE order_date BETWEEN '2021-03-10' AND '2021-03-16'
AND margin_gcr_amt >.01
GROUP BY 1,2)a



INNER JOIN

(SELECT shopper_id, sum(margin_gcr_amt) as margin_gcr_amt
FROM bi.dna_approved.uds_order
WHERE order_date BETWEEN '2021-03-10' AND '2022-09-16'
GROUP BY 1
HAVING sum(margin_gcr_amt)>.01)b

ON a.shopper_id = b.shopper_id
GROUP BY 1,2)h
ON h.order_id = g.order_id
GROUP BY 1,2,3)bb

ON aa.order_id = bb.order_id
GROUP BY 1,2,3