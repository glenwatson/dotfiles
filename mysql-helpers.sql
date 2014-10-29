DROP PROCEDURE me.tf;
DELIMITER //
CREATE PROCEDURE me.tf (table_part VARCHAR(512)) BEGIN
	SELECT table_schema, table_name FROM information_schema.tables WHERE table_name LIKE CONCAT('%', table_part, '%');
END//
DELIMITER ;
