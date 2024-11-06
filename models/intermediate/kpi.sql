WITH nb_products_parcel AS (
  SELECT
    parcel_id
    ,SUM(quantity) AS qty
    ,COUNT(DISTINCT model_name) AS nb_products
  FROM {{ref("stg_raw_data_circle__raw_cc_parcel_product")}} 
  GROUP BY parcel_id
)

SELECT
  ### Key ###
  parcel_id
  ###########
  -- parcel infos
  ,parcel_tracking
  ,transporter
  ,priority
  -- date --
--   ,PARSE_DATE("%B %e, %Y", date_purchase) AS date_purchase
--   ,PARSE_DATE("%B %e, %Y", date_shipping) AS date_shipping
--   ,PARSE_DATE("%B %e, %Y", date_delivery) AS date_delivery
--   ,PARSE_DATE("%B %e, %Y", date_cancelled) AS date_cancelled
  -- month --
--   ,EXTRACT(MONTH FROM PARSE_DATE("%B %e, %Y", date_purchase)) AS month_purchase
  -- status -- 
  ,CASE
    WHEN date_cancelled IS NOT NULL THEN 'Cancelled'
    WHEN date_shipping IS NULL THEN 'In Progress'
    WHEN date_delivery IS NULL THEN 'In Transit'
    WHEN date_delivery IS NOT NULL THEN 'Delivered'
    ELSE NULL
  END AS status
  -- time --
--   ,DATE_DIFF(PARSE_DATE("%B %e, %Y", date_shipping),PARSE_DATE("%B %e, %Y", date_purchase),DAY) AS expedition_time
--   ,DATE_DIFF(PARSE_DATE("%B %e, %Y", date_delivery),PARSE_DATE("%B %e, %Y", date_shipping),DAY) AS transport_time
--   ,DATE_DIFF(PARSE_DATE("%B %e, %Y", date_delivery),PARSE_DATE("%B %e, %Y", date_purchase),DAY) AS delivery_time
--   -- delay
--   ,IF(date_delivery IS NULL,NULL,IF(DATE_DIFF(PARSE_DATE("%B %e, %Y", date_delivery),PARSE_DATE("%B %e, %Y", date_purchase),DAY)>5,1,0)) AS delay
  -- Metrics --
  ,qty
  ,nb_products
FROM {{ref("stg_raw_data_circle__raw_cc_parcel")}}
LEFT JOIN nb_products_parcel USING (parcel_id)