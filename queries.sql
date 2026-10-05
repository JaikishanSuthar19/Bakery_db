-- Bakery Wholesale Distribution Route Database
-- Database: new_bakery_distribution
-- File: queries.sql

-- =========================================================
-- 1. BASIC SELECT, WHERE AND ORDER BY
-- =========================================================

-- Display all products
SELECT *
FROM products;

-- Products costing more than 100
SELECT product_name, unit_price
FROM products
WHERE unit_price > 100
ORDER BY unit_price DESC;

-- Display outlets alphabetically
SELECT outlet_code, outlet_name, address
FROM outlets
ORDER BY outlet_name;


-- =========================================================
-- 2. REQUIRED QUESTION: NET SUPPLY TO EACH OUTLET
-- Net Supply = Delivered Quantity - Returned Quantity
-- =========================================================

SELECT
    o.outlet_name,
    p.product_name,
    SUM(di.quantity_delivered) AS total_delivered,
    COALESCE(SUM(ri.quantity_returned), 0) AS total_returned,
    SUM(di.quantity_delivered)
        - COALESCE(SUM(ri.quantity_returned), 0) AS net_supply
FROM outlets o
JOIN deliveries d
    ON o.outlet_id = d.outlet_id
JOIN delivery_items di
    ON d.delivery_id = di.delivery_id
JOIN products p
    ON di.product_id = p.product_id
LEFT JOIN returns r
    ON d.delivery_id = r.delivery_id
LEFT JOIN return_items ri
    ON r.return_id = ri.return_id
    AND di.product_id = ri.product_id
GROUP BY
    o.outlet_id,
    o.outlet_name,
    p.product_id,
    p.product_name
ORDER BY
    o.outlet_name,
    p.product_name;


-- =========================================================
-- 3. REQUIRED QUESTION: RETURN RATE FOR EACH PRODUCT
-- Return Rate = Returned / Delivered * 100
-- =========================================================

SELECT
    p.product_name,
    SUM(di.quantity_delivered) AS total_delivered,
    COALESCE(SUM(ri.quantity_returned), 0) AS total_returned,
    ROUND(
        COALESCE(SUM(ri.quantity_returned), 0) * 100.0
        / NULLIF(SUM(di.quantity_delivered), 0),
        2
    ) AS return_rate_percent
FROM products p
JOIN delivery_items di
    ON p.product_id = di.product_id
JOIN deliveries d
    ON di.delivery_id = d.delivery_id
LEFT JOIN returns r
    ON d.delivery_id = r.delivery_id
LEFT JOIN return_items ri
    ON r.return_id = ri.return_id
    AND p.product_id = ri.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    return_rate_percent DESC;


-- =========================================================
-- 4. REQUIRED QUESTION: DELIVERIES PER ROUTE PER DAY
-- =========================================================

SELECT
    r.route_code,
    r.route_name,
    d.delivery_date,
    COUNT(d.delivery_id) AS number_of_deliveries
FROM routes r
JOIN deliveries d
    ON r.route_id = d.route_id
GROUP BY
    r.route_id,
    r.route_code,
    r.route_name,
    d.delivery_date
ORDER BY
    d.delivery_date,
    r.route_code;


-- =========================================================
-- 5. REQUIRED QUESTION: UNPAID INVOICES
-- =========================================================

SELECT
    o.outlet_code,
    o.outlet_name,
    i.invoice_number,
    i.invoice_date,
    i.due_date,
    i.net_amount,
    i.payment_status
FROM invoices i
JOIN outlets o
    ON i.outlet_id = o.outlet_id
WHERE i.payment_status = 'Unpaid'
ORDER BY i.due_date;


-- =========================================================
-- 6. REQUIRED QUESTION: OUTLETS WITH MORE THAN 20% RETURNS
-- =========================================================

WITH outlet_totals AS (
    SELECT
        o.outlet_id,
        o.outlet_name,
        SUM(di.quantity_delivered) AS total_delivered,
        COALESCE(SUM(ri.quantity_returned), 0) AS total_returned
    FROM outlets o
    JOIN deliveries d
        ON o.outlet_id = d.outlet_id
    JOIN delivery_items di
        ON d.delivery_id = di.delivery_id
    LEFT JOIN returns r
        ON d.delivery_id = r.delivery_id
    LEFT JOIN return_items ri
        ON r.return_id = ri.return_id
        AND di.product_id = ri.product_id
    GROUP BY
        o.outlet_id,
        o.outlet_name
)
SELECT
    outlet_name,
    total_delivered,
    total_returned,
    ROUND(
        total_returned * 100.0
        / NULLIF(total_delivered, 0),
        2
    ) AS return_rate_percent
FROM outlet_totals
WHERE total_returned * 100.0
      / NULLIF(total_delivered, 0) > 20
ORDER BY return_rate_percent DESC;


-- =========================================================
-- 7. GROUP BY AND AGGREGATE FUNCTIONS
-- =========================================================

SELECT
    category,
    COUNT(*) AS product_count,
    AVG(unit_price) AS average_price,
    MIN(unit_price) AS minimum_price,
    MAX(unit_price) AS maximum_price
FROM products
GROUP BY category
ORDER BY category;


-- =========================================================
-- 8. HAVING
-- =========================================================

SELECT
    category,
    COUNT(*) AS product_count
FROM products
GROUP BY category
HAVING COUNT(*) > 1
ORDER BY product_count DESC;


-- =========================================================
-- 9. JOIN: OUTLETS AND ROUTES
-- =========================================================

SELECT
    o.outlet_code,
    o.outlet_name,
    r.route_code,
    r.route_name,
    r.delivery_day
FROM outlets o
JOIN routes r
    ON o.route_id = r.route_id
ORDER BY
    r.route_code,
    o.outlet_name;


-- =========================================================
-- 10. JOIN: DELIVERY DETAILS
-- =========================================================

SELECT
    d.delivery_id,
    o.outlet_name,
    p.product_name,
    di.quantity_delivered,
    d.delivery_date,
    d.delivery_status
FROM delivery_items di
JOIN deliveries d
    ON di.delivery_id = d.delivery_id
JOIN outlets o
    ON d.outlet_id = o.outlet_id
JOIN products p
    ON di.product_id = p.product_id
ORDER BY
    d.delivery_id,
    p.product_name;


-- =========================================================
-- 11. JOIN: RETURN DETAILS
-- =========================================================

SELECT
    r.return_id,
    o.outlet_name,
    p.product_name,
    ri.quantity_returned,
    r.return_date,
    r.return_reason
FROM return_items ri
JOIN returns r
    ON ri.return_id = r.return_id
JOIN deliveries d
    ON r.delivery_id = d.delivery_id
JOIN outlets o
    ON d.outlet_id = o.outlet_id
JOIN products p
    ON ri.product_id = p.product_id
ORDER BY
    r.return_id,
    p.product_name;


-- =========================================================
-- 12. SUBQUERY: PRODUCTS ABOVE AVERAGE PRICE
-- =========================================================

SELECT
    product_name,
    unit_price
FROM products
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM products
)
ORDER BY unit_price DESC;


-- =========================================================
-- 13. SUBQUERY: OUTLETS WITH UNPAID INVOICES
-- =========================================================

SELECT
    outlet_name
FROM outlets
WHERE outlet_id IN (
    SELECT outlet_id
    FROM invoices
    WHERE payment_status = 'Unpaid'
)
ORDER BY outlet_name;


-- =========================================================
-- 14. SUBQUERY: PRODUCTS THAT HAVE BEEN RETURNED
-- =========================================================

SELECT
    product_name
FROM products
WHERE product_id IN (
    SELECT product_id
    FROM return_items
)
ORDER BY product_name;


-- =========================================================
-- 15. TOTAL QUANTITY DELIVERED BY PRODUCT
-- =========================================================

SELECT
    p.product_name,
    SUM(di.quantity_delivered) AS total_quantity_delivered
FROM products p
JOIN delivery_items di
    ON p.product_id = di.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    total_quantity_delivered DESC;


-- =========================================================
-- 16. TOTAL QUANTITY RETURNED BY PRODUCT
-- =========================================================

SELECT
    p.product_name,
    COALESCE(SUM(ri.quantity_returned), 0) AS total_quantity_returned
FROM products p
LEFT JOIN return_items ri
    ON p.product_id = ri.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    total_quantity_returned DESC;


-- =========================================================
-- 17. INVOICE SUMMARY BY PAYMENT STATUS
-- =========================================================

SELECT
    payment_status,
    COUNT(*) AS invoice_count,
    SUM(net_amount) AS total_invoice_amount
FROM invoices
GROUP BY payment_status
ORDER BY payment_status;


-- =========================================================
-- 18. TOTAL BILLING BY OUTLET
-- =========================================================

SELECT
    o.outlet_name,
    COUNT(i.invoice_id) AS invoice_count,
    SUM(i.net_amount) AS total_billed
FROM outlets o
JOIN invoices i
    ON o.outlet_id = i.outlet_id
GROUP BY
    o.outlet_id,
    o.outlet_name
ORDER BY total_billed DESC;


-- =========================================================
-- 19. DATABASE RECORD COUNTS
-- =========================================================

SELECT 'routes' AS table_name, COUNT(*) AS records FROM routes
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'outlets', COUNT(*) FROM outlets
UNION ALL
SELECT 'deliveries', COUNT(*) FROM deliveries
UNION ALL
SELECT 'delivery_items', COUNT(*) FROM delivery_items
UNION ALL
SELECT 'returns', COUNT(*) FROM returns
UNION ALL
SELECT 'return_items', COUNT(*) FROM return_items
UNION ALL
SELECT 'invoices', COUNT(*) FROM invoices;
