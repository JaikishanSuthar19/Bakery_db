-- Bakery Wholesale Distribution Route Database
-- Database: new_bakery_distribution
-- File: seed.sql
-- Sample data for the case study

INSERT INTO routes
(route_code, route_name, delivery_day, start_area)
VALUES
('R001', 'Navi Mumbai North', 'Monday', 'Vashi'),
('R002', 'Navi Mumbai South', 'Tuesday', 'Nerul'),
('R003', 'Mumbai Central', 'Wednesday', 'Sion'),
('R004', 'Thane East', 'Thursday', 'Thane'),
('R005', 'Thane West', 'Friday', 'Mulund'),
('R006', 'Panvel Route', 'Saturday', 'Panvel');

INSERT INTO products
(product_code, product_name, category, unit_price, shelf_life_days)
VALUES
('P001', 'White Bread', 'Bread', 40.00, 3),
('P002', 'Brown Bread', 'Bread', 50.00, 4),
('P003', 'Burger Buns', 'Buns', 60.00, 4),
('P004', 'Pav', 'Buns', 35.00, 3),
('P005', 'Chocolate Cake', 'Cake', 450.00, 3),
('P006', 'Vanilla Cake', 'Cake', 400.00, 3),
('P007', 'Butter Cookies', 'Cookies', 120.00, 15),
('P008', 'Chocolate Cookies', 'Cookies', 140.00, 15),
('P009', 'Rusk', 'Bakery', 90.00, 20),
('P010', 'Croissant', 'Pastry', 80.00, 2);

INSERT INTO outlets
(outlet_code, outlet_name, address, phone, route_id)
VALUES
('O001', 'Fresh Mart Vashi', 'Sector 17, Vashi', '9876500001', 1),
('O002', 'Daily Needs Vashi', 'Sector 10, Vashi', '9876500002', 1),
('O003', 'Shree Grocery Nerul', 'Sector 8, Nerul', '9876500003', 2),
('O004', 'Sai Supermarket Nerul', 'Sector 20, Nerul', '9876500004', 2),
('O005', 'City Mart Sion', 'Sion East', '9876500005', 3),
('O006', 'Royal Stores Sion', 'Sion West', '9876500006', 3),
('O007', 'Thane Fresh', 'Naupada, Thane', '9876500007', 4),
('O008', 'Om Supermarket', 'Khopat, Thane', '9876500008', 4),
('O009', 'Westside Grocery', 'Mulund West', '9876500009', 5),
('O010', 'Green Basket', 'Mulund East', '9876500010', 5),
('O011', 'Panvel Daily', 'Old Panvel', '9876500011', 6),
('O012', 'New Panvel Mart', 'New Panvel', '9876500012', 6);

INSERT INTO deliveries
(outlet_id, route_id, delivery_date, delivery_status)
VALUES
(1, 1, '2026-09-21', 'Delivered'),
(2, 1, '2026-09-21', 'Delivered'),
(3, 2, '2026-09-22', 'Delivered'),
(4, 2, '2026-09-22', 'Delivered'),
(5, 3, '2026-09-23', 'Delivered'),
(6, 3, '2026-09-23', 'Delivered'),
(7, 4, '2026-09-24', 'Delivered'),
(8, 4, '2026-09-24', 'Delivered'),
(9, 5, '2026-09-25', 'Delivered'),
(10, 5, '2026-09-25', 'Delivered'),
(11, 6, '2026-09-26', 'Delivered'),
(12, 6, '2026-09-26', 'Delivered'),
(1, 1, '2026-09-28', 'Delivered'),
(2, 1, '2026-09-28', 'Delivered'),
(3, 2, '2026-09-29', 'Delivered'),
(4, 2, '2026-09-29', 'Delivered'),
(5, 3, '2026-09-30', 'Delivered'),
(6, 3, '2026-09-30', 'Delivered');

INSERT INTO delivery_items
(delivery_id, product_id, quantity_delivered)
VALUES
(1, 1, 100),
(1, 3, 50),
(1, 7, 30),
(2, 1, 80),
(2, 4, 60),
(2, 8, 25),
(3, 2, 90),
(3, 5, 20),
(3, 9, 40),
(4, 1, 120),
(4, 3, 60),
(4, 10, 30),
(5, 2, 70),
(5, 6, 25),
(5, 7, 35),
(6, 1, 100),
(6, 4, 80),
(6, 8, 30),
(7, 1, 110),
(7, 3, 70),
(7, 5, 20),
(8, 2, 90),
(8, 4, 75),
(8, 9, 30),
(9, 1, 95),
(9, 7, 40),
(9, 10, 20),
(10, 2, 100),
(10, 8, 35),
(10, 9, 40),
(11, 1, 130),
(11, 3, 70),
(11, 5, 25),
(12, 2, 100),
(12, 4, 80),
(12, 7, 40),
(13, 1, 100),
(13, 3, 50),
(14, 1, 90),
(14, 4, 70),
(15, 2, 100),
(15, 5, 25),
(16, 1, 110),
(16, 10, 30),
(17, 2, 80),
(17, 7, 40),
(18, 1, 120),
(18, 8, 40);

INSERT INTO returns
(delivery_id, return_date, return_reason)
VALUES
(1, '2026-09-21', 'Unsold stock'),
(2, '2026-09-21', 'Unsold stock'),
(3, '2026-09-22', 'Damaged packaging'),
(4, '2026-09-22', 'Unsold stock'),
(5, '2026-09-23', 'Unsold stock'),
(6, '2026-09-23', 'Expired stock'),
(7, '2026-09-24', 'Unsold stock'),
(8, '2026-09-24', 'Damaged packaging'),
(9, '2026-09-25', 'Unsold stock'),
(10, '2026-09-25', 'Unsold stock'),
(11, '2026-09-26', 'Unsold stock'),
(12, '2026-09-26', 'Unsold stock');

INSERT INTO return_items
(return_id, product_id, quantity_returned)
VALUES
(1, 1, 10),
(1, 3, 5),
(2, 1, 12),
(2, 4, 8),
(3, 2, 10),
(3, 5, 3),
(4, 1, 30),
(4, 3, 12),
(5, 2, 8),
(5, 6, 5),
(6, 1, 25),
(6, 4, 10),
(7, 1, 15),
(7, 5, 4),
(8, 2, 12),
(8, 4, 10),
(9, 1, 8),
(9, 7, 5),
(10, 2, 20),
(10, 8, 8),
(11, 1, 18),
(11, 3, 7),
(12, 2, 10),
(12, 4, 12);

INSERT INTO invoices
(invoice_number, outlet_id, invoice_date, due_date, net_amount, payment_status)
VALUES
('INV-1001', 1, '2026-09-21', '2026-10-05', 5200.00, 'Paid'),
('INV-1002', 2, '2026-09-21', '2026-10-05', 4800.00, 'Unpaid'),
('INV-1003', 3, '2026-09-22', '2026-10-06', 6900.00, 'Paid'),
('INV-1004', 4, '2026-09-22', '2026-10-06', 7500.00, 'Unpaid'),
('INV-1005', 5, '2026-09-23', '2026-10-07', 6100.00, 'Paid'),
('INV-1006', 6, '2026-09-23', '2026-10-07', 5800.00, 'Partially Paid'),
('INV-1007', 7, '2026-09-24', '2026-10-08', 7200.00, 'Paid'),
('INV-1008', 8, '2026-09-24', '2026-10-08', 6300.00, 'Unpaid'),
('INV-1009', 9, '2026-09-25', '2026-10-09', 5400.00, 'Paid'),
('INV-1010', 10, '2026-09-25', '2026-10-09', 5900.00, 'Unpaid'),
('INV-1011', 11, '2026-09-26', '2026-10-10', 8200.00, 'Paid'),
('INV-1012', 12, '2026-09-26', '2026-10-10', 7100.00, 'Unpaid');
