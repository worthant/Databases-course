-- Кому интересно, сделал сложный пример, который затрагивает, наверное, все концепты, что у нас были и которые пригодятся для 1 и 2 лабы(и по приколу тоже, ради интереса посмотрите)
-- Вводные данные:

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  customer_id INTEGER,
  order_date DATE,
  location POINT
);

CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id),
  product_id INTEGER,
  price DECIMAL(10, 2),
  quantity INTEGER
);

-- Insert some sample data
INSERT INTO orders (customer_id, order_date, location)
VALUES (1, '2022-01-01', point '(1,1)'),
       (2, '2022-01-02', point '(2,2)'),
       (3, '2022-01-03', point '(3,3)');

INSERT INTO order_items (order_id, product_id, price, quantity)
VALUES (1, 1, 10.00, 5),
       (1, 2, 15.00, 2),
       (2, 1, 10.00, 3),
       (2, 3, 20.00, 1),
       (3, 2, 15.00, 4),
       (3, 3, 20.00, 2);

---------------------------------------------------------------------------------------------

-- Запрос:

WITH order_sums AS (
  SELECT
    order_id,
    SUM(price * quantity) AS total_price
  FROM order_items
  GROUP BY order_id
  HAVING AVG(price) > 12
),
filtered_orders AS (
  SELECT
    id,
    customer_id,
    order_date,
    CAST(location <-> point '(0, 0)' AS DECIMAL(10, 2)) AS distance
  FROM orders
  WHERE order_date BETWEEN '2022-01-01' AND '2022-01-31'
)
SELECT
  fo.customer_id,
  ARRAY[fo.order_date, os.total_price] AS order_info,
  fo.distance
FROM filtered_orders fo
JOIN order_sums os ON fo.id = os.order_id AND os.total_price::INTEGER @> ARRAY[50]
WHERE fo.distance <@ numrange(1.0, 3.0)
ORDER BY fo.distance DESC;

---------------------------------------------------------------------------------------------

-- Далее будут представлены запросы для моей модели, найти которую вы можете в этой же директории по ссылке в табличке

---------------------------------------------------------------------------------------------

-- This will output the execution plan for the query.

EXPLAIN SELECT * FROM human WHERE nationality = 'American';

---------------------------------------------------------------------------------------------

-- This will remove all data from the "human" table.

TRUNCATE TABLE human;

---------------------------------------------------------------------------------------------

-- For each ship, display it's quantity of antennas onboard and total power capacity for them

SELECT ship_type.ship_type, COUNT(antenna.id) AS antenna_count, SUM(antenna.power_capacity) AS total_power_capacity
FROM antenna
JOIN ship ON ship.ship_modules = antenna.id
JOIN ship_type ON ship.ship_type = ship_type.id
GROUP BY ship_type.ship_type;

---------------------------------------------------------------------------------------------

-- print total power capacity for each antenna module

SELECT id, SUM(power_capacity) as total_capacity FROM antenna GROUP BY id;

---------------------------------------------------------------------------------------------

-- This will insert a new row into the "human" table with the given values, or update the row with the same id if it already exists.

INSERT INTO human (id, name, surname, age, nationality, origin, place) 
VALUES (1, 'John', 'Doe', 25, 'American', 1, 1) 
ON CONFLICT (id) DO UPDATE SET 
name = excluded.name, 
surname = excluded.surname, 
age = excluded.age, 
nationality = excluded.nationality, 
origin = excluded.origin, 
place = excluded.place;

---------------------------------------------------------------------------------------------

-- This will update the age of the human with name 'John' and surname 'Doe' to 30.

UPDATE human SET age = 30 WHERE name = 'John' AND surname = 'Doe';

---------------------------------------------------------------------------------------------

-- CASCADE:
-- CASCADE can be used with the following commands: DELETE and UPDATE

-- This will delete the row with id=1 from the place table and all rows referencing it in other tables will be deleted as well.
DELETE FROM place WHERE id = 1 CASCADE;

-- This will update the city value in the human_origin table and all rows referencing the updated value in other tables will be updated with the new value as well.
UPDATE human_origin SET city = 'New York' WHERE city = 'Los Angeles' CASCADE;

---------------------------------------------------------------------------------------------

-- CONSTRAINT

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    department_id INTEGER NOT NULL REFERENCES departments(id),
    ...
    CONSTRAINT fk_department_name
        FOREIGN KEY (department_id, last_name)
        REFERENCES departments(id, name)
);

---------------------------------------------------------------------------------------------

-- SELECT
-- ascending, descengind, nulls first, nulls last;

SELECT * FROM human ORDER BY id ASC NULLS FIRST;
SELECT * FROM my_table ORDER BY my_column DESC;

---------------------------------------------------------------------------------------------

-- order by
SELECT name, age, nationality
FROM human
ORDER BY age DESC;


-- group by & join
SELECT h.nationality, COUNT(ht.troubles_id) AS total_troubles
FROM human h
JOIN human_troubles ht ON h.id = ht.human_id
GROUP BY h.nationality;

