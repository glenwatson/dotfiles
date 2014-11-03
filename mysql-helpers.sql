CREATE SCHEMA IF NOT EXISTS me;

-- table find
DROP PROCEDURE IF EXISTS me.tf;
DELIMITER //
CREATE PROCEDURE me.tf (table_part VARCHAR(512)) BEGIN
    SELECT table_schema, table_name 
        FROM information_schema.tables 
        WHERE table_name LIKE CONCAT('%', table_part, '%')
        ORDER BY table_name, table_schema;
END//
DELIMITER ;

-- column find
DROP PROCEDURE IF EXISTS me.cf;
DELIMITER //
CREATE PROCEDURE me.cf (column_part VARCHAR(512)) BEGIN
    SELECT table_schema, table_name, column_name, data_type, ordinal_position, is_nullable, column_default 
        FROM information_schema.columns 
        WHERE column_name LIKE CONCAT('%', column_part, '%')
        ORDER BY column_name, table_name, table_schema;
END//
DELIMITER ;
