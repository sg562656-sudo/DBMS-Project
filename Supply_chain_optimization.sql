CREATE DATABASE supply_chain_optimization;
USE supply_chain_optimization;
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    supplier_rating DECIMAL(3,2)
);
CREATE TABLE manufacturers (
    manufacturer_id INT AUTO_INCREMENT PRIMARY KEY,
    manufacturer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    contact_email VARCHAR(100) UNIQUE
);
CREATE TABLE distributors (
    distributor_id INT AUTO_INCREMENT PRIMARY KEY,
    distributor_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    phone VARCHAR(15)
);
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    manufacturer_id INT,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (manufacturer_id)
        REFERENCES manufacturers(manufacturer_id),
    CHECK (unit_price >= 0)
);
CREATE TABLE warehouses (
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    capacity INT NOT NULL,
    CHECK (capacity > 0)
);
CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity_on_hand INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL,
    last_updated DATE,
    FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id),
    UNIQUE (warehouse_id, product_id),
    CHECK (quantity_on_hand >= 0),
    CHECK (reorder_level >= 0)
);
CREATE TABLE purchase_orders (
    po_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    order_date DATE NOT NULL,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    order_status VARCHAR(30) NOT NULL,
    FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id),
    FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id)
);
CREATE TABLE purchase_order_items (
    po_item_id INT AUTO_INCREMENT PRIMARY KEY,
    po_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity_ordered INT NOT NULL,
    quantity_received INT DEFAULT 0,
    unit_cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (po_id)
        REFERENCES purchase_orders(po_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id),
    CHECK (quantity_ordered > 0),
    CHECK (quantity_received >= 0),
    CHECK (unit_cost >= 0)
);
CREATE TABLE inventory_movements (
    movement_id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_id INT NOT NULL,
    product_id INT NOT NULL,
    movement_type VARCHAR(20) NOT NULL,
    quantity INT NOT NULL,
    movement_date DATE NOT NULL,
    FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id),
    CHECK (quantity > 0)
);
CREATE TABLE shipments (
    shipment_id INT AUTO_INCREMENT PRIMARY KEY,
    po_id INT NOT NULL,
    distributor_id INT,
    shipment_date DATE,
    delivery_date DATE,
    transportation_cost DECIMAL(10,2),
    shipment_status VARCHAR(30),
    FOREIGN KEY (po_id)
        REFERENCES purchase_orders(po_id),
    FOREIGN KEY (distributor_id)
        REFERENCES distributors(distributor_id),
    CHECK (transportation_cost >= 0)
);
SHOW TABLES;
INSERT INTO suppliers
(supplier_name, contact_person, phone, email, city, supplier_rating)
VALUES
('ABC Components', 'Rahul Sharma', '9876543210', 'abc@gmail.com', 'Delhi', 4.50),
('Global Supplies', 'Amit Verma', '9876543211', 'global@gmail.com', 'Mumbai', 4.20),
('Prime Distributors', 'Neha Kapoor', '9876543212', 'prime@gmail.com', 'Pune', 4.70),
('Reliable Traders', 'Karan Mehta', '9876543213', 'reliable@gmail.com', 'Jaipur', 3.90);
INSERT INTO manufacturers
(manufacturer_name, city, contact_email)
VALUES
('Tech Manufacturing Ltd', 'Delhi', 'tech@gmail.com'),
('Smart Industries', 'Mumbai', 'smart@gmail.com'),
('Advanced Products Co', 'Pune', 'advanced@gmail.com');
INSERT INTO distributors
(distributor_name, city, phone)
VALUES
('FastTrack Logistics', 'Delhi', '9811111111'),
('Express Delivery', 'Mumbai', '9822222222'),
('QuickMove Transport', 'Pune', '9833333333');
INSERT INTO products
(product_name, manufacturer_id, unit_price)
VALUES
('Laptop', 1, 55000.00),
('Wireless Mouse', 2, 800.00),
('Keyboard', 2, 1500.00),
('Monitor', 3, 12000.00),
('Headphones', 1, 2500.00);
INSERT INTO warehouses
(warehouse_name, location, capacity)
VALUES
('Central Warehouse', 'Delhi', 10000),
('Western Warehouse', 'Mumbai', 8000),
('Southern Warehouse', 'Pune', 6000);
INSERT INTO inventory
(warehouse_id, product_id, quantity_on_hand, reorder_level, last_updated)
VALUES
(1, 1, 20, 30, '2026-11-01'),
(1, 2, 150, 50, '2026-11-01'),
(1, 3, 25, 40, '2026-11-01'),
(2, 1, 15, 25, '2026-11-02'),
(2, 4, 60, 30, '2026-11-02'),
(2, 5, 10, 20, '2026-11-02'),
(3, 2, 35, 40, '2026-11-03'),
(3, 3, 80, 30, '2026-11-03');
INSERT INTO purchase_orders
(supplier_id, warehouse_id, order_date, expected_delivery_date,
 actual_delivery_date, order_status)
VALUES
(1, 1, '2026-10-20', '2026-10-25', '2026-10-24', 'Delivered'),
(2, 1, '2026-10-28', '2026-11-05', NULL, 'Pending'),
(3, 2, '2026-10-22', '2026-10-29', '2026-10-30', 'Delivered'),
(4, 2, '2026-11-01', '2026-11-10', NULL, 'In Transit'),
(1, 3, '2026-11-02', '2026-11-12', NULL, 'Pending');
INSERT INTO purchase_order_items
(po_id, product_id, quantity_ordered, quantity_received, unit_cost)
VALUES
(1, 1, 50, 50, 50000.00),
(1, 2, 100, 100, 700.00),
(2, 3, 80, 0, 1300.00),
(3, 4, 40, 40, 11000.00),
(4, 5, 60, 30, 2200.00),
(5, 2, 100, 0, 700.00),
(5, 3, 50, 0, 1300.00);
INSERT INTO inventory_movements
(warehouse_id, product_id, movement_type, quantity, movement_date)
VALUES
(1, 1, 'IN', 50, '2026-10-20'),
(1, 1, 'OUT', 20, '2026-10-22'),
(1, 1, 'OUT', 10, '2026-10-25'),
(1, 2, 'IN', 100, '2026-10-21'),
(1, 2, 'OUT', 30, '2026-10-23'),
(2, 4, 'IN', 40, '2026-10-22'),
(2, 4, 'OUT', 15, '2026-10-25'),
(2, 5, 'OUT', 10, '2026-11-02');
INSERT INTO shipments
(po_id, distributor_id, shipment_date, delivery_date,
 transportation_cost, shipment_status)
VALUES
(1, 1, '2026-10-20', '2026-10-24', 2500.00, 'Delivered'),
(2, 2, '2026-10-29', NULL, 1800.00, 'In Transit'),
(3, 3, '2026-10-23', '2026-10-30', 2200.00, 'Delivered'),
(4, 1, '2026-11-02', NULL, 1500.00, 'In Transit'),
(5, 2, '2026-11-03', NULL, 2000.00, 'Pending');
SELECT 'suppliers' AS table_name, COUNT(*) AS total_records FROM suppliers
UNION ALL
SELECT 'manufacturers', COUNT(*) FROM manufacturers
UNION ALL
SELECT 'distributors', COUNT(*) FROM distributors
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'warehouses', COUNT(*) FROM warehouses
UNION ALL
SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL
SELECT 'purchase_orders', COUNT(*) FROM purchase_orders
UNION ALL
SELECT 'purchase_order_items', COUNT(*) FROM purchase_order_items
UNION ALL
SELECT 'inventory_movements', COUNT(*) FROM inventory_movements
UNION ALL
SELECT 'shipments', COUNT(*) FROM shipments;
# Display complete inventory details
SELECT
    w.warehouse_name,
    p.product_name,
    i.quantity_on_hand,
    i.reorder_level,
    i.last_updated
FROM inventory i
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
JOIN products p
    ON i.product_id = p.product_id
ORDER BY w.warehouse_id, p.product_id;
# Identify products below their reorder level
SELECT
    w.warehouse_name,
    p.product_name,
    i.quantity_on_hand,
    i.reorder_level
FROM inventory i
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
JOIN products p
    ON i.product_id = p.product_id
WHERE i.quantity_on_hand < i.reorder_level
ORDER BY i.quantity_on_hand;
#Calculate pending quantities from purchase orders
SELECT
    po.po_id,
    s.supplier_name,
    p.product_name,
    po.order_status,
    poi.quantity_ordered,
    poi.quantity_received,
    (poi.quantity_ordered - poi.quantity_received) AS pending_quantity
FROM purchase_orders po
JOIN suppliers s
    ON po.supplier_id = s.supplier_id
JOIN purchase_order_items poi
    ON po.po_id = poi.po_id
JOIN products p
    ON poi.product_id = p.product_id
WHERE po.order_status IN ('Pending', 'In Transit')
  AND poi.quantity_ordered > poi.quantity_received
ORDER BY po.po_id;
# Calculate total inventory value in each warehouse
SELECT
    w.warehouse_name,
    SUM(i.quantity_on_hand) AS total_units,
    SUM(i.quantity_on_hand * p.unit_price) AS total_inventory_value
FROM inventory i
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
JOIN products p
    ON i.product_id = p.product_id
GROUP BY w.warehouse_id, w.warehouse_name
ORDER BY total_inventory_value DESC;
# Calculate the recommended replenishment quantity
SELECT
    w.warehouse_name,
    p.product_name,
    i.quantity_on_hand,
    i.reorder_level,
    GREATEST(i.reorder_level - i.quantity_on_hand, 0)
        AS recommended_replenishment
FROM inventory i
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
JOIN products p
    ON i.product_id = p.product_id
ORDER BY w.warehouse_id, p.product_id;

#reducing transportation costs and improving order fulfillment

#Calculate total transportation cost by distributor
SELECT
    d.distributor_name,
    COUNT(s.shipment_id) AS total_shipments,
    SUM(s.transportation_cost) AS total_transportation_cost
FROM shipments s
JOIN distributors d
    ON s.distributor_id = d.distributor_id
GROUP BY d.distributor_id, d.distributor_name
ORDER BY total_transportation_cost DESC;

#Identify the most expensive shipments
SELECT
    s.shipment_id,
    d.distributor_name,
    s.po_id,
    s.transportation_cost,
    s.shipment_status
FROM shipments s
JOIN distributors d
    ON s.distributor_id = d.distributor_id
ORDER BY s.transportation_cost DESC;

# Calculate total transportation expenditure
SELECT
    COUNT(*) AS total_shipments,
    SUM(transportation_cost) AS total_transportation_cost,
    AVG(transportation_cost) AS average_transportation_cost
FROM shipments;

# Order fulfillment and supplier performance

#Display purchase order fulfillment status

SELECT
    po.po_id,
    s.supplier_name,
    po.order_date,
    po.expected_delivery_date,
    po.actual_delivery_date,
    po.order_status
FROM purchase_orders po
JOIN suppliers s
    ON po.supplier_id = s.supplier_id
ORDER BY po.po_id;

# Calculate supplier on-time delivery percentage
SELECT
    s.supplier_name,
    COUNT(po.po_id) AS delivered_orders,
    SUM(
        CASE
            WHEN po.actual_delivery_date <= po.expected_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS on_time_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN po.actual_delivery_date <= po.expected_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(po.po_id),
        2
    ) AS on_time_delivery_percentage
FROM suppliers s
JOIN purchase_orders po
    ON s.supplier_id = po.supplier_id
WHERE po.order_status = 'Delivered'
GROUP BY s.supplier_id, s.supplier_name
ORDER BY on_time_delivery_percentage DESC;

#Calculate average supplier delivery lead time
SELECT
    s.supplier_name,
    COUNT(po.po_id) AS delivered_orders,
    ROUND(
        AVG(DATEDIFF(
            po.actual_delivery_date,
            po.order_date
        )),
        2
    ) AS average_lead_time_days
FROM suppliers s
JOIN purchase_orders po
    ON s.supplier_id = po.supplier_id
WHERE po.actual_delivery_date IS NOT NULL
GROUP BY s.supplier_id, s.supplier_name
ORDER BY average_lead_time_days ASC;

#Identify pending order quantities
SELECT
    po.po_id,
    s.supplier_name,
    p.product_name,
    poi.quantity_ordered,
    poi.quantity_received,
    (poi.quantity_ordered - poi.quantity_received)
        AS remaining_quantity,
    po.order_status
FROM purchase_orders po
JOIN suppliers s
    ON po.supplier_id = s.supplier_id
JOIN purchase_order_items poi
    ON po.po_id = poi.po_id
JOIN products p
    ON poi.product_id = p.product_id
WHERE poi.quantity_received < poi.quantity_ordered
ORDER BY remaining_quantity DESC;

# Calculate overall order fulfillment percentage

SELECT
    SUM(quantity_ordered) AS total_units_ordered,
    SUM(quantity_received) AS total_units_received,
    ROUND(
        100.0 * SUM(quantity_received) /
        SUM(quantity_ordered),
        2
    ) AS fulfillment_percentage
FROM purchase_order_items;

# Indexing and query optimization

#Check query execution plan before indexing
EXPLAIN
SELECT
    warehouse_id,
    product_id,
    quantity_on_hand,
    reorder_level
FROM inventory
WHERE quantity_on_hand < reorder_level;

#Create a composite index on inventory
CREATE INDEX idx_inventory_warehouse_product
ON inventory (warehouse_id, product_id);

# Create a composite index on purchase orders
CREATE INDEX idx_po_supplier_status_delivery
ON purchase_orders
(supplier_id, order_status, expected_delivery_date);

# Create a covering index for the stock-out report
CREATE INDEX idx_inventory_stockout_report
ON inventory
(warehouse_id, product_id, quantity_on_hand, reorder_level);

#Display the indexes created
SHOW INDEX FROM inventory;

#Display purchase order indexes
SHOW INDEX FROM purchase_orders;

#Check query execution plan after indexing
EXPLAIN
SELECT
    warehouse_id,
    product_id,
    quantity_on_hand,
    reorder_level
FROM inventory
WHERE quantity_on_hand < reorder_level;

#Create and use views

# Create a low-stock alert view

CREATE OR REPLACE VIEW vw_low_stock_alert AS
SELECT
    w.warehouse_name,
    p.product_name,
    i.quantity_on_hand,
    i.reorder_level,
    COALESCE(
        (
            SELECT SUM(
                poi.quantity_ordered - poi.quantity_received
            )
            FROM purchase_orders po
            JOIN purchase_order_items poi
                ON po.po_id = poi.po_id
            WHERE po.warehouse_id = i.warehouse_id
              AND poi.product_id = i.product_id
              AND po.order_status IN ('Pending', 'In Transit')
              AND poi.quantity_ordered > poi.quantity_received
        ),
        0
    ) AS pending_po_quantity,
    i.quantity_on_hand +
    COALESCE(
        (
            SELECT SUM(
                poi.quantity_ordered - poi.quantity_received
            )
            FROM purchase_orders po
            JOIN purchase_order_items poi
                ON po.po_id = poi.po_id
            WHERE po.warehouse_id = i.warehouse_id
              AND poi.product_id = i.product_id
              AND po.order_status IN ('Pending', 'In Transit')
              AND poi.quantity_ordered > poi.quantity_received
        ),
        0
    ) AS projected_stock
FROM inventory i
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
JOIN products p
    ON i.product_id = p.product_id
WHERE i.quantity_on_hand < i.reorder_level;

# Display the low-stock alert report

SELECT *
FROM vw_low_stock_alert
ORDER BY warehouse_name, product_name;

#Create the supplier scorecard view

CREATE OR REPLACE VIEW vw_supplier_scorecard AS
SELECT
    s.supplier_id,
    s.supplier_name,

    COALESCE(ds.total_delivered_orders, 0)
        AS total_delivered_orders,

    COALESCE(ds.on_time_orders, 0)
        AS on_time_orders,

    COALESCE(
        ROUND(
            100.0 * ds.on_time_orders /
            NULLIF(ds.total_delivered_orders, 0),
            2
        ),
        0
    ) AS on_time_delivery_percentage,

    COALESCE(ds.average_lead_time_days, 0)
        AS average_lead_time_days,

    COALESCE(ls.total_order_lines, 0)
        AS total_order_lines,

    COALESCE(ls.short_received_lines, 0)
        AS short_received_lines,

    COALESCE(
        ROUND(
            100.0 * ls.short_received_lines /
            NULLIF(ls.total_order_lines, 0),
            2
        ),
        0
    ) AS short_shipment_rate_percentage

FROM suppliers s

LEFT JOIN (
    SELECT
        supplier_id,
        COUNT(*) AS total_delivered_orders,
        SUM(
            CASE
                WHEN actual_delivery_date <= expected_delivery_date
                THEN 1 ELSE 0
            END
        ) AS on_time_orders,
        ROUND(
            AVG(
                DATEDIFF(actual_delivery_date, order_date)
            ),
            2
        ) AS average_lead_time_days
    FROM purchase_orders
    WHERE order_status = 'Delivered'
      AND actual_delivery_date IS NOT NULL
    GROUP BY supplier_id
) ds
    ON s.supplier_id = ds.supplier_id

LEFT JOIN (
    SELECT
        po.supplier_id,
        COUNT(*) AS total_order_lines,
        SUM(
            CASE
                WHEN poi.quantity_received < poi.quantity_ordered
                THEN 1 ELSE 0
            END
        ) AS short_received_lines
    FROM purchase_orders po
    JOIN purchase_order_items poi
        ON po.po_id = poi.po_id
    GROUP BY po.supplier_id
) ls
    ON s.supplier_id = ls.supplier_id;

# Display supplier scorecards  
SELECT *
FROM vw_supplier_scorecard
ORDER BY on_time_delivery_percentage DESC;  

# Check whether the views are updatable
SELECT
    TABLE_NAME,
    IS_UPDATABLE
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME IN (
      'vw_low_stock_alert',
      'vw_supplier_scorecard'
  );

# Rank primary and backup suppliers for each product  
SELECT
    product_name,
    supplier_name,
    average_lead_time_days,
    average_unit_cost,
    supplier_rank,
    CASE
        WHEN supplier_rank = 1 THEN 'Primary Supplier'
        WHEN supplier_rank = 2 THEN 'Backup Supplier'
        ELSE 'Other Supplier'
    END AS supplier_category
FROM (
    SELECT
        product_id,
        product_name,
        supplier_name,
        average_lead_time_days,
        average_unit_cost,
        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY average_lead_time_days, average_unit_cost
        ) AS supplier_rank
    FROM (
        SELECT
            p.product_id,
            p.product_name,
            s.supplier_name,
            AVG(
                DATEDIFF(po.actual_delivery_date, po.order_date)
            ) AS average_lead_time_days,
            AVG(poi.unit_cost) AS average_unit_cost
        FROM purchase_orders po
        JOIN purchase_order_items poi
            ON po.po_id = poi.po_id
        JOIN suppliers s
            ON po.supplier_id = s.supplier_id
        JOIN products p
            ON poi.product_id = p.product_id
        WHERE po.order_status = 'Delivered'
          AND po.actual_delivery_date IS NOT NULL
        GROUP BY
            p.product_id,
            p.product_name,
            s.supplier_id,
            s.supplier_name
    ) supplier_metrics
) ranked_suppliers
WHERE supplier_rank <= 2
ORDER BY product_name, supplier_rank;

#Calculate running inventory levels using SUM() OVER()
WITH movement_balances AS (
    SELECT
        movement_id,
        warehouse_id,
        product_id,
        movement_date,
        CASE
            WHEN movement_type = 'IN' THEN quantity
            ELSE -quantity
        END AS net_change
    FROM inventory_movements
),
opening_balances AS (
    SELECT
        i.warehouse_id,
        i.product_id,
        i.quantity_on_hand -
            COALESCE(SUM(m.net_change), 0) AS opening_quantity
    FROM inventory i
    LEFT JOIN movement_balances m
        ON i.warehouse_id = m.warehouse_id
       AND i.product_id = m.product_id
    GROUP BY
        i.warehouse_id,
        i.product_id,
        i.quantity_on_hand
)
SELECT
    w.warehouse_name,
    p.product_name,
    m.movement_date,
    m.net_change,
    ob.opening_quantity +
        SUM(m.net_change) OVER (
            PARTITION BY m.warehouse_id, m.product_id
            ORDER BY m.movement_date, m.movement_id
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS running_stock
FROM movement_balances m
JOIN opening_balances ob
    ON m.warehouse_id = ob.warehouse_id
   AND m.product_id = ob.product_id
JOIN warehouses w
    ON m.warehouse_id = w.warehouse_id
JOIN products p
    ON m.product_id = p.product_id
ORDER BY
    w.warehouse_name,
    p.product_name,
    m.movement_date;

#Identify stock-out dates  
WITH movement_balances AS (
    SELECT
        movement_id,
        warehouse_id,
        product_id,
        movement_date,
        CASE
            WHEN movement_type = 'IN' THEN quantity
            ELSE -quantity
        END AS net_change
    FROM inventory_movements
),
opening_balances AS (
    SELECT
        i.warehouse_id,
        i.product_id,
        i.quantity_on_hand -
            COALESCE(SUM(m.net_change), 0) AS opening_quantity
    FROM inventory i
    LEFT JOIN movement_balances m
        ON i.warehouse_id = m.warehouse_id
       AND i.product_id = m.product_id
    GROUP BY
        i.warehouse_id,
        i.product_id,
        i.quantity_on_hand
),
running_balances AS (
    SELECT
        m.warehouse_id,
        m.product_id,
        m.movement_date,
        ob.opening_quantity +
            SUM(m.net_change) OVER (
                PARTITION BY m.warehouse_id, m.product_id
                ORDER BY m.movement_date, m.movement_id
                ROWS BETWEEN UNBOUNDED PRECEDING
                AND CURRENT ROW
            ) AS running_stock
    FROM movement_balances m
    JOIN opening_balances ob
        ON m.warehouse_id = ob.warehouse_id
       AND m.product_id = ob.product_id
)
SELECT
    w.warehouse_name,
    p.product_name,
    MIN(
        CASE
            WHEN rb.running_stock <= 0
            THEN rb.movement_date
        END
    ) AS stockout_date
FROM running_balances rb
JOIN warehouses w
    ON rb.warehouse_id = w.warehouse_id
JOIN products p
    ON rb.product_id = p.product_id
GROUP BY
    rb.warehouse_id,
    rb.product_id,
    w.warehouse_name,
    p.product_name
HAVING stockout_date IS NOT NULL;  
# Calculate days between consecutive replenishments using LEAD()
SELECT
    s.supplier_name,
    po.po_id,
    po.expected_delivery_date AS current_replenishment_date,
    LEAD(po.expected_delivery_date) OVER (
        PARTITION BY po.supplier_id
        ORDER BY po.expected_delivery_date
    ) AS next_replenishment_date,
    DATEDIFF(
        LEAD(po.expected_delivery_date) OVER (
            PARTITION BY po.supplier_id
            ORDER BY po.expected_delivery_date
        ),
        po.expected_delivery_date
    ) AS days_between_replenishments
FROM purchase_orders po
JOIN suppliers s
    ON po.supplier_id = s.supplier_id
ORDER BY
    s.supplier_name,
    po.expected_delivery_date;
    