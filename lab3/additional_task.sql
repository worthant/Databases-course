-- Доп: написать триггер, который будет выводить информацию об объекте, 
-- который был добавлен/удалён в табличку ship_type.
-- 

-- Удаляем существующие триггеры, если они существуют
DROP TRIGGER IF EXISTS ship_type_after_insert ON ship_type;
DROP TRIGGER IF EXISTS ship_type_before_delete ON ship_type;
DROP TRIGGER IF EXISTS ship_type_delete_cascade_trigger ON ship_type;

-- Доп: написать триггер, который будет выводить информацию об объекте, 
-- который был добавлен/удалён в табличку ship_type.
-- 

-- Удаляем существующие триггеры, если они существуют
DROP TRIGGER IF EXISTS ship_type_after_insert ON ship_type;
DROP TRIGGER IF EXISTS ship_type_before_delete ON ship_type;
DROP TRIGGER IF EXISTS ship_type_delete_cascade_trigger ON ship_type;

-- Создаем функцию, которая вызывается при вставке записи в таблицу ship_type
CREATE OR REPLACE FUNCTION ship_type_insert_trigger() RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'INSERT: Ship Type with ID %, Type %, Capacity %, Max Speed %, and Range % has been added.', NEW.id, NEW.ship_type, NEW.ship_capacity, NEW.max_speed, NEW.range;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создаем функцию, которая вызывается при удалении записи из таблицы ship_type
CREATE OR REPLACE FUNCTION ship_type_delete_trigger() RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'DELETE: Ship Type with ID %, Type %, Capacity %, Max Speed %, and Range % has been deleted.', OLD.id, OLD.ship_type, OLD.ship_capacity, OLD.max_speed, OLD.range;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Создаем триггер, который вызывает функцию ship_type_insert_trigger при вставке записи в таблицу ship_type
CREATE TRIGGER ship_type_after_insert
    AFTER INSERT ON ship_type
    FOR EACH ROW
    EXECUTE FUNCTION ship_type_insert_trigger();

-- Создаем триггер, который вызывает функцию ship_type_delete_trigger при удалении записи из таблицы ship_type
CREATE TRIGGER ship_type_before_delete
    BEFORE DELETE ON ship_type
    FOR EACH ROW
    EXECUTE FUNCTION ship_type_delete_trigger();

-- Создаем функцию, которая вызывается перед удалением записи из таблицы ship_type
CREATE OR REPLACE FUNCTION ship_type_delete_cascade() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM ship_troubles WHERE ship_id IN (SELECT id FROM ship WHERE ship_type = OLD.id);
    DELETE FROM ship WHERE ship_type = OLD.id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Создаем триггер, который вызывает функцию ship_type_delete_cascade при удалении записи из таблицы ship_type
CREATE TRIGGER ship_type_delete_cascade_trigger
    BEFORE DELETE ON ship_type
    FOR EACH ROW
    EXECUTE FUNCTION ship_type_delete_cascade();

---------------------------------------------------------------------------------------------

-- Давайте покажем функциональность написанных триггеров и процедурных функций

INSERT INTO ship_type (ship_type, ship_capacity, max_speed, range)
VALUES ('Cargo', 100, 400, 3000),
       ('Passenger', 200, 600, 5000);

DELETE FROM ship_type WHERE id = 1;
