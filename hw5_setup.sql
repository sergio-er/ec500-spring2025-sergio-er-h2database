DROP TABLE IF EXISTS order_payments;
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS suppliers;

CREATE TABLE suppliers (
                           supplier_id INT PRIMARY KEY,
                           name VARCHAR(100),
                           country VARCHAR(50)
);

CREATE TABLE products (
                          product_id INT PRIMARY KEY,
                          name VARCHAR(100),
                          price DECIMAL(10,2),
                          supplier_id INT,
                          FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE customers (
                           customer_id INT PRIMARY KEY,
                           name VARCHAR(100),
                           country VARCHAR(50)
);

CREATE TABLE orders (
                        order_id INT PRIMARY KEY,
                        customer_id INT,
                        order_date DATE,
                        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_details (
                               order_detail_id INT PRIMARY KEY,
                               order_id INT,
                               product_id INT,
                               quantity INT,
                               FOREIGN KEY (order_id) REFERENCES orders(order_id),
                               FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE order_payments (
                                payment_id INT PRIMARY KEY,
                                order_id INT,
                                payment_date DATE,
                                amount DECIMAL(10,2),
                                FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO customers (customer_id, name, country) VALUES
                                                       (1, 'alice', 'USA'), (2, 'bob', 'Canada'), (3, 'charlie', 'UK'),
                                                       (4, 'david', 'Germany'), (5, 'eve', 'France'), (6, 'frank', 'Italy'),
                                                       (7, 'grace', 'Spain'), (8, 'hank', 'Netherlands'), (9, 'ivy', 'Australia'),
                                                       (10, 'jack', 'Japan');

INSERT INTO orders (order_id, customer_id, order_date)
SELECT X, (X % 10) + 1, DATEADD('DAY', -X, CURRENT_DATE)
FROM SYSTEM_RANGE(1, 200);

INSERT INTO suppliers (supplier_id, name, country) VALUES
                                                       (1, 'global_supplies', 'USA'), (2, 'euro_mart', 'Germany'), (3, 'asian_traders', 'Japan'),
                                                       (4, 'aussie_goods', 'Australia'), (5, 'uk_wholesale', 'UK'),
                                                       (6, 'canada_supply', 'Canada'), (7, 'french_distributors', 'France'),
                                                       (8, 'italy_market', 'Italy'), (9, 'spanish_exports', 'Spain'),
                                                       (10, 'dutch_providers', 'Netherlands'), (11, 'nordic_supplies', 'Sweden'),
                                                       (12, 'eastern_distributors', 'China'), (13, 'south_american_goods', 'Brazil'),
                                                       (14, 'middle_east_traders', 'UAE'), (15, 'african_wholesale', 'South Africa');



INSERT INTO products (product_id, name, price, supplier_id) VALUES
                                                                (1, 'product_1', 12.99, 1), (2, 'product_2', 45.50, 2), (3, 'product_3', 23.75, 3),
                                                                (4, 'product_4', 19.90, 4), (5, 'product_5', 5.99, 5), (6, 'product_6', 33.33, 6),
                                                                (7, 'product_7', 29.99, 7), (8, 'product_8', 49.95, 8), (9, 'product_9', 15.00, 9),
                                                                (10, 'product_10', 8.99, 10), (11, 'product_11', 27.50, 11), (12, 'product_12', 39.99, 12),
                                                                (13, 'product_13', 22.45, 13), (14, 'product_14', 31.10, 14), (15, 'product_15', 9.99, 15),
                                                                (16, 'product_16', 14.50, 1), (17, 'product_17', 47.75, 2), (18, 'product_18', 18.20, 3),
                                                                (19, 'product_19', 5.55, 4), (20, 'product_20', 13.95, 5), (21, 'product_21', 34.80, 6),
                                                                (22, 'product_22', 30.20, 7), (23, 'product_23', 50.30, 8), (24, 'product_24', 16.75, 9),
                                                                (25, 'product_25', 7.60, 10), (26, 'product_26', 28.90, 11), (27, 'product_27', 38.25, 12),
                                                                (28, 'product_28', 21.80, 13), (29, 'product_29', 32.15, 14), (30, 'product_30', 10.25, 15),
                                                                (31, 'product_31', 13.10, 1), (32, 'product_32', 44.40, 2), (33, 'product_33', 19.75, 3),
                                                                (34, 'product_34', 9.90, 4), (35, 'product_35', 6.49, 5), (36, 'product_36', 35.99, 6),
                                                                (37, 'product_37', 27.99, 7), (38, 'product_38', 41.95, 8), (39, 'product_39', 18.50, 9),
                                                                (40, 'product_40', 11.99, 10), (41, 'product_41', 25.70, 11), (42, 'product_42', 37.99, 12),
                                                                (43, 'product_43', 24.45, 13), (44, 'product_44', 29.80, 14), (45, 'product_45', 8.99, 15),
                                                                (46, 'product_46', 17.50, 1), (47, 'product_47', 49.99, 2), (48, 'product_48', 20.20, 3),
                                                                (49, 'product_49', 6.55, 4), (50, 'product_50', 15.95, 5);



INSERT INTO order_details (order_detail_id, order_id, product_id, quantity)
SELECT X, (X % 200) + 1, (X % 50) + 1, (X % 10) + 1
FROM SYSTEM_RANGE(1, 500);

INSERT INTO order_payments (payment_id, order_id, payment_date, amount)
SELECT X, (X % 200) + 1, DATEADD('DAY', -X, CURRENT_DATE), ROUND(RAND() * 500, 2)
FROM SYSTEM_RANGE(1, 150);