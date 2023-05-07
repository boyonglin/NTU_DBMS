/***** use database *****/
USE DB_class;

/***** info *****/
DROP TABLE IF EXISTS self;
CREATE TABLE self (
    StuID varchar(10) NOT NULL,
    Department varchar(10) NOT NULL,
    SchoolYear int DEFAULT 1,
    Name varchar(10) NOT NULL,
    PRIMARY KEY (StuID)
);

INSERT INTO self
VALUES ('r10945002', '生醫電資所', 1, '林柏詠');

SELECT DATABASE();
SELECT * FROM self;

/* Prepared statement */
PREPARE stmt FROM "SELECT * FROM students WHERE department = ?";
SET @department = '生醫電資所';
EXECUTE stmt USING @department;
SET @department = '心理系';
EXECUTE stmt USING @department;

/* Stored-function */
DELIMITER //
DROP FUNCTION IF EXISTS get_chinese_name//
CREATE FUNCTION get_chinese_name(name VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE ch_name VARCHAR(255);
    SET ch_name = TRIM(SUBSTRING_INDEX(name, '(', 1));
    RETURN ch_name;
END//

DROP FUNCTION IF EXISTS get_english_name//
CREATE FUNCTION get_english_name(name VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE en_name VARCHAR(255);
    SET en_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(name, '(', -1), ')', 1));
    RETURN en_name;
END//
DELIMITER ;

SELECT get_chinese_name(name) AS ch_name, get_english_name(name) AS en_name
FROM students
WHERE final_group = '8';

/* Stored procedure */
DELIMITER //
DROP PROCEDURE IF EXISTS get_student_count//
CREATE PROCEDURE get_student_count(IN department_name VARCHAR(255), OUT st_count INT)
BEGIN
  SELECT COUNT(*) INTO st_count FROM students WHERE department = department_name;
END//
DELIMITER ;

SET @STCOUNT = 0;
CALL get_student_count('生醫電資所', @STCOUNT);
SELECT @STCOUNT AS student_count;
CALL get_student_count('心理系', @STCOUNT);
SELECT @STCOUNT AS student_count;
 
/* Trigger I  */
DELIMITER //
DROP TRIGGER IF EXISTS count_captains//
CREATE TRIGGER count_captains
AFTER UPDATE ON students
FOR EACH ROW
BEGIN
    IF NEW.final_captain = 'Y' THEN
        SET @NUMCAPS = @NUMCAPS + 1;
    END IF;
END//
DELIMITER ;

SET @NUMCAPS = (SELECT COUNT(*) FROM students WHERE final_captain = 'Y');
UPDATE students SET final_captain = 'Y' WHERE final_captain = '0' ORDER BY rand() LIMIT 5;
SELECT * FROM students WHERE final_captain = 'Y';
SELECT @NUMCAPS AS 'Total number of captains';

/* Trigger II */
DROP TABLE IF EXISTS students_record;
CREATE TABLE students_record (
  user VARCHAR(255),
  action_type VARCHAR(10),
  action_time DATETIME
);

DELIMITER //
DROP TRIGGER IF EXISTS students_trigger_insert//
CREATE TRIGGER students_trigger_insert
AFTER INSERT ON students
FOR EACH ROW
BEGIN
  INSERT INTO students_record (user, action_type, action_time)
  VALUES (USER(), 'insert', NOW());
END//

DROP TRIGGER IF EXISTS students_trigger_delete//
CREATE TRIGGER students_trigger_delete
AFTER DELETE ON students
FOR EACH ROW
BEGIN
  INSERT INTO students_record (user, action_type, action_time)
  VALUES (USER(), 'delete', NOW());
END//
DELIMITER ;

SELECT * FROM students_record;

INSERT INTO students VALUES
('外送員', 'Uber Eats', 2, 'U09987654', '吳柏毅', 'u09987654@ntu.edu.tw', '資料庫系統-從SQL到NoSQL (EE5178)', 0, '0'),
('外送員', 'Foodpanda', 2, 'F09945678', '富胖達', 'f09987654@ntu.edu.tw', '資料庫系統-從SQL到NoSQL (EE5178)', 0, '0');

DELETE FROM students WHERE stuID = 'F09945678';

SELECT * FROM students_record;

/* drop database */
DROP DATABASE DB_class;