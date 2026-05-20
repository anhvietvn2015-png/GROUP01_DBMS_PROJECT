-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema shopdb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `shopdb` ;

-- -----------------------------------------------------
-- Schema shopdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `shopdb` DEFAULT CHARACTER SET utf8 ;
USE `shopdb` ;

-- -----------------------------------------------------
-- Table `shopdb`.`PRODUCT`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopdb`.`PRODUCT` ;

CREATE TABLE IF NOT EXISTS `shopdb`.`PRODUCT` (
  `P_CODE` INT NOT NULL AUTO_INCREMENT,
  `P_DESCRIPT` VARCHAR(45) NOT NULL,
  `P_CATEGORY` ENUM('ACCESSORY', 'DEVICE', 'EQUIPMENT') NOT NULL,
  `P_INDATE` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `P_QOH` INT NOT NULL,
  `P_MIN` INT NOT NULL,
  `P_PRICE` DECIMAL(9,2) NOT NULL,
  `P_DISCOUNT` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`P_CODE`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `P_DESCRIPT_UNIQUE` ON `shopdb`.`PRODUCT` (`P_DESCRIPT` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `shopdb`.`INVENTORY_LOG`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopdb`.`INVENTORY_LOG` ;

CREATE TABLE IF NOT EXISTS `shopdb`.`INVENTORY_LOG` (
  `LOG_NUMBER` INT NOT NULL AUTO_INCREMENT,
  `P_CODE` INT NOT NULL,
  `LOG_TYPE` ENUM('RESTOCK', 'DAMAGED', 'GAIN', 'LOSS') NOT NULL,
  `LOG_DATE` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `LOG_UNITS` INT NOT NULL,
  PRIMARY KEY (`LOG_NUMBER`),
  CONSTRAINT `fk_inventory_product`
    FOREIGN KEY (`P_CODE`)
    REFERENCES `shopdb`.`PRODUCT` (`P_CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_idx` ON `shopdb`.`INVENTORY_LOG` (`P_CODE` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `shopdb`.`CUSTOMER`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopdb`.`CUSTOMER` ;

CREATE TABLE IF NOT EXISTS `shopdb`.`CUSTOMER` (
  `CUS_CODE` INT NOT NULL AUTO_INCREMENT,
  `CUS_LNAME` VARCHAR(10) NOT NULL,
  `CUS_PHONE_ENC` VARBINARY(255) NOT NULL,
  `CUS_PHONE_HASH` CHAR(64) NOT NULL,
  PRIMARY KEY (`CUS_CODE`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `CUS_PHONE_HASH_UNIQUE` ON `shopdb`.`CUSTOMER` (`CUS_PHONE_HASH` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `shopdb`.`EMPLOYEE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopdb`.`EMPLOYEE` ;

CREATE TABLE IF NOT EXISTS `shopdb`.`EMPLOYEE` (
  `EMP_CODE` INT NOT NULL AUTO_INCREMENT,
  `EMP_LNAME` VARCHAR(10) NOT NULL,
  `EMP_FNAME` VARCHAR(10) NOT NULL,
  `EMP_JOB` ENUM('STAFF', 'MANAGER') NOT NULL,
  `EMP_HIREDATE` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `EMP_ACTIVE` TINYINT NOT NULL DEFAULT 1,
  `EMP_PHONE_ENC` VARBINARY(255) NOT NULL,
  `EMP_PHONE_HASH` CHAR(64) NOT NULL,
  PRIMARY KEY (`EMP_CODE`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `EMP_PHONE_HASH_UNIQUE` ON `shopdb`.`EMPLOYEE` (`EMP_PHONE_HASH` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `shopdb`.`INVOICE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopdb`.`INVOICE` ;

CREATE TABLE IF NOT EXISTS `shopdb`.`INVOICE` (
  `INV_NUMBER` INT NOT NULL AUTO_INCREMENT,
  `INV_DATE` DATETIME NOT NULL DEFAULT NOW(),
  `INV_STATUS` ENUM('DRAFT', 'CANCELLED', 'PAID') NOT NULL DEFAULT 'DRAFT',
  `INV_TOTAL` DECIMAL(9,2) NOT NULL DEFAULT 0.00,
  `CUS_CODE` INT NOT NULL,
  `EMP_CODE` INT NOT NULL,
  PRIMARY KEY (`INV_NUMBER`),
  CONSTRAINT `fk_invoice_customer`
    FOREIGN KEY (`CUS_CODE`)
    REFERENCES `shopdb`.`CUSTOMER` (`CUS_CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_invoice_employee`
    FOREIGN KEY (`EMP_CODE`)
    REFERENCES `shopdb`.`EMPLOYEE` (`EMP_CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_invoice_customer_idx` ON `shopdb`.`INVOICE` (`CUS_CODE` ASC) VISIBLE;

CREATE INDEX `fk_invoice_employee_idx` ON `shopdb`.`INVOICE` (`EMP_CODE` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `shopdb`.`LINE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopdb`.`LINE` ;

CREATE TABLE IF NOT EXISTS `shopdb`.`LINE` (
  `LINE_NUMBER` INT NOT NULL,
  `INV_NUMBER` INT NOT NULL,
  `P_CODE` INT NOT NULL,
  `LINE_UNITS` INT NOT NULL,
  `LINE_PRICE` DECIMAL(9,2) NOT NULL,
  PRIMARY KEY (`INV_NUMBER`, `LINE_NUMBER`),
  CONSTRAINT `fk_line_product`
    FOREIGN KEY (`P_CODE`)
    REFERENCES `shopdb`.`PRODUCT` (`P_CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_line_invoice`
    FOREIGN KEY (`INV_NUMBER`)
    REFERENCES `shopdb`.`INVOICE` (`INV_NUMBER`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_line_product_idx` ON `shopdb`.`LINE` (`P_CODE` ASC) VISIBLE;

CREATE UNIQUE INDEX `uq_invoice_product_idx` ON `shopdb`.`LINE` (`INV_NUMBER` ASC, `P_CODE` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `shopdb`.`INVOICE_PAYMENT`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopdb`.`INVOICE_PAYMENT` ;

CREATE TABLE IF NOT EXISTS `shopdb`.`INVOICE_PAYMENT` (
  `INV_NUMBER` INT NOT NULL,
  `PAY_DATE` DATETIME NOT NULL DEFAULT NOW(),
  `PAY_TYPE` ENUM('CASH', 'BANK TRANSFER') NOT NULL,
  `PAY_REF` VARCHAR(100) NULL,
  `EMP_CODE` INT NOT NULL,
  PRIMARY KEY (`INV_NUMBER`),
  CONSTRAINT `fk_payment_employee`
    FOREIGN KEY (`EMP_CODE`)
    REFERENCES `shopdb`.`EMPLOYEE` (`EMP_CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_invoice`
    FOREIGN KEY (`INV_NUMBER`)
    REFERENCES `shopdb`.`INVOICE` (`INV_NUMBER`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_payment_employee_idx` ON `shopdb`.`INVOICE_PAYMENT` (`EMP_CODE` ASC) VISIBLE;

CREATE UNIQUE INDEX `PAY_REF_UNIQUE` ON `shopdb`.`INVOICE_PAYMENT` (`PAY_REF` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `shopdb`.`EMPLOYEE_ACCOUNT`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopdb`.`EMPLOYEE_ACCOUNT` ;

CREATE TABLE IF NOT EXISTS `shopdb`.`EMPLOYEE_ACCOUNT` (
  `EMP_CODE` INT NOT NULL,
  `EMP_USERNAME` VARCHAR(20) NOT NULL,
  `EMP_PASSWORD` CHAR(64) NOT NULL,
  `MUST_CHANGE_PASSWORD` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`EMP_CODE`),
  CONSTRAINT `fk_empaccount_employee`
    FOREIGN KEY (`EMP_CODE`)
    REFERENCES `shopdb`.`EMPLOYEE` (`EMP_CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `EMP_USERNAME_UNIQUE` ON `shopdb`.`EMPLOYEE_ACCOUNT` (`EMP_USERNAME` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `shopdb`.`PRODUCT_REVIEW`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopdb`.`PRODUCT_REVIEW` ;

CREATE TABLE IF NOT EXISTS `shopdb`.`PRODUCT_REVIEW` (
  `REV_NUMBER` INT NOT NULL AUTO_INCREMENT,
  `CUS_CODE` INT NOT NULL,
  `P_CODE` INT NOT NULL,
  `REV_RATING` TINYINT NOT NULL,
  `REV_COMMENT` VARCHAR(200) NULL,
  `REV_VALID` TINYINT NOT NULL,
  PRIMARY KEY (`REV_NUMBER`),
  CONSTRAINT `fk_review_product`
    FOREIGN KEY (`P_CODE`)
    REFERENCES `shopdb`.`PRODUCT` (`P_CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_review_customer`
    FOREIGN KEY (`CUS_CODE`)
    REFERENCES `shopdb`.`CUSTOMER` (`CUS_CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_review_product_idx` ON `shopdb`.`PRODUCT_REVIEW` (`P_CODE` ASC) VISIBLE;

CREATE INDEX `fk_review_customer_idx` ON `shopdb`.`PRODUCT_REVIEW` (`CUS_CODE` ASC) VISIBLE;

USE `shopdb` ;

-- -----------------------------------------------------
-- Placeholder table for view `shopdb`.`CUSTOMER_INVOICE_SUMMARY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shopdb`.`CUSTOMER_INVOICE_SUMMARY` (`CUS_CODE` INT, `CUS_LNAME` INT, `INV_NUMBER` INT, `INV_DATE` INT, `INV_STATUS` INT, `INV_TOTAL` INT, `EMP_CODE` INT);

-- -----------------------------------------------------
-- Placeholder table for view `shopdb`.`CUSTOMER_PURCHASE_SUMMARY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shopdb`.`CUSTOMER_PURCHASE_SUMMARY` (`CUS_CODE` INT, `CUS_LNAME` INT, `TOTAL_PAID_INVOICES` INT, `TOTAL_SPENDING` INT, `AVERAGE_SPENDING_PER_INVOICE` INT);

-- -----------------------------------------------------
-- Placeholder table for view `shopdb`.`MONTHLY_PRODUCT_SALES_SUMMARY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shopdb`.`MONTHLY_PRODUCT_SALES_SUMMARY` (`id` INT);

-- -----------------------------------------------------
-- Placeholder table for view `shopdb`.`YEARLY_PRODUCT_SALES_SUMMARY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shopdb`.`YEARLY_PRODUCT_SALES_SUMMARY` (`id` INT);

-- -----------------------------------------------------
-- Placeholder table for view `shopdb`.`MONTHLY_REVENUE_SUMMARY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shopdb`.`MONTHLY_REVENUE_SUMMARY` (`SALE_YEAR` INT, `SALE_MONTH` INT, `TOTAL_PAID_INVOICES` INT, `TOTAL_REVENUE` INT, `AVERAGE_REVENUE_PER_INVOICE` INT);

-- -----------------------------------------------------
-- procedure CREATE_INVOICE
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`CREATE_INVOICE`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE CREATE_INVOICE (IN p_cus_code INT, IN p_emp_code INT)
BEGIN
	DECLARE v_inv_number INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE CUS_CODE = p_cus_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO CUSTOMER FOUND. CHECK CUSTOMER CODE.'; END IF;
    
    IF NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_CODE = p_emp_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO EMPLOYEE FOUND. CHECK EMPLOYEE CODE.'; END IF;
    
    INSERT INTO INVOICE (CUS_CODE, EMP_CODE) VALUES (p_cus_code, p_emp_code);
    SET v_inv_number = LAST_INSERT_ID();
    
    COMMIT;
    
    SELECT * FROM INVOICE WHERE INV_NUMBER = v_inv_number;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SEARCH_PRODUCT
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`SEARCH_PRODUCT`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE SEARCH_PRODUCT (IN p_keyword VARCHAR(45))
BEGIN
	IF p_keyword IS NULL OR TRIM(p_keyword) = '' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'KEYWORD CANNOT BE BLANK.'; END IF;
    
	SELECT * FROM PRODUCT WHERE P_DESCRIPT LIKE CONCAT('%', TRIM(p_keyword), '%') ORDER BY P_DESCRIPT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CANCEL_INVOICE
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`CANCEL_INVOICE`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE CANCEL_INVOICE (IN p_inv_number INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    IF NOT EXISTS (SELECT 1 FROM INVOICE WHERE INV_NUMBER = p_inv_number) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO INVOICE FOUND. CHECK INVOICE NUMBER.'; END IF;
        
	IF (SELECT INV_STATUS FROM INVOICE WHERE INV_NUMBER = p_inv_number) <> 'DRAFT' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CAN ONLY PAY DRAFT INVOICE. CHECK INVOICE STATUS.'; END IF;
    
	UPDATE INVOICE SET INV_STATUS = 'CANCELLED' WHERE INV_NUMBER = p_inv_number;
    
    COMMIT;
    
    SELECT * FROM INVOICE WHERE INV_NUMBER = p_inv_number;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SEARCH_CUSTOMER
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`SEARCH_CUSTOMER`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE SEARCH_CUSTOMER (IN p_cus_phone CHAR(10), IN secret_key VARCHAR(10))
BEGIN
	IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE CUS_PHONE_HASH = SHA2(TRIM(p_cus_phone), 256)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO CUSTOMER FOUND. ADD NEW CUSTOMER.'; END IF;
    
	SELECT CUS_CODE, CUS_LNAME, CAST(AES_DECRYPT(CUS_PHONE_ENC, secret_key) AS CHAR) AS CUS_PHONE
    FROM CUSTOMER WHERE CUS_PHONE_HASH = SHA2(TRIM(p_cus_phone), 256);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RESTOCK_LIST
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`RESTOCK_LIST`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE RESTOCK_LIST ()
BEGIN
	SELECT P_CODE, P_DESCRIPT, P_QOH, P_MIN, (2 * P_MIN) AS TARGET_QOH, (2 * P_MIN - P_QOH) AS ORDER_UNITS
    FROM PRODUCT WHERE P_QOH <= P_MIN ORDER BY ORDER_UNITS DESC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ADD_STOCK
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`ADD_STOCK`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE ADD_STOCK (IN p_p_code INT, IN p_log_units INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    SELECT P_CODE, P_QOH AS OLD_QOH FROM PRODUCT WHERE P_CODE = p_p_code;
    
    START TRANSACTION;
    
	IF NOT EXISTS (SELECT 1 FROM PRODUCT WHERE P_CODE = p_p_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO PRODUCT FOUND. CHECK PRODUCT CODE.'; END IF;
    
    IF p_log_units <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UNITS MUST BE GREATER THAN 0.'; END IF;
    
    INSERT INTO INVENTORY_LOG (P_CODE, LOG_TYPE, LOG_UNITS) VALUES (p_p_code, 'RESTOCK', p_log_units);
    UPDATE PRODUCT SET P_QOH = P_QOH + p_log_units WHERE P_CODE = p_p_code;
    
    COMMIT;
    
    SELECT P_CODE, P_QOH AS NEW_QOH FROM PRODUCT WHERE P_CODE = p_p_code;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure DELETE_LINE
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`DELETE_LINE`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE DELETE_LINE (IN p_inv_number INT, IN p_p_code INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    IF (SELECT INV_STATUS FROM INVOICE WHERE INV_NUMBER = p_inv_number) <> 'DRAFT' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CAN ONLY EDIT DRAFT INVOICE. CHECK INVOICE STATUS.'; END IF;
    
    IF NOT EXISTS (SELECT 1 FROM LINE WHERE INV_NUMBER = p_inv_number AND P_CODE = p_p_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO LINE FOUND FOR THIS INVOICE.'; END IF;
    
    DELETE FROM LINE WHERE INV_NUMBER = p_inv_number AND P_CODE = p_p_code;
    
    COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ADD_CUSTOMER
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`ADD_CUSTOMER`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE ADD_CUSTOMER (IN p_cus_lname VARCHAR(10), IN p_cus_phone CHAR(10), IN secret_key VARCHAR(10))
BEGIN 
	DECLARE v_cus_code INT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    SET p_cus_lname= TRIM(p_cus_lname);
    SET p_cus_phone = TRIM(p_cus_phone);
    
    IF EXISTS (SELECT 1 FROM CUSTOMER WHERE CUS_PHONE_HASH = SHA2(p_cus_phone, 256)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'THIS PHONE IS ALREADY REGISTERED.'; END IF;
    
    INSERT INTO CUSTOMER (CUS_LNAME, CUS_PHONE_ENC, CUS_PHONE_HASH) 
    VALUES (p_cus_lname, AES_ENCRYPT(p_cus_phone, secret_key), SHA2(p_cus_phone, 256));
    SET v_cus_code = LAST_INSERT_ID();
    
    COMMIT;
    
    SELECT CUS_CODE, CUS_LNAME, CAST(AES_DECRYPT(CUS_PHONE_ENC, secret_key) AS CHAR) AS CUS_PHONE FROM CUSTOMER WHERE CUS_CODE = v_cus_code;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ADD_MANAGER
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`ADD_MANAGER`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE ADD_MANAGER (IN p_emp_lname VARCHAR(10), IN p_emp_fname VARCHAR(10), IN p_emp_phone CHAR(10), IN temp_password VARCHAR(45), IN secret_key CHAR(10))
BEGIN
	DECLARE v_emp_code INT;
    DECLARE v_emp_username VARCHAR(20);
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    SET p_emp_phone = TRIM(p_emp_phone);
    
    IF EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_PHONE_HASH = SHA2(p_emp_phone, 256)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'THIS PHONE IS ALREADY REGISTERED.'; END IF;
    
	INSERT INTO EMPLOYEE (EMP_LNAME, EMP_FNAME, EMP_JOB, EMP_PHONE_ENC, EMP_PHONE_HASH) 
    VALUES (TRIM(p_emp_lname), TRIM(p_emp_fname),'MANAGER', AES_ENCRYPT(p_emp_phone, secret_key), SHA2(p_emp_phone, 256));
    SET v_emp_code = LAST_INSERT_ID();
    
    SET v_emp_username = CONCAT(LOWER(TRIM(p_emp_lname)), v_emp_code);
    INSERT INTO EMPLOYEE_ACCOUNT (EMP_CODE, EMP_USERNAME, EMP_PASSWORD) 
    VALUES (v_emp_code, v_emp_username, SHA2(TRIM(temp_password), 256));
    
    COMMIT;
    
    SELECT EMP_CODE, EMP_LNAME, EMP_FNAME, EMP_JOB, EMP_HIREDATE, EMP_ACTIVE, CAST(AES_DECRYPT(EMP_PHONE_ENC, secret_key) AS CHAR) AS EMP_PHONE
    FROM EMPLOYEE WHERE EMP_CODE = v_emp_code;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PAY_INVOICE_CASH
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`PAY_INVOICE_CASH`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE PAY_INVOICE_CASH (IN p_inv_number INT, IN p_emp_code INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    IF NOT EXISTS (SELECT 1 FROM INVOICE WHERE INV_NUMBER = p_inv_number) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO INVOICE FOUND. CHECK INVOICE NUMBER.'; END IF;
    
    IF NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_CODE = p_emp_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO EMPLOYEE FOUND. CHECK EMPLOYEE CODE.'; END IF;
    
    IF (SELECT INV_STATUS FROM INVOICE WHERE INV_NUMBER = p_inv_number) <> 'DRAFT' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CAN ONLY PAY DRAFT INVOICE. CHECK INVOICE STATUS.'; END IF;
    
    IF NOT EXISTS (SELECT 1 FROM LINE WHERE INV_NUMBER = p_inv_number) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT PAY INVOICE WITH NO LINE.'; END IF;
    
    IF EXISTS (SELECT 1 FROM LINE JOIN PRODUCT USING (P_CODE) WHERE INV_NUMBER = p_inv_number AND LINE_UNITS > P_QOH) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSUFFICIENT QUANTITY ON HAND. CHECK INVOICE DETAILS.'; END IF;
    
    INSERT INTO INVOICE_PAYMENT (INV_NUMBER, PAY_TYPE, EMP_CODE) VALUES (p_inv_number, 'CASH', p_emp_code);
    UPDATE INVOICE SET INV_STATUS = 'PAID' WHERE INV_NUMBER = p_inv_number;
    UPDATE PRODUCT JOIN LINE USING (P_CODE) SET P_QOH = P_QOH - LINE_UNITS WHERE INV_NUMBER = p_inv_number;
    
    COMMIT;
	
    SELECT * FROM INVOICE WHERE INV_NUMBER = p_inv_number;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ADD_LINE
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`ADD_LINE`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE ADD_LINE (IN p_inv_number INT, IN p_p_code INT, IN p_line_units INT)
BEGIN
	DECLARE v_line_number INT;
	DECLARE v_line_price DECIMAL(9,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    IF NOT EXISTS (SELECT 1 FROM INVOICE WHERE INV_NUMBER = p_inv_number) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO INVOICE FOUND. CHECK INVOICE NUMBER.'; END IF;
        
	IF (SELECT INV_STATUS FROM INVOICE WHERE INV_NUMBER = p_inv_number) <> 'DRAFT' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CAN ONLY EDIT DRAFT INVOICE. CHECK INVOICE STATUS.'; END IF;
    
    IF NOT EXISTS (SELECT 1 FROM PRODUCT WHERE P_CODE = p_p_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO PRODUCT FOUND. CHECK PRODUCT CODE.'; END IF;
        
	IF EXISTS (SELECT 1 FROM LINE WHERE INV_NUMBER = p_inv_number AND P_CODE = p_p_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'THIS PRODUCT IS ALREADY ADDED. UPDATE UNITS.'; END IF;
    
    IF p_line_units <= 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UNITS MUST BE GREATER THAN 0.'; END IF;
    
    SELECT COALESCE(MAX(LINE_NUMBER), 0) + 1 INTO v_line_number FROM LINE WHERE INV_NUMBER = p_inv_number;
    SELECT P_PRICE * (1 - P_DISCOUNT) INTO v_line_price FROM PRODUCT WHERE P_CODE = p_p_code;
    
    INSERT INTO LINE (INV_NUMBER, LINE_NUMBER, P_CODE, LINE_UNITS, LINE_PRICE)
    VALUES (p_inv_number, v_line_number, p_p_code, p_line_units, v_line_price);
    
    COMMIT;
    
    SELECT * FROM LINE WHERE INV_NUMBER = p_inv_number AND LINE_NUMBER = v_line_number;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UPDATE_UNITS
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`UPDATE_UNITS`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE UPDATE_UNITS (IN p_inv_number INT, IN p_p_code INT, IN new_line_units INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
	START TRANSACTION;
    
    IF (SELECT INV_STATUS FROM INVOICE WHERE INV_NUMBER = p_inv_number) <> 'DRAFT' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CAN ONLY EDIT DRAFT INVOICE. CHECK INVOICE STATUS.'; END IF;
	
	IF NOT EXISTS (SELECT 1 FROM LINE WHERE INV_NUMBER = p_inv_number AND P_CODE = p_p_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO LINE FOUND FOR THIS INVOICE.'; END IF;
    
    IF new_line_units <= 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UNITS MUST BE GREATER THAN 0.'; END IF;
    
    UPDATE LINE SET LINE_UNITS = new_line_units WHERE INV_NUMBER = p_inv_number AND P_CODE = p_p_code;
    
    COMMIT;
    
    SELECT * FROM LINE WHERE INV_NUMBER = p_inv_number AND P_CODE = p_p_code;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SHOW_INVOICE_DETAILS
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`SHOW_INVOICE_DETAILS`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE SHOW_INVOICE_DETAILS (IN p_inv_number INT)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM INVOICE WHERE INV_NUMBER = p_inv_number) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO INVOICE FOUND. CHECK INVOICE NUMBER.'; END IF;
    
    SELECT * FROM INVOICE WHERE INV_NUMBER = p_inv_number;
    SELECT 
		LINE_NUMBER, PRODUCT.P_CODE, P_DESCRIPT, LINE_PRICE, LINE_UNITS, P_QOH, 
        CASE WHEN LINE_UNITS <= P_QOH THEN 'YES' ELSE 'NO' END AS IS_STOCK_ENOUGH
	FROM LINE JOIN PRODUCT ON LINE.P_CODE = PRODUCT.P_CODE WHERE INV_NUMBER = p_inv_number;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SEARCH_INVOICE
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`SEARCH_INVOICE`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE SEARCH_INVOICE (IN p_cus_code INT)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE CUS_CODE = p_cus_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO CUSTOMER FOUND. CHECK CUSTOMER CODE.'; END IF;
        
	SELECT * FROM INVOICE WHERE CUS_CODE = p_cus_code ORDER BY INV_DATE DESC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure PAY_INVOICE_BANK
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`PAY_INVOICE_BANK`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE PAY_INVOICE_BANK (IN p_inv_number INT, IN p_pay_ref VARCHAR(100), IN p_emp_code INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    IF NOT EXISTS (SELECT 1 FROM INVOICE WHERE INV_NUMBER = p_inv_number) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO INVOICE FOUND. CHECK INVOICE NUMBER.'; END IF;
    
    IF NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_CODE = p_emp_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO EMPLOYEE FOUND. CHECK EMPLOYEE CODE.'; END IF;
    
    IF (SELECT INV_STATUS FROM INVOICE WHERE INV_NUMBER = p_inv_number) <> 'DRAFT' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CAN ONLY PAY DRAFT INVOICE. CHECK INVOICE STATUS.'; END IF;
    
    IF NOT EXISTS (SELECT 1 FROM LINE WHERE INV_NUMBER = p_inv_number) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT PAY INVOICE WITH NO LINE.'; END IF;
    
    IF EXISTS (SELECT 1 FROM LINE JOIN PRODUCT USING (P_CODE) WHERE INV_NUMBER = p_inv_number AND LINE_UNITS > P_QOH) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSUFFICIENT QUANTITY ON HAND. CHECK INVOICE DETAILS.'; END IF;
    
    IF p_pay_ref IS NULL OR  TRIM(p_pay_ref) = '' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'BANK TRANSFER REFERENCE IS REQUIRED.'; END IF;
    
    INSERT INTO INVOICE_PAYMENT (INV_NUMBER, PAY_TYPE, PAY_REF, EMP_CODE) 
    VALUES (p_inv_number, 'BANK TRANSFER', TRIM(p_pay_ref), p_emp_code);
    
    UPDATE INVOICE SET INV_STATUS = 'PAID' WHERE INV_NUMBER = p_inv_number;
    UPDATE PRODUCT JOIN LINE USING (P_CODE) SET P_QOH = P_QOH - LINE_UNITS WHERE INV_NUMBER = p_inv_number;
    
    COMMIT;
	
    SELECT * FROM INVOICE WHERE INV_NUMBER = p_inv_number;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure REMOVE_DAMAGED
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`REMOVE_DAMAGED`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE REMOVE_DAMAGED (IN p_p_code INT, IN p_log_units INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    SELECT P_CODE, P_QOH AS OLD_QOH FROM PRODUCT WHERE P_CODE = p_p_code;
    
    START TRANSACTION;
    
	IF NOT EXISTS (SELECT 1 FROM PRODUCT WHERE P_CODE = p_p_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO PRODUCT FOUND. CHECK PRODUCT CODE.'; END IF;
    
    IF p_log_units <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UNITS MUST BE GREATER THAN 0.'; END IF;
        
	IF (SELECT P_QOH FROM PRODUCT WHERE P_CODE = p_p_code) < p_log_units THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UNITS CANNOT EXCEED CURRENT QUANTITY ON HAND.'; END IF;
    
    INSERT INTO INVENTORY_LOG (P_CODE, LOG_TYPE, LOG_UNITS) VALUES (p_p_code, 'DAMAGED', p_log_units);
    UPDATE PRODUCT SET P_QOH = P_QOH - p_log_units WHERE P_CODE = p_p_code;
    
    COMMIT;
    
    SELECT P_CODE, P_QOH AS NEW_QOH FROM PRODUCT WHERE P_CODE = p_p_code;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ADD_STAFF
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`ADD_STAFF`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE ADD_STAFF (IN p_emp_lname VARCHAR(10), IN p_emp_fname VARCHAR(10), IN p_emp_phone CHAR(10), IN temp_password VARCHAR(45), IN secret_key CHAR(10))
BEGIN
	DECLARE v_emp_code INT;
    DECLARE v_emp_username VARCHAR(20);
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    SET p_emp_phone = TRIM(p_emp_phone);
    
    IF EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_PHONE_HASH = SHA2(p_emp_phone, 256)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'THIS PHONE IS ALREADY REGISTERED.'; END IF;
    
	INSERT INTO EMPLOYEE (EMP_LNAME, EMP_FNAME, EMP_JOB, EMP_PHONE_ENC, EMP_PHONE_HASH) 
    VALUES (TRIM(p_emp_lname), TRIM(p_emp_fname),'STAFF', AES_ENCRYPT(p_emp_phone, secret_key), SHA2(p_emp_phone, 256));
    SET v_emp_code = LAST_INSERT_ID();
    
    SET v_emp_username = CONCAT(LOWER(TRIM(p_emp_lname)), v_emp_code);
    INSERT INTO EMPLOYEE_ACCOUNT (EMP_CODE, EMP_USERNAME, EMP_PASSWORD) 
    VALUES (v_emp_code, v_emp_username, SHA2(TRIM(temp_password), 256));
    
    COMMIT;
    
    SELECT EMP_CODE, EMP_LNAME, EMP_FNAME, EMP_JOB, EMP_HIREDATE, EMP_ACTIVE, CAST(AES_DECRYPT(EMP_PHONE_ENC, secret_key) AS CHAR) AS EMP_PHONE
    FROM EMPLOYEE WHERE EMP_CODE = v_emp_code;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SEARCH_EMPLOYEE
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`SEARCH_EMPLOYEE`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE SEARCH_EMPLOYEE(IN p_emp_phone CHAR(10), IN secret_key CHAR(10))
BEGIN
	SET p_emp_phone = TRIM(p_emp_phone);
    
	IF NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_PHONE_HASH = SHA2(p_emp_phone, 256)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO EMPLOYEE FOUND. ADD NEW EMPLOYEE.'; END IF;
    
    SELECT EMP_CODE, EMP_LNAME, EMP_FNAME, EMP_JOB, EMP_HIREDATE, EMP_ACTIVE, CAST(AES_DECRYPT(EMP_PHONE_ENC, secret_key) AS CHAR) AS EMP_PHONE
    FROM EMPLOYEE WHERE EMP_PHONE_HASH = SHA2(p_emp_phone, 256);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure DEACTIVATE_EMPLOYEE
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`DEACTIVATE_EMPLOYEE`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE DEACTIVATE_EMPLOYEE(IN p_emp_code INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
	IF NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_CODE = p_emp_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO EMPLOYEE FOUND. CHECK EMPLOYEE CODE.'; END IF;
    
    UPDATE EMPLOYEE SET EMP_ACTIVE = 0 WHERE EMP_CODE = p_emp_code;
    
    COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ADD_REVIEW
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`ADD_REVIEW`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE ADD_REVIEW (IN p_cus_code INT, IN p_p_code INT, IN p_rev_rating TINYINT, IN p_rev_comment VARCHAR(200))
BEGIN
	DECLARE v_rev_number INT;
	DECLARE v_rev_valid BOOLEAN;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
	IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE CUS_CODE = p_cus_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO CUSTOMER FOUND. CHECK CUSTOMER CODE.'; END IF;
    
    IF NOT EXISTS (SELECT 1 FROM PRODUCT WHERE P_CODE = p_p_code) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'NO PRODUCT FOUND. CHECK PRODUCT CODE.'; END IF;
    
    IF p_rev_rating NOT BETWEEN 1 AND 5 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RATING MUST BE BETWEEN 1 AND 5.'; END IF;
    
    IF NOT EXISTS 
		(SELECT 1 FROM CUSTOMER JOIN INVOICE USING (CUS_CODE) JOIN LINE USING (INV_NUMBER)
        WHERE CUS_CODE = p_cus_code AND P_CODE = p_p_code)
	THEN SET v_rev_valid = 0; ELSE SET v_rev_valid = 1; END IF;
    
    INSERT INTO PRODUCT_REVIEW (CUS_CODE, P_CODE, REV_RATING, REV_COMMENT, REV_VALID)
    VALUES (p_cus_code, p_p_code, p_rev_rating, p_rev_comment, v_rev_valid);
    SET v_rev_number = LAST_INSERT_ID();
    
    COMMIT;
    
    SELECT * FROM PRODUCT_REVIEW WHERE REV_NUMBER = v_rev_number;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure LOGIN_EMPLOYEE
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`LOGIN_EMPLOYEE`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE LOGIN_EMPLOYEE (IN p_emp_username VARCHAR(20), IN p_emp_password VARCHAR(45))
BEGIN
	DECLARE v_emp_password CHAR(64);
	SET p_emp_username = TRIM(p_emp_username);
    SET v_emp_password = SHA2(TRIM(p_emp_password), 256);
    
	IF NOT EXISTS (SELECT 1 FROM EMPLOYEE_ACCOUNT WHERE EMP_USERNAME = p_emp_username) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INVALID USERNAME OR PASSWORD.'; END IF;
        
	IF (SELECT EMP_ACTIVE FROM EMPLOYEE JOIN EMPLOYEE_ACCOUNT USING (EMP_CODE) WHERE EMP_USERNAME = p_emp_username) = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ONLY ACTIVE EMPLOYEE CAN LOG IN.'; END IF;
	
    IF (SELECT EMP_PASSWORD FROM EMPLOYEE_ACCOUNT WHERE EMP_USERNAME = p_emp_username) <> v_emp_password THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INVALID USERNAME OR PASSWORD.'; END IF;
        
	SELECT EMP_CODE, EMP_JOB, MUST_CHANGE_PASSWORD FROM EMPLOYEE JOIN EMPLOYEE_ACCOUNT USING (EMP_CODE)
    WHERE EMP_USERNAME = p_emp_username AND EMP_PASSWORD = v_emp_password;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure EMPLOYEE_CHANGE_PASSWORD
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`EMPLOYEE_CHANGE_PASSWORD`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE EMPLOYEE_CHANGE_PASSWORD (IN p_emp_code INT, IN new_password VARCHAR(45))
BEGIN
	DECLARE v_emp_password CHAR(64);
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    SET v_emp_password = SHA2(TRIM(new_password), 256);
    IF (SELECT EMP_PASSWORD FROM EMPLOYEE_ACCOUNT WHERE EMP_CODE = p_emp_code) = v_emp_password THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT REUSE OLD PASSWORD.'; END IF;
        
	UPDATE EMPLOYEE_ACCOUNT SET EMP_PASSWORD = v_emp_password WHERE EMP_CODE = p_emp_code;
    UPDATE EMPLOYEE_ACCOUNT SET MUST_CHANGE_PASSWORD = 0 WHERE EMP_CODE = p_emp_code;
    
    COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UPDATE_CUSTOMER_NAME
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`UPDATE_CUSTOMER_NAME`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE UPDATE_CUSTOMER_NAME (IN p_cus_code INT , IN p_new_lname VARCHAR(10))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    SET p_new_lname= TRIM(p_new_lname);
    
	IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE CUS_CODE = p_cus_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO CUSTOMER FOUND. CHECK CUSTOMER CODE.'; END IF;
	UPDATE CUSTOMER SET CUS_LNAME = p_new_lname WHERE CUS_CODE = p_cus_code;
    
	COMMIT;
    
    SELECT CUS_CODE, CUS_LNAME FROM CUSTOMER WHERE CUS_CODE = p_cus_code;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UPDATE_CUSTOMER_PHONE
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`UPDATE_CUSTOMER_PHONE`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE UPDATE_CUSTOMER_PHONE (IN p_cus_code INT, IN p_new_phone CHAR(10), IN secret_key VARCHAR(10))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    SET p_new_phone = TRIM(p_new_phone);
    
	IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE CUS_CODE = p_cus_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO CUSTOMER FOUND. CHECK CUSTOMER CODE.'; END IF;
        
	IF EXISTS (SELECT 1 FROM CUSTOMER WHERE CUS_PHONE_HASH = SHA2(p_new_phone, 256)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'THIS PHONE IS ALREADY REGISTERED.'; END IF;
        
	UPDATE CUSTOMER 
    SET CUS_PHONE_ENC = AES_ENCRYPT(p_new_phone, secret_key), CUS_PHONE_HASH = SHA2(p_new_phone, 256)
    WHERE CUS_CODE = p_cus_code;
    
	COMMIT;
    
    SELECT CUS_CODE, CUS_LNAME, CAST(AES_DECRYPT(CUS_PHONE_ENC, secret_key) AS CHAR) AS CUS_PHONE FROM CUSTOMER WHERE CUS_CODE = p_cus_code;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RESET_EMPLOYEE_PASSWORD
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`RESET_EMPLOYEE_PASSWORD`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE RESET_EMPLOYEE_PASSWORD (IN p_emp_code INT, IN temp_password VARCHAR(45))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
	IF NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_CODE = p_emp_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO EMPLOYEE FOUND. CHECK EMPLOYEE CODE.';
	END IF;
    
    UPDATE EMPLOYEE_ACCOUNT SET EMP_PASSWORD = SHA2(TRIM(temp_password), 256) WHERE EMP_CODE = p_emp_code;
    UPDATE EMPLOYEE_ACCOUNT SET MUST_CHANGE_PASSWORD = 1 WHERE EMP_CODE = p_emp_code;
    
    COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ADJUST_GAIN
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`ADJUST_GAIN`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE ADJUST_GAIN (IN p_p_code INT, IN p_log_units INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    SELECT P_CODE, P_QOH AS OLD_QOH FROM PRODUCT WHERE P_CODE = p_p_code;
    
    START TRANSACTION;
    
	IF NOT EXISTS (SELECT 1 FROM PRODUCT WHERE P_CODE = p_p_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO PRODUCT FOUND. CHECK PRODUCT CODE.'; END IF;
    
    IF p_log_units <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UNITS MUST BE GREATER THAN 0.'; END IF;
    
    INSERT INTO INVENTORY_LOG (P_CODE, LOG_TYPE, LOG_UNITS) VALUES (p_p_code, 'GAIN', p_log_units);
    UPDATE PRODUCT SET P_QOH = P_QOH + p_log_units WHERE P_CODE = p_p_code;
    
    COMMIT;
    
    SELECT P_CODE, P_QOH AS NEW_QOH FROM PRODUCT WHERE P_CODE = p_p_code;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ADJUST_LOSS
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`ADJUST_LOSS`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE ADJUST_LOSS (IN p_p_code INT, IN p_log_units INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    SELECT P_CODE, P_QOH AS OLD_QOH FROM PRODUCT WHERE P_CODE = p_p_code;
    
    START TRANSACTION;
    
	IF NOT EXISTS (SELECT 1 FROM PRODUCT WHERE P_CODE = p_p_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO PRODUCT FOUND. CHECK PRODUCT CODE.'; END IF;
    
    IF p_log_units <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UNITS MUST BE GREATER THAN 0.'; END IF;
        
	IF (SELECT P_QOH FROM PRODUCT WHERE P_CODE = p_p_code) < p_log_units THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UNITS CANNOT EXCEED CURRENT QUANTITY ON HAND.'; END IF;
    
    INSERT INTO INVENTORY_LOG (P_CODE, LOG_TYPE, LOG_UNITS) VALUES (p_p_code, 'LOSS', p_log_units);
    UPDATE PRODUCT SET P_QOH = P_QOH - p_log_units WHERE P_CODE = p_p_code;
    
    COMMIT;
    
    SELECT P_CODE, P_QOH AS NEW_QOH FROM PRODUCT WHERE P_CODE = p_p_code;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UPDATE_PRICE
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`UPDATE_PRICE`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE UPDATE_PRICE (IN p_p_code INT, IN new_price DECIMAL(9,2))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    SELECT P_CODE, P_DESCRIPT, P_PRICE AS OLD_PRICE FROM PRODUCT WHERE P_CODE = p_p_code;
    
    START TRANSACTION;
    
	IF NOT EXISTS (SELECT 1 FROM PRODUCT WHERE P_CODE = p_p_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO PRODUCT FOUND. CHECK PRODUCT CODE.'; END IF;
        
	IF new_price <= 0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PRICE MUST BE GREATER THAN 0.'; END IF;
        
	IF (SELECT P_PRICE FROM PRODUCT WHERE P_CODE = p_p_code) = new_price THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NEW PRICE MUST BE DIFFERENT FROM CURRENT PRICE.'; END IF;
        
	UPDATE PRODUCT SET P_PRICE = new_price WHERE P_CODE = p_p_code;
    
    COMMIT;
    
    SELECT P_CODE, P_DESCRIPT, P_PRICE AS NEW_PRICE FROM PRODUCT WHERE P_CODE = p_p_code;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UPDATE_DISCOUNT
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`UPDATE_DISCOUNT`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE UPDATE_DISCOUNT (IN p_p_code INT, IN new_discount DECIMAL(5,2))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    SELECT P_CODE, P_DESCRIPT, P_PRICE, P_DISCOUNT AS OLD_DISCOUNT FROM PRODUCT WHERE P_CODE = p_p_code;
    
    START TRANSACTION;
    
	IF NOT EXISTS (SELECT 1 FROM PRODUCT WHERE P_CODE = p_p_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO PRODUCT FOUND. CHECK PRODUCT CODE.'; END IF;
        
	IF new_discount NOT BETWEEN 0 AND 1 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DISCOUNT MUST BE BETWEEN 0 AND 1.'; END IF;
        
	IF (SELECT P_DISCOUNT FROM PRODUCT WHERE P_CODE = p_p_code) = new_discount THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NEW DISCOUNT MUST BE DIFFERENT FROM CURRENT DISCOUNT.'; END IF;
        
	UPDATE PRODUCT SET P_DISCOUNT = new_discount WHERE P_CODE = p_p_code;
    
    COMMIT;
    
    SELECT P_CODE, P_DESCRIPT, P_PRICE, P_DISCOUNT AS NEW_DISCOUNT FROM PRODUCT WHERE P_CODE = p_p_code;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UPDATE_EMPLOYEE_JOB
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`UPDATE_EMPLOYEE_JOB`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE UPDATE_EMPLOYEE_JOB (IN p_emp_code INT, IN new_job VARCHAR(10))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
	IF NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_CODE = p_emp_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO EMPLOYEE FOUND. CHECK EMPLOYEE CODE.'; END IF;
    
    UPDATE EMPLOYEE SET EMP_JOB = UPPER(TRIM(new_job)) WHERE EMP_CODE = p_emp_code;
    
    COMMIT;
    
    SELECT EMP_CODE, EMP_LNAME, EMP_FNAME, EMP_JOB FROM EMPLOYEE WHERE EMP_CODE = p_emp_code;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UPDATE_EMPLOYEE_PHONE
-- -----------------------------------------------------

USE `shopdb`;
DROP procedure IF EXISTS `shopdb`.`UPDATE_EMPLOYEE_PHONE`;

DELIMITER $$
USE `shopdb`$$
CREATE PROCEDURE UPDATE_EMPLOYEE_PHONE (IN p_emp_code INT, IN p_new_phone CHAR(10), IN secret_key VARCHAR(10))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    SET p_new_phone = TRIM(p_new_phone);
    
	IF NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_CODE = p_emp_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO EMPLOYEE FOUND. CHECK EMPLOYEE CODE.'; END IF;
        
	IF EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_PHONE_HASH = SHA2(p_new_phone, 256)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'THIS PHONE IS ALREADY REGISTERED.'; END IF;
        
	UPDATE EMPLOYEE 
    SET EMP_PHONE_ENC = AES_ENCRYPT(p_new_phone, secret_key), EMP_PHONE_HASH = SHA2(p_new_phone, 256)
    WHERE EMP_CODE = p_emp_code;
    
	COMMIT;
    
    SELECT EMP_CODE, EMP_LNAME, EMP_FNAME, EMP_JOB, CAST(AES_DECRYPT(EMP_PHONE_ENC, secret_key) AS CHAR) AS EMP_PHONE 
    FROM EMPLOYEE WHERE EMP_CODE = p_emp_code;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `shopdb`.`CUSTOMER_INVOICE_SUMMARY`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopdb`.`CUSTOMER_INVOICE_SUMMARY`;
DROP VIEW IF EXISTS `shopdb`.`CUSTOMER_INVOICE_SUMMARY` ;
USE `shopdb`;
CREATE  OR REPLACE VIEW `CUSTOMER_INVOICE_SUMMARY` AS
SELECT CUS_CODE, CUS_LNAME, INV_NUMBER, INV_DATE, INV_STATUS, INV_TOTAL, EMP_CODE 
FROM CUSTOMER JOIN INVOICE USING (CUS_CODE);

-- -----------------------------------------------------
-- View `shopdb`.`CUSTOMER_PURCHASE_SUMMARY`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopdb`.`CUSTOMER_PURCHASE_SUMMARY`;
DROP VIEW IF EXISTS `shopdb`.`CUSTOMER_PURCHASE_SUMMARY` ;
USE `shopdb`;
CREATE  OR REPLACE VIEW `CUSTOMER_PURCHASE_SUMMARY` AS
SELECT 
	CUSTOMER.CUS_CODE, CUS_LNAME, 
    COUNT(INV_NUMBER) AS TOTAL_PAID_INVOICES, 
    COALESCE(SUM(INV_TOTAL), 0) AS TOTAL_SPENDING, 
    COALESCE(ROUND(AVG(INV_TOTAL), 2), 0) AS AVERAGE_SPENDING_PER_INVOICE
FROM CUSTOMER LEFT JOIN INVOICE ON CUSTOMER.CUS_CODE = INVOICE.CUS_CODE AND INV_STATUS = 'PAID'
GROUP BY CUSTOMER.CUS_CODE, CUS_LNAME;

-- -----------------------------------------------------
-- View `shopdb`.`MONTHLY_PRODUCT_SALES_SUMMARY`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopdb`.`MONTHLY_PRODUCT_SALES_SUMMARY`;
DROP VIEW IF EXISTS `shopdb`.`MONTHLY_PRODUCT_SALES_SUMMARY` ;
USE `shopdb`;
CREATE  OR REPLACE VIEW `MONTHLY_PRODUCT_SALES_SUMMARY` AS
SELECT 
	YEAR(INV_DATE) AS SALE_YEAR, MONTH(INV_DATE) AS SALE_MONTH,
	PRODUCT.P_CODE, P_DESCRIPT, P_CATEGORY, 
    SUM(LINE_UNITS) AS TOTAL_UNITS_SOLD, 
    SUM(LINE_UNITS * LINE_PRICE) AS TOTAL_REVENUE, 
    ROUND(SUM(LINE_UNITS * LINE_PRICE) / SUM(SUM(LINE_UNITS * LINE_PRICE)) OVER(PARTITION BY YEAR(INV_DATE), MONTH(INV_DATE)) * 100, 2) AS REVENUE_PERCENTAGE
FROM PRODUCT JOIN LINE ON PRODUCT.P_CODE = LINE.P_CODE JOIN INVOICE ON LINE.INV_NUMBER = INVOICE.INV_NUMBER WHERE INV_STATUS = 'PAID'
GROUP BY YEAR(INV_DATE), MONTH(INV_DATE), PRODUCT.P_CODE, P_DESCRIPT, P_CATEGORY;

-- -----------------------------------------------------
-- View `shopdb`.`YEARLY_PRODUCT_SALES_SUMMARY`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopdb`.`YEARLY_PRODUCT_SALES_SUMMARY`;
DROP VIEW IF EXISTS `shopdb`.`YEARLY_PRODUCT_SALES_SUMMARY` ;
USE `shopdb`;
CREATE  OR REPLACE VIEW `YEARLY_PRODUCT_SALES_SUMMARY` AS
SELECT 
	YEAR(INV_DATE) AS SALE_YEAR,
	PRODUCT.P_CODE, P_DESCRIPT, P_CATEGORY, 
    SUM(LINE_UNITS) AS TOTAL_UNITS_SOLD, 
    SUM(LINE_UNITS * LINE_PRICE) AS TOTAL_REVENUE, 
    ROUND(SUM(LINE_UNITS * LINE_PRICE) / SUM(SUM(LINE_UNITS * LINE_PRICE)) OVER(PARTITION BY YEAR(INV_DATE)) * 100, 2) AS REVENUE_PERCENTAGE
FROM PRODUCT JOIN LINE ON PRODUCT.P_CODE = LINE.P_CODE JOIN INVOICE ON LINE.INV_NUMBER = INVOICE.INV_NUMBER WHERE INV_STATUS = 'PAID'
GROUP BY YEAR(INV_DATE), PRODUCT.P_CODE, P_DESCRIPT, P_CATEGORY;

-- -----------------------------------------------------
-- View `shopdb`.`MONTHLY_REVENUE_SUMMARY`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shopdb`.`MONTHLY_REVENUE_SUMMARY`;
DROP VIEW IF EXISTS `shopdb`.`MONTHLY_REVENUE_SUMMARY` ;
USE `shopdb`;
CREATE  OR REPLACE VIEW `MONTHLY_REVENUE_SUMMARY` AS
SELECT 
	YEAR(INV_DATE) AS SALE_YEAR, MONTH(INV_DATE) AS SALE_MONTH, 
    COUNT(INV_NUMBER) AS TOTAL_PAID_INVOICES, 
    SUM(INV_TOTAL) AS TOTAL_REVENUE, 
    ROUND(AVG(INV_TOTAL), 2) AS AVERAGE_REVENUE_PER_INVOICE
FROM INVOICE WHERE INV_STATUS = 'PAID' GROUP BY YEAR(INV_DATE), MONTH(INV_DATE);
SET SQL_MODE = '';
DROP USER IF EXISTS shop_app;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'shop_app' IDENTIFIED BY 'group1_password';

GRANT SELECT ON TABLE `shopdb`.* TO 'shop_app';
GRANT EXECUTE ON `shopdb`.* TO 'shop_app';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `shopdb`.`PRODUCT`
-- -----------------------------------------------------
START TRANSACTION;
USE `shopdb`;
INSERT INTO `shopdb`.`PRODUCT` (`P_CODE`, `P_DESCRIPT`, `P_CATEGORY`, `P_INDATE`, `P_QOH`, `P_MIN`, `P_PRICE`, `P_DISCOUNT`) VALUES (1, 'Charger', 'ACCESSORY', '2025-09-09', 135, 19, 29.76, 0.1);
INSERT INTO `shopdb`.`PRODUCT` (`P_CODE`, `P_DESCRIPT`, `P_CATEGORY`, `P_INDATE`, `P_QOH`, `P_MIN`, `P_PRICE`, `P_DISCOUNT`) VALUES (2, 'Mouse', 'DEVICE', '2024-07-26', 54, 42, 544.59, 0.2);
INSERT INTO `shopdb`.`PRODUCT` (`P_CODE`, `P_DESCRIPT`, `P_CATEGORY`, `P_INDATE`, `P_QOH`, `P_MIN`, `P_PRICE`, `P_DISCOUNT`) VALUES (3, 'Desk', 'EQUIPMENT', '2024-05-20', 129, 37, 33.54, 0.05);
INSERT INTO `shopdb`.`PRODUCT` (`P_CODE`, `P_DESCRIPT`, `P_CATEGORY`, `P_INDATE`, `P_QOH`, `P_MIN`, `P_PRICE`, `P_DISCOUNT`) VALUES (4, 'USB Cable', 'ACCESSORY', '2025-11-27', 224, 19, 453.38, 0.2);
INSERT INTO `shopdb`.`PRODUCT` (`P_CODE`, `P_DESCRIPT`, `P_CATEGORY`, `P_INDATE`, `P_QOH`, `P_MIN`, `P_PRICE`, `P_DISCOUNT`) VALUES (5, 'Lamp', 'EQUIPMENT', '2024-11-30', 398, 15, 649.45, 0.0);
INSERT INTO `shopdb`.`PRODUCT` (`P_CODE`, `P_DESCRIPT`, `P_CATEGORY`, `P_INDATE`, `P_QOH`, `P_MIN`, `P_PRICE`, `P_DISCOUNT`) VALUES (6, 'Laptop Stand', 'ACCESSORY', '2024-11-07', 120, 26, 278.8, 0.05);
INSERT INTO `shopdb`.`PRODUCT` (`P_CODE`, `P_DESCRIPT`, `P_CATEGORY`, `P_INDATE`, `P_QOH`, `P_MIN`, `P_PRICE`, `P_DISCOUNT`) VALUES (7, 'Keyboard', 'DEVICE', '2024-10-21', 443, 27, 310.14, 0.1);
INSERT INTO `shopdb`.`PRODUCT` (`P_CODE`, `P_DESCRIPT`, `P_CATEGORY`, `P_INDATE`, `P_QOH`, `P_MIN`, `P_PRICE`, `P_DISCOUNT`) VALUES (8, 'Backpack', 'ACCESSORY', '2024-08-17', 284, 12, 647.63, 0.15);
INSERT INTO `shopdb`.`PRODUCT` (`P_CODE`, `P_DESCRIPT`, `P_CATEGORY`, `P_INDATE`, `P_QOH`, `P_MIN`, `P_PRICE`, `P_DISCOUNT`) VALUES (9, 'Chair', 'EQUIPMENT', '2025-11-24', 463, 28, 446.11, 0.2);
INSERT INTO `shopdb`.`PRODUCT` (`P_CODE`, `P_DESCRIPT`, `P_CATEGORY`, `P_INDATE`, `P_QOH`, `P_MIN`, `P_PRICE`, `P_DISCOUNT`) VALUES (10, 'Phone Case', 'ACCESSORY', '2024-07-19', 348, 19, 566.61, 0.0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `shopdb`.`CUSTOMER`
-- -----------------------------------------------------
START TRANSACTION;
USE `shopdb`;
INSERT INTO `shopdb`.`CUSTOMER` (`CUS_CODE`, `CUS_LNAME`, `CUS_PHONE_ENC`, `CUS_PHONE_HASH`) VALUES (1, 'Robinson', 0x2E2E2E, '4c0e2eea38dad339d57717b6e8b0ce170de1933c6761fa14ac76f77e21d566e7');
INSERT INTO `shopdb`.`CUSTOMER` (`CUS_CODE`, `CUS_LNAME`, `CUS_PHONE_ENC`, `CUS_PHONE_HASH`) VALUES (2, 'Moore', 0x2E2E2E, '8a9bcf1e51e812d0af8465a8dbcc9f741064bf0af3b3d08e6b0246437c19f7fb');
INSERT INTO `shopdb`.`CUSTOMER` (`CUS_CODE`, `CUS_LNAME`, `CUS_PHONE_ENC`, `CUS_PHONE_HASH`) VALUES (3, 'Arnold', 0x2E2E2E, 'fd48a57d9c4760e8965ddc7be88f4e671dec7e33549fd9b575e514a02c804e73');
INSERT INTO `shopdb`.`CUSTOMER` (`CUS_CODE`, `CUS_LNAME`, `CUS_PHONE_ENC`, `CUS_PHONE_HASH`) VALUES (4, 'Reid', 0x2E2E2E, '90ce971c5a0ac285b3d7b8168e35a2ae6da52f63560ec2915b32cb4fc7135c75');
INSERT INTO `shopdb`.`CUSTOMER` (`CUS_CODE`, `CUS_LNAME`, `CUS_PHONE_ENC`, `CUS_PHONE_HASH`) VALUES (5, 'Nelson', 0x2E2E2E, '3e6219a1cfcf51857f117468f49319c022ba8cc2d150a4c3c6e1c5ae15f0f4c7');
INSERT INTO `shopdb`.`CUSTOMER` (`CUS_CODE`, `CUS_LNAME`, `CUS_PHONE_ENC`, `CUS_PHONE_HASH`) VALUES (6, 'Rios', 0x2E2E2E, 'da93914bc87fd7638c1487c7921febbd9961bf9da6d9bd5ce94aff7f18bfbd1f');
INSERT INTO `shopdb`.`CUSTOMER` (`CUS_CODE`, `CUS_LNAME`, `CUS_PHONE_ENC`, `CUS_PHONE_HASH`) VALUES (7, 'Osborn', 0x2E2E2E, '1f63c1f06f8f0593c839ded5db998b0f4ddd552057cbb096e69ce1b07630c551');
INSERT INTO `shopdb`.`CUSTOMER` (`CUS_CODE`, `CUS_LNAME`, `CUS_PHONE_ENC`, `CUS_PHONE_HASH`) VALUES (8, 'James', 0x2E2E2E, 'ebc3f243d1210781f89db6783b2bdfd25fbed989f285022b57e9259084815912');
INSERT INTO `shopdb`.`CUSTOMER` (`CUS_CODE`, `CUS_LNAME`, `CUS_PHONE_ENC`, `CUS_PHONE_HASH`) VALUES (9, 'Smith', 0x2E2E2E, 'f23b584696ded66db94be266e9f7fae5ef9ee247977395a4d2a357ded9a2773c');
INSERT INTO `shopdb`.`CUSTOMER` (`CUS_CODE`, `CUS_LNAME`, `CUS_PHONE_ENC`, `CUS_PHONE_HASH`) VALUES (10, 'Burns', 0x2E2E2E, 'a3d9682cac602da27793989adaf6c4fb854eab8fcf64c8aef593c0fee35ec553');

COMMIT;


-- -----------------------------------------------------
-- Data for table `shopdb`.`EMPLOYEE`
-- -----------------------------------------------------
START TRANSACTION;
USE `shopdb`;
INSERT INTO `shopdb`.`EMPLOYEE` (`EMP_CODE`, `EMP_LNAME`, `EMP_FNAME`, `EMP_JOB`, `EMP_HIREDATE`, `EMP_ACTIVE`, `EMP_PHONE_ENC`, `EMP_PHONE_HASH`) VALUES (1, 'Spence', 'Amanda', 'STAFF', '2026-05-17', 1, 0x2E2E2E, '0120899735f02544ad469a2a1b89c3c46b1bcf1538ba31f292ebbeb5a9c00f8e');
INSERT INTO `shopdb`.`EMPLOYEE` (`EMP_CODE`, `EMP_LNAME`, `EMP_FNAME`, `EMP_JOB`, `EMP_HIREDATE`, `EMP_ACTIVE`, `EMP_PHONE_ENC`, `EMP_PHONE_HASH`) VALUES (2, 'Ross', 'Emily', 'STAFF', '2026-05-17', 1, 0x2E2E2E, '22a11ce8f78ca4d6a2f76f912e6e511d0da4ae35b54eb6b6655e93f94fbaf447');
INSERT INTO `shopdb`.`EMPLOYEE` (`EMP_CODE`, `EMP_LNAME`, `EMP_FNAME`, `EMP_JOB`, `EMP_HIREDATE`, `EMP_ACTIVE`, `EMP_PHONE_ENC`, `EMP_PHONE_HASH`) VALUES (3, 'Jones', 'Crystal', 'MANAGER', '2026-05-17', 1, 0x2E2E2E, '97e0323c6820a31f3450d1d159c48185f776068e9f3afd74fcdd30a2a17df3e5');
INSERT INTO `shopdb`.`EMPLOYEE` (`EMP_CODE`, `EMP_LNAME`, `EMP_FNAME`, `EMP_JOB`, `EMP_HIREDATE`, `EMP_ACTIVE`, `EMP_PHONE_ENC`, `EMP_PHONE_HASH`) VALUES (4, 'Sanchez', 'Thomas', 'MANAGER', '2026-05-17', 1, 0x2E2E2E, 'd0b0d9e96a7692660c3213b2b4ee3cf6aad15755aa98c34da091cf7ce4ec5a1f');
INSERT INTO `shopdb`.`EMPLOYEE` (`EMP_CODE`, `EMP_LNAME`, `EMP_FNAME`, `EMP_JOB`, `EMP_HIREDATE`, `EMP_ACTIVE`, `EMP_PHONE_ENC`, `EMP_PHONE_HASH`) VALUES (5, 'Powell', 'Matthew', 'STAFF', '2026-05-17', 1, 0x2E2E2E, '8c4d03b802f7872e47d30a8f7057c5a9e534b36c80220afc8de7b11374586007');
INSERT INTO `shopdb`.`EMPLOYEE` (`EMP_CODE`, `EMP_LNAME`, `EMP_FNAME`, `EMP_JOB`, `EMP_HIREDATE`, `EMP_ACTIVE`, `EMP_PHONE_ENC`, `EMP_PHONE_HASH`) VALUES (6, 'Baxter', 'Charles', 'STAFF', '2026-05-17', 1, 0x2E2E2E, '1fd2d4dc7b5121743b3b172a9de87b0ee4b5360b90f3c3fe86c0e50b1c4a19b0');
INSERT INTO `shopdb`.`EMPLOYEE` (`EMP_CODE`, `EMP_LNAME`, `EMP_FNAME`, `EMP_JOB`, `EMP_HIREDATE`, `EMP_ACTIVE`, `EMP_PHONE_ENC`, `EMP_PHONE_HASH`) VALUES (7, 'Hancock', 'Rachel', 'STAFF', '2026-05-17', 1, 0x2E2E2E, '5e3b38353a23198ce91bd7b4062f3578ff8ae7e73a0d5d32227585bfdd52491d');
INSERT INTO `shopdb`.`EMPLOYEE` (`EMP_CODE`, `EMP_LNAME`, `EMP_FNAME`, `EMP_JOB`, `EMP_HIREDATE`, `EMP_ACTIVE`, `EMP_PHONE_ENC`, `EMP_PHONE_HASH`) VALUES (8, 'Adkins', 'Brian', 'STAFF', '2026-05-17', 1, 0x2E2E2E, 'ef60017b556320d5a6d7c89a6d899dfbfcf2db28a2869ee164b9d92427b1c16d');
INSERT INTO `shopdb`.`EMPLOYEE` (`EMP_CODE`, `EMP_LNAME`, `EMP_FNAME`, `EMP_JOB`, `EMP_HIREDATE`, `EMP_ACTIVE`, `EMP_PHONE_ENC`, `EMP_PHONE_HASH`) VALUES (9, 'Riley', 'Bernard', 'MANAGER', '2026-05-17', 1, 0x2E2E2E, 'ce8f2e5c3dab662c7f9674bd81836f6159c2d54d45a27f53768efa4e1f502d36');
INSERT INTO `shopdb`.`EMPLOYEE` (`EMP_CODE`, `EMP_LNAME`, `EMP_FNAME`, `EMP_JOB`, `EMP_HIREDATE`, `EMP_ACTIVE`, `EMP_PHONE_ENC`, `EMP_PHONE_HASH`) VALUES (10, 'Smith', 'Christine', 'STAFF', '2026-05-17', 1, 0x2E2E2E, 'd82a51ab83f418ea7ea4fef89f97afd6745a7d055817315aadf5af50c97053c8');

COMMIT;


-- -----------------------------------------------------
-- Data for table `shopdb`.`EMPLOYEE_ACCOUNT`
-- -----------------------------------------------------
START TRANSACTION;
USE `shopdb`;
INSERT INTO `shopdb`.`EMPLOYEE_ACCOUNT` (`EMP_CODE`, `EMP_USERNAME`, `EMP_PASSWORD`, `MUST_CHANGE_PASSWORD`) VALUES (1, 'spence1', '47625ed74cab8fbc0a8348f3df1feb07f87601e34d62bd12eb0d51616566fab5', 1);
INSERT INTO `shopdb`.`EMPLOYEE_ACCOUNT` (`EMP_CODE`, `EMP_USERNAME`, `EMP_PASSWORD`, `MUST_CHANGE_PASSWORD`) VALUES (2, 'ross2', '47625ed74cab8fbc0a8348f3df1feb07f87601e34d62bd12eb0d51616566fab5', 1);
INSERT INTO `shopdb`.`EMPLOYEE_ACCOUNT` (`EMP_CODE`, `EMP_USERNAME`, `EMP_PASSWORD`, `MUST_CHANGE_PASSWORD`) VALUES (3, 'jones3', '3713dd1302b8e4afb0698537a10b721554d29c9c2d35de18f255ebb9cc553b1b', 1);
INSERT INTO `shopdb`.`EMPLOYEE_ACCOUNT` (`EMP_CODE`, `EMP_USERNAME`, `EMP_PASSWORD`, `MUST_CHANGE_PASSWORD`) VALUES (4, 'sanchez4', '3713dd1302b8e4afb0698537a10b721554d29c9c2d35de18f255ebb9cc553b1b', 1);
INSERT INTO `shopdb`.`EMPLOYEE_ACCOUNT` (`EMP_CODE`, `EMP_USERNAME`, `EMP_PASSWORD`, `MUST_CHANGE_PASSWORD`) VALUES (5, 'powell5', '47625ed74cab8fbc0a8348f3df1feb07f87601e34d62bd12eb0d51616566fab5', 1);
INSERT INTO `shopdb`.`EMPLOYEE_ACCOUNT` (`EMP_CODE`, `EMP_USERNAME`, `EMP_PASSWORD`, `MUST_CHANGE_PASSWORD`) VALUES (6, 'baxter6', '47625ed74cab8fbc0a8348f3df1feb07f87601e34d62bd12eb0d51616566fab5', 1);
INSERT INTO `shopdb`.`EMPLOYEE_ACCOUNT` (`EMP_CODE`, `EMP_USERNAME`, `EMP_PASSWORD`, `MUST_CHANGE_PASSWORD`) VALUES (7, 'hancock7', '47625ed74cab8fbc0a8348f3df1feb07f87601e34d62bd12eb0d51616566fab5', 1);
INSERT INTO `shopdb`.`EMPLOYEE_ACCOUNT` (`EMP_CODE`, `EMP_USERNAME`, `EMP_PASSWORD`, `MUST_CHANGE_PASSWORD`) VALUES (8, 'adkins8', '47625ed74cab8fbc0a8348f3df1feb07f87601e34d62bd12eb0d51616566fab5', 1);
INSERT INTO `shopdb`.`EMPLOYEE_ACCOUNT` (`EMP_CODE`, `EMP_USERNAME`, `EMP_PASSWORD`, `MUST_CHANGE_PASSWORD`) VALUES (9, 'riley9', '3713dd1302b8e4afb0698537a10b721554d29c9c2d35de18f255ebb9cc553b1b', 1);
INSERT INTO `shopdb`.`EMPLOYEE_ACCOUNT` (`EMP_CODE`, `EMP_USERNAME`, `EMP_PASSWORD`, `MUST_CHANGE_PASSWORD`) VALUES (10, 'smith10', '47625ed74cab8fbc0a8348f3df1feb07f87601e34d62bd12eb0d51616566fab5', 1);

COMMIT;

USE `shopdb`;

DELIMITER $$

USE `shopdb`$$
DROP TRIGGER IF EXISTS `shopdb`.`PRODUCT_BEFORE_DELETE` $$
USE `shopdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `shopdb`.`PRODUCT_BEFORE_DELETE` BEFORE DELETE ON `PRODUCT` FOR EACH ROW
BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT DELETE PRODUCT.';
END$$


USE `shopdb`$$
DROP TRIGGER IF EXISTS `shopdb`.`INVENTORY_LOG_BEFORE_UPDATE` $$
USE `shopdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `shopdb`.`INVENTORY_LOG_BEFORE_UPDATE` BEFORE UPDATE ON `INVENTORY_LOG` FOR EACH ROW
BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT UPDATE LOG. INSERT A CORRECTING ROW.';
END$$


USE `shopdb`$$
DROP TRIGGER IF EXISTS `shopdb`.`INVENTORY_LOG_BEFORE_DELETE` $$
USE `shopdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `shopdb`.`INVENTORY_LOG_BEFORE_DELETE` BEFORE DELETE ON `INVENTORY_LOG` FOR EACH ROW
BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT DELETE LOG.';
END$$


USE `shopdb`$$
DROP TRIGGER IF EXISTS `shopdb`.`CUSTOMER_BEFORE_DELETE` $$
USE `shopdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `shopdb`.`CUSTOMER_BEFORE_DELETE` BEFORE DELETE ON `CUSTOMER` FOR EACH ROW
BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT DELETE CUSTOMER.';
END$$


USE `shopdb`$$
DROP TRIGGER IF EXISTS `shopdb`.`EMPLOYEE_BEFORE_DELETE` $$
USE `shopdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `shopdb`.`EMPLOYEE_BEFORE_DELETE` BEFORE DELETE ON `EMPLOYEE` FOR EACH ROW
BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT DELETE EMPLOYEE.';
END$$


USE `shopdb`$$
DROP TRIGGER IF EXISTS `shopdb`.`INVOICE_BEFORE_DELETE` $$
USE `shopdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `shopdb`.`INVOICE_BEFORE_DELETE` BEFORE DELETE ON `INVOICE` FOR EACH ROW
BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT DELETE INVOICE.';
END$$


USE `shopdb`$$
DROP TRIGGER IF EXISTS `shopdb`.`LINE_AFTER_INSERT` $$
USE `shopdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `shopdb`.`LINE_AFTER_INSERT` AFTER INSERT ON `LINE` FOR EACH ROW
BEGIN
	UPDATE INVOICE SET INV_TOTAL = 
		(SELECT COALESCE(SUM(LINE_UNITS * LINE_PRICE), 0) FROM LINE WHERE INV_NUMBER = NEW.INV_NUMBER)
	WHERE INV_NUMBER = NEW.INV_NUMBER;
END$$


USE `shopdb`$$
DROP TRIGGER IF EXISTS `shopdb`.`LINE_AFTER_UPDATE` $$
USE `shopdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `shopdb`.`LINE_AFTER_UPDATE` AFTER UPDATE ON `LINE` FOR EACH ROW
BEGIN
	UPDATE INVOICE SET INV_TOTAL = 
		(SELECT COALESCE(SUM(LINE_UNITS * LINE_PRICE), 0) FROM LINE WHERE INV_NUMBER = NEW.INV_NUMBER)
	WHERE INV_NUMBER = NEW.INV_NUMBER;
END$$


USE `shopdb`$$
DROP TRIGGER IF EXISTS `shopdb`.`LINE_AFTER_DELETE` $$
USE `shopdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `shopdb`.`LINE_AFTER_DELETE` AFTER DELETE ON `LINE` FOR EACH ROW
BEGIN
	UPDATE INVOICE SET INV_TOTAL = 
		(SELECT COALESCE(SUM(LINE_UNITS * LINE_PRICE), 0) FROM LINE WHERE INV_NUMBER = OLD.INV_NUMBER)
	WHERE INV_NUMBER = OLD.INV_NUMBER;
END$$


USE `shopdb`$$
DROP TRIGGER IF EXISTS `shopdb`.`INVOICE_PAYMENT_BEFORE_UPDATE` $$
USE `shopdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `shopdb`.`INVOICE_PAYMENT_BEFORE_UPDATE` BEFORE UPDATE ON `INVOICE_PAYMENT` FOR EACH ROW
BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT UPDATE INVOICE PAYMENT.';
END$$


USE `shopdb`$$
DROP TRIGGER IF EXISTS `shopdb`.`INVOICE_PAYMENT_BEFORE_DELETE` $$
USE `shopdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `shopdb`.`INVOICE_PAYMENT_BEFORE_DELETE` BEFORE DELETE ON `INVOICE_PAYMENT` FOR EACH ROW
BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT DELETE INVOICE PAYMENT.';
END$$


DELIMITER ;
