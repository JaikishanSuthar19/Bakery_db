-- Bakery Wholesale Distribution Route Database
-- Database: new_bakery_distribution
-- File: schema.sql

-- Run this file in a new/empty database.
-- It creates the complete database structure.

CREATE TABLE routes (
    route_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    route_code VARCHAR(20) NOT NULL UNIQUE,
    route_name VARCHAR(100) NOT NULL,
    delivery_day VARCHAR(10) NOT NULL,
    start_area VARCHAR(100) NOT NULL,
    CONSTRAINT chk_route_day
        CHECK (delivery_day IN (
            'Monday', 'Tuesday', 'Wednesday',
            'Thursday', 'Friday', 'Saturday'
        ))
);

CREATE TABLE outlets (
    outlet_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    outlet_code VARCHAR(20) NOT NULL UNIQUE,
    outlet_name VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    route_id INTEGER NOT NULL,
    CONSTRAINT fk_outlet_route
        FOREIGN KEY (route_id)
        REFERENCES routes(route_id)
        ON DELETE RESTRICT
);

CREATE TABLE products (
    product_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_code VARCHAR(20) NOT NULL UNIQUE,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    shelf_life_days INTEGER NOT NULL,
    CONSTRAINT chk_product_price CHECK (unit_price > 0),
    CONSTRAINT chk_shelf_life CHECK (shelf_life_days > 0)
);

CREATE TABLE deliveries (
    delivery_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    outlet_id INTEGER NOT NULL,
    route_id INTEGER,
    delivery_date DATE NOT NULL,
    delivery_status VARCHAR(20) NOT NULL DEFAULT 'Delivered',
    CONSTRAINT fk_delivery_outlet
        FOREIGN KEY (outlet_id)
        REFERENCES outlets(outlet_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_delivery_route
        FOREIGN KEY (route_id)
        REFERENCES routes(route_id)
        ON DELETE SET NULL,
    CONSTRAINT chk_delivery_status
        CHECK (delivery_status IN ('Delivered', 'Cancelled'))
);

CREATE TABLE delivery_items (
    delivery_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity_delivered INTEGER NOT NULL,
    CONSTRAINT pk_delivery_items
        PRIMARY KEY (delivery_id, product_id),
    CONSTRAINT fk_delivery_item_delivery
        FOREIGN KEY (delivery_id)
        REFERENCES deliveries(delivery_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_delivery_item_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_delivery_quantity
        CHECK (quantity_delivered > 0)
);

CREATE TABLE returns (
    return_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    delivery_id INTEGER NOT NULL,
    return_date DATE NOT NULL DEFAULT CURRENT_DATE,
    return_reason VARCHAR(100),
    CONSTRAINT fk_return_delivery
        FOREIGN KEY (delivery_id)
        REFERENCES deliveries(delivery_id)
        ON DELETE CASCADE
);

CREATE TABLE return_items (
    return_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity_returned INTEGER NOT NULL,
    CONSTRAINT pk_return_items
        PRIMARY KEY (return_id, product_id),
    CONSTRAINT fk_return_item_return
        FOREIGN KEY (return_id)
        REFERENCES returns(return_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_return_item_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_return_quantity
        CHECK (quantity_returned > 0)
);

CREATE TABLE invoices (
    invoice_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    invoice_number VARCHAR(30) NOT NULL UNIQUE,
    outlet_id INTEGER NOT NULL,
    invoice_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    net_amount NUMERIC(12,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Unpaid',
    CONSTRAINT fk_invoice_outlet
        FOREIGN KEY (outlet_id)
        REFERENCES outlets(outlet_id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_invoice_amount CHECK (net_amount >= 0),
    CONSTRAINT chk_payment_status
        CHECK (payment_status IN ('Paid', 'Unpaid', 'Partially Paid')),
    CONSTRAINT chk_due_date
        CHECK (due_date >= invoice_date)
);
