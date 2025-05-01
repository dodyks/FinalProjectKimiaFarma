CREATE OR REPLACE TABLE `rakamin-kf-analytics-457708.kimia_farma.kimia_farma_analysis` AS
SELECT 
    -- Transaction and date information
    t.transaction_id,
    t.date,

    -- Branch information
    c.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang, 

    -- Customer and product information
    t.customer_name,
    p.product_id,
    p.product_name,

    -- Price and discount details
    t.price AS actual_price, 
    t.discount_percentage,

    -- Nett sales after discount
    (t.price * (1 - t.discount_percentage / 100)) AS nett_sales,

    -- Gross profit margin based on price brackets
    CASE 
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price <= 100000 THEN 0.15
        WHEN t.price <= 300000 THEN 0.20
        WHEN t.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,

    -- Nett profit = nett sales * gross margin
    (t.price * (1 - t.discount_percentage / 100)) * 
    CASE 
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price <= 100000 THEN 0.15
        WHEN t.price <= 300000 THEN 0.20
        WHEN t.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS nett_profit,

    -- Customer rating for the transaction
    t.rating AS rating_transaksi

FROM `rakamin-kf-analytics-457708.kimia_farma.kf_final_transaction` t
JOIN `rakamin-kf-analytics-457708.kimia_farma.kf_kantor_cabang` c 
    ON t.branch_id = c.branch_id
JOIN `rakamin-kf-analytics-457708.kimia_farma.kf_product` p 
    ON t.product_id = p.product_id;