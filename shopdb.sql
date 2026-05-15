CREATE DATABASE  IF NOT EXISTS `shopdb` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `shopdb`;
-- MySQL dump 10.13  Distrib 8.0.43, for macos15 (arm64)
--
-- Host: localhost    Database: shopdb
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `CUSTOMER`
--

DROP TABLE IF EXISTS `CUSTOMER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CUSTOMER` (
  `CUS_CODE` int NOT NULL AUTO_INCREMENT,
  `CUS_LNAME` varchar(10) NOT NULL,
  `CUS_PHONE_ENC` varbinary(255) NOT NULL,
  `CUS_PHONE_HASH` char(64) NOT NULL,
  PRIMARY KEY (`CUS_CODE`),
  UNIQUE KEY `CUS_PHONE_HASH_UNIQUE` (`CUS_PHONE_HASH`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CUSTOMER`
--

LOCK TABLES `CUSTOMER` WRITE;
/*!40000 ALTER TABLE `CUSTOMER` DISABLE KEYS */;
INSERT INTO `CUSTOMER` VALUES (1,'Robinson',_binary '³ÿ@tL]?›Dˆ‰¦¢¢B','4c0e2eea38dad339d57717b6e8b0ce170de1933c6761fa14ac76f77e21d566e7'),(2,'Moore',_binary '$™\Ú#f/.aÿw%•£ ','8a9bcf1e51e812d0af8465a8dbcc9f741064bf0af3b3d08e6b0246437c19f7fb'),(3,'Arnold',_binary '¥ \rN[“Õ€‰{˜1sF','fd48a57d9c4760e8965ddc7be88f4e671dec7e33549fd9b575e514a02c804e73'),(4,'Reid',_binary '\Z)K\×gCE\Äy\è0¯nAŒ','90ce971c5a0ac285b3d7b8168e35a2ae6da52f63560ec2915b32cb4fc7135c75'),(5,'Nelson',_binary '±\æ\Â\ç;:ö¨m%›v?§','3e6219a1cfcf51857f117468f49319c022ba8cc2d150a4c3c6e1c5ae15f0f4c7'),(6,'Rios',_binary '\Â\Þ\â_‚\"\î¯\Z¸9f\âÀ—','da93914bc87fd7638c1487c7921febbd9961bf9da6d9bd5ce94aff7f18bfbd1f'),(7,'Osborn',_binary '¨\"ª¼mk°\æüüN¤ºŽ\Ð','1f63c1f06f8f0593c839ded5db998b0f4ddd552057cbb096e69ce1b07630c551'),(8,'James',_binary '“i‘sV ¸Ÿ°‚\Ô\î	•W','ebc3f243d1210781f89db6783b2bdfd25fbed989f285022b57e9259084815912'),(9,'Smith',_binary '‰0\Ê{²ø\Äbû\à3_Cy','f23b584696ded66db94be266e9f7fae5ef9ee247977395a4d2a357ded9a2773c'),(10,'Burns',_binary '$.¬9¦·p\Ï\ç\Ë9¸','02c98d0b5065db42a4c8a10fe4ded4bf0448614ffa1090e927a498ed83834135');
/*!40000 ALTER TABLE `CUSTOMER` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `CUSTOMER_BEFORE_DELETE` BEFORE DELETE ON `customer` FOR EACH ROW BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT DELETE CUSTOMER.';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `customer_invoice_summary`
--

DROP TABLE IF EXISTS `customer_invoice_summary`;
/*!50001 DROP VIEW IF EXISTS `customer_invoice_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `customer_invoice_summary` AS SELECT 
 1 AS `CUS_CODE`,
 1 AS `CUS_LNAME`,
 1 AS `INV_NUMBER`,
 1 AS `INV_DATE`,
 1 AS `INV_STATUS`,
 1 AS `INV_TOTAL`,
 1 AS `EMP_CODE`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `customer_purchase_summary`
--

DROP TABLE IF EXISTS `customer_purchase_summary`;
/*!50001 DROP VIEW IF EXISTS `customer_purchase_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `customer_purchase_summary` AS SELECT 
 1 AS `CUS_CODE`,
 1 AS `CUS_LNAME`,
 1 AS `TOTAL_PAID_INVOICES`,
 1 AS `TOTAL_SPENDING`,
 1 AS `AVERAGE_SPENDING_PER_INVOICE`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `EMPLOYEE`
--

DROP TABLE IF EXISTS `EMPLOYEE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EMPLOYEE` (
  `EMP_CODE` int NOT NULL AUTO_INCREMENT,
  `EMP_LNAME` varchar(10) NOT NULL,
  `EMP_FNAME` varchar(10) NOT NULL,
  `EMP_JOB` enum('STAFF','MANAGER') NOT NULL,
  `EMP_HIREDATE` date NOT NULL DEFAULT (curdate()),
  `EMP_ACTIVE` tinyint NOT NULL DEFAULT '1',
  `EMP_PHONE_ENC` varbinary(255) NOT NULL,
  `EMP_PHONE_HASH` char(64) NOT NULL,
  PRIMARY KEY (`EMP_CODE`),
  UNIQUE KEY `EMP_PHONE_HASH_UNIQUE` (`EMP_PHONE_HASH`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EMPLOYEE`
--

LOCK TABLES `EMPLOYEE` WRITE;
/*!40000 ALTER TABLE `EMPLOYEE` DISABLE KEYS */;
INSERT INTO `EMPLOYEE` VALUES (1,'Spence','Amanda','STAFF','2026-05-11',1,_binary '\ë…s8G\ÅjóÀmVhÙ¤','0120899735f02544ad469a2a1b89c3c46b1bcf1538ba31f292ebbeb5a9c00f8e'),(2,'Ross','Emily','STAFF','2026-05-11',1,_binary '$¤¥\â7—§\Þ_›','22a11ce8f78ca4d6a2f76f912e6e511d0da4ae35b54eb6b6655e93f94fbaf447'),(3,'Jones','Crystal','MANAGER','2026-05-11',1,_binary '*²¡Ï›„G_R…\\\Í\Â\'l\Ð','97e0323c6820a31f3450d1d159c48185f776068e9f3afd74fcdd30a2a17df3e5'),(4,'Sanchez','Thomas','MANAGER','2026-05-11',1,_binary 'U[+cÁ\êm±\äû}\Ë\Ït§»','d0b0d9e96a7692660c3213b2b4ee3cf6aad15755aa98c34da091cf7ce4ec5a1f'),(5,'Powell','Matthew','STAFF','2026-05-11',1,_binary '\\šA£]øøL\îµÚƒ','8c4d03b802f7872e47d30a8f7057c5a9e534b36c80220afc8de7b11374586007'),(6,'Baxter','Charles','STAFF','2026-05-11',1,_binary '@\á\Ò<:cW²\n‹\Çl+,\Ô','1fd2d4dc7b5121743b3b172a9de87b0ee4b5360b90f3c3fe86c0e50b1c4a19b0'),(7,'Hancock','Rachel','STAFF','2026-05-11',1,_binary 'X6f‘§\ÍÁzi\îoX’s','5e3b38353a23198ce91bd7b4062f3578ff8ae7e73a0d5d32227585bfdd52491d'),(8,'Adkins','Brian','STAFF','2026-05-11',1,_binary 'þ\ß\ëT;6Ž%”\Èa\ÌR\Ü>','ef60017b556320d5a6d7c89a6d899dfbfcf2db28a2869ee164b9d92427b1c16d'),(9,'Riley','Bernard','MANAGER','2026-05-11',1,_binary '˜>ÿ+™a2Ú ß²4šŸ=','ce8f2e5c3dab662c7f9674bd81836f6159c2d54d45a27f53768efa4e1f502d36'),(10,'Smith','Christine','STAFF','2026-05-11',1,_binary '”{¯Ið\ÄrC/¶%¹„','d82a51ab83f418ea7ea4fef89f97afd6745a7d055817315aadf5af50c97053c8');
/*!40000 ALTER TABLE `EMPLOYEE` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `EMPLOYEE_BEFORE_DELETE` BEFORE DELETE ON `employee` FOR EACH ROW BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT DELETE EMPLOYEE.';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `EMPLOYEE_ACCOUNT`
--

DROP TABLE IF EXISTS `EMPLOYEE_ACCOUNT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EMPLOYEE_ACCOUNT` (
  `EMP_CODE` int NOT NULL,
  `EMP_USERNAME` varchar(20) NOT NULL,
  `EMP_PASSWORD` char(64) NOT NULL,
  `MUST_CHANGE_PASSWORD` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`EMP_CODE`),
  UNIQUE KEY `EMP_USERNAME_UNIQUE` (`EMP_USERNAME`),
  CONSTRAINT `fk_empaccount_employee` FOREIGN KEY (`EMP_CODE`) REFERENCES `EMPLOYEE` (`EMP_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EMPLOYEE_ACCOUNT`
--

LOCK TABLES `EMPLOYEE_ACCOUNT` WRITE;
/*!40000 ALTER TABLE `EMPLOYEE_ACCOUNT` DISABLE KEYS */;
INSERT INTO `EMPLOYEE_ACCOUNT` VALUES (1,'spence1','47625ed74cab8fbc0a8348f3df1feb07f87601e34d62bd12eb0d51616566fab5',1),(2,'ross2','47625ed74cab8fbc0a8348f3df1feb07f87601e34d62bd12eb0d51616566fab5',1),(3,'jones3','3713dd1302b8e4afb0698537a10b721554d29c9c2d35de18f255ebb9cc553b1b',1),(4,'sanchez4','3713dd1302b8e4afb0698537a10b721554d29c9c2d35de18f255ebb9cc553b1b',1),(5,'powell5','47625ed74cab8fbc0a8348f3df1feb07f87601e34d62bd12eb0d51616566fab5',1),(6,'baxter6','47625ed74cab8fbc0a8348f3df1feb07f87601e34d62bd12eb0d51616566fab5',1),(7,'hancock7','47625ed74cab8fbc0a8348f3df1feb07f87601e34d62bd12eb0d51616566fab5',1),(8,'adkins8','47625ed74cab8fbc0a8348f3df1feb07f87601e34d62bd12eb0d51616566fab5',1),(9,'riley9','3713dd1302b8e4afb0698537a10b721554d29c9c2d35de18f255ebb9cc553b1b',1),(10,'smith10','47625ed74cab8fbc0a8348f3df1feb07f87601e34d62bd12eb0d51616566fab5',1);
/*!40000 ALTER TABLE `EMPLOYEE_ACCOUNT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `INVENTORY_LOG`
--

DROP TABLE IF EXISTS `INVENTORY_LOG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INVENTORY_LOG` (
  `LOG_NUMBER` int NOT NULL AUTO_INCREMENT,
  `P_CODE` int NOT NULL,
  `LOG_TYPE` enum('RESTOCK','DAMAGED','GAIN','LOSS') NOT NULL,
  `LOG_DATE` date NOT NULL DEFAULT (curdate()),
  `LOG_UNITS` int NOT NULL,
  PRIMARY KEY (`LOG_NUMBER`),
  KEY `fk_idx` (`P_CODE`),
  CONSTRAINT `fk_inventory_product` FOREIGN KEY (`P_CODE`) REFERENCES `PRODUCT` (`P_CODE`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `INVENTORY_LOG`
--

LOCK TABLES `INVENTORY_LOG` WRITE;
/*!40000 ALTER TABLE `INVENTORY_LOG` DISABLE KEYS */;
INSERT INTO `INVENTORY_LOG` VALUES (1,2,'RESTOCK','2026-05-11',6),(2,10,'DAMAGED','2026-05-11',8);
/*!40000 ALTER TABLE `INVENTORY_LOG` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `INVENTORY_LOG_BEFORE_UPDATE` BEFORE UPDATE ON `inventory_log` FOR EACH ROW BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT UPDATE LOG. INSERT A CORRECTING ROW.';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `INVENTORY_LOG_BEFORE_DELETE` BEFORE DELETE ON `inventory_log` FOR EACH ROW BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT DELETE LOG.';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `INVOICE`
--

DROP TABLE IF EXISTS `INVOICE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INVOICE` (
  `INV_NUMBER` int NOT NULL AUTO_INCREMENT,
  `INV_DATE` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `INV_STATUS` enum('DRAFT','CANCELLED','PAID') NOT NULL DEFAULT 'DRAFT',
  `INV_TOTAL` decimal(9,2) NOT NULL DEFAULT '0.00',
  `CUS_CODE` int NOT NULL,
  `EMP_CODE` int NOT NULL,
  PRIMARY KEY (`INV_NUMBER`),
  KEY `fk_invoice_customer_idx` (`CUS_CODE`),
  KEY `fk_invoice_employee_idx` (`EMP_CODE`),
  CONSTRAINT `fk_invoice_customer` FOREIGN KEY (`CUS_CODE`) REFERENCES `CUSTOMER` (`CUS_CODE`),
  CONSTRAINT `fk_invoice_employee` FOREIGN KEY (`EMP_CODE`) REFERENCES `EMPLOYEE` (`EMP_CODE`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `INVOICE`
--

LOCK TABLES `INVOICE` WRITE;
/*!40000 ALTER TABLE `INVOICE` DISABLE KEYS */;
INSERT INTO `INVOICE` VALUES (1,'2026-05-11 23:26:04','PAID',305.91,1,1),(2,'2026-05-11 23:34:19','PAID',1298.90,8,1),(3,'2026-05-11 23:51:01','CANCELLED',0.00,6,1);
/*!40000 ALTER TABLE `INVOICE` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `INVOICE_BEFORE_DELETE` BEFORE DELETE ON `invoice` FOR EACH ROW BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT DELETE INVOICE.';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `INVOICE_PAYMENT`
--

DROP TABLE IF EXISTS `INVOICE_PAYMENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INVOICE_PAYMENT` (
  `INV_NUMBER` int NOT NULL,
  `PAY_DATE` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `PAY_TYPE` enum('CASH','BANK TRANSFER') NOT NULL,
  `PAY_REF` varchar(100) DEFAULT NULL,
  `EMP_CODE` int NOT NULL,
  PRIMARY KEY (`INV_NUMBER`),
  UNIQUE KEY `PAY_REF_UNIQUE` (`PAY_REF`),
  KEY `fk_payment_employee_idx` (`EMP_CODE`),
  CONSTRAINT `fk_payment_employee` FOREIGN KEY (`EMP_CODE`) REFERENCES `EMPLOYEE` (`EMP_CODE`),
  CONSTRAINT `fk_payment_invoice` FOREIGN KEY (`INV_NUMBER`) REFERENCES `INVOICE` (`INV_NUMBER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `INVOICE_PAYMENT`
--

LOCK TABLES `INVOICE_PAYMENT` WRITE;
/*!40000 ALTER TABLE `INVOICE_PAYMENT` DISABLE KEYS */;
INSERT INTO `INVOICE_PAYMENT` VALUES (1,'2026-05-11 23:31:19','CASH',NULL,1),(2,'2026-05-11 23:48:20','BANK TRANSFER','480T2650GSBTZVEP',1);
/*!40000 ALTER TABLE `INVOICE_PAYMENT` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `INVOICE_PAYMENT_BEFORE_UPDATE` BEFORE UPDATE ON `invoice_payment` FOR EACH ROW BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT UPDATE INVOICE PAYMENT.';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `INVOICE_PAYMENT_BEFORE_DELETE` BEFORE DELETE ON `invoice_payment` FOR EACH ROW BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT DELETE INVOICE PAYMENT.';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `LINE`
--

DROP TABLE IF EXISTS `LINE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LINE` (
  `INV_NUMBER` int NOT NULL,
  `LINE_NUMBER` int NOT NULL,
  `P_CODE` int NOT NULL,
  `LINE_UNITS` int NOT NULL,
  `LINE_PRICE` decimal(9,2) NOT NULL,
  PRIMARY KEY (`INV_NUMBER`,`LINE_NUMBER`),
  UNIQUE KEY `uq_invoice_product_idx` (`INV_NUMBER`,`P_CODE`),
  KEY `fk_line_invoice_idx` (`INV_NUMBER`),
  KEY `fk_line_product_idx` (`P_CODE`),
  CONSTRAINT `fk_line_invoice` FOREIGN KEY (`INV_NUMBER`) REFERENCES `INVOICE` (`INV_NUMBER`),
  CONSTRAINT `fk_line_product` FOREIGN KEY (`P_CODE`) REFERENCES `PRODUCT` (`P_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LINE`
--

LOCK TABLES `LINE` WRITE;
/*!40000 ALTER TABLE `LINE` DISABLE KEYS */;
INSERT INTO `LINE` VALUES (1,1,1,1,26.78),(1,2,7,1,279.13),(2,1,5,2,649.45);
/*!40000 ALTER TABLE `LINE` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `LINE_AFTER_INSERT` AFTER INSERT ON `line` FOR EACH ROW BEGIN
	UPDATE INVOICE SET INV_TOTAL = 
		(SELECT COALESCE(SUM(LINE_UNITS * LINE_PRICE), 0) FROM LINE WHERE INV_NUMBER = NEW.INV_NUMBER)
	WHERE INV_NUMBER = NEW.INV_NUMBER;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `LINE_AFTER_UPDATE` AFTER UPDATE ON `line` FOR EACH ROW BEGIN
	UPDATE INVOICE SET INV_TOTAL = 
		(SELECT COALESCE(SUM(LINE_UNITS * LINE_PRICE), 0) FROM LINE WHERE INV_NUMBER = NEW.INV_NUMBER)
	WHERE INV_NUMBER = NEW.INV_NUMBER;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `LINE_AFTER_DELETE` AFTER DELETE ON `line` FOR EACH ROW BEGIN
	UPDATE INVOICE SET INV_TOTAL = 
		(SELECT COALESCE(SUM(LINE_UNITS * LINE_PRICE), 0) FROM LINE WHERE INV_NUMBER = OLD.INV_NUMBER)
	WHERE INV_NUMBER = OLD.INV_NUMBER;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `monthly_product_sales_summary`
--

DROP TABLE IF EXISTS `monthly_product_sales_summary`;
/*!50001 DROP VIEW IF EXISTS `monthly_product_sales_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `monthly_product_sales_summary` AS SELECT 
 1 AS `SALE_YEAR`,
 1 AS `SALE_MONTH`,
 1 AS `P_CODE`,
 1 AS `P_DESCRIPT`,
 1 AS `P_CATEGORY`,
 1 AS `TOTAL_UNITS_SOLD`,
 1 AS `TOTAL_REVENUE`,
 1 AS `REVENUE_PERCENTAGE`,
 1 AS `SALES_STATUS`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `monthly_revenue_summary`
--

DROP TABLE IF EXISTS `monthly_revenue_summary`;
/*!50001 DROP VIEW IF EXISTS `monthly_revenue_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `monthly_revenue_summary` AS SELECT 
 1 AS `SALE_YEAR`,
 1 AS `SALE_MONTH`,
 1 AS `TOTAL_PAID_INVOICES`,
 1 AS `TOTAL_REVENUE`,
 1 AS `AVERAGE_REVENUE_PER_INVOICE`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `PRODUCT`
--

DROP TABLE IF EXISTS `PRODUCT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PRODUCT` (
  `P_CODE` int NOT NULL AUTO_INCREMENT,
  `P_DESCRIPT` varchar(45) NOT NULL,
  `P_CATEGORY` enum('ACCESSORY','DEVICE','EQUIPMENT') NOT NULL,
  `P_INDATE` date NOT NULL DEFAULT (curdate()),
  `P_QOH` int NOT NULL,
  `P_MIN` int NOT NULL,
  `P_PRICE` decimal(9,2) NOT NULL,
  `P_DISCOUNT` decimal(5,2) NOT NULL,
  PRIMARY KEY (`P_CODE`),
  UNIQUE KEY `P_DESCRIPT_UNIQUE` (`P_DESCRIPT`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PRODUCT`
--

LOCK TABLES `PRODUCT` WRITE;
/*!40000 ALTER TABLE `PRODUCT` DISABLE KEYS */;
INSERT INTO `PRODUCT` VALUES (1,'Charger','ACCESSORY','2025-09-09',134,19,29.76,0.10),(2,'Mouse','DEVICE','2024-07-26',60,42,544.59,0.20),(3,'Desk','EQUIPMENT','2024-05-20',129,37,33.54,0.05),(4,'USB Cable','ACCESSORY','2025-11-27',224,19,453.38,0.20),(5,'Lamp','EQUIPMENT','2024-11-30',396,15,649.45,0.00),(6,'Laptop Stand','ACCESSORY','2024-11-07',120,26,278.80,0.05),(7,'Keyboard','DEVICE','2024-10-21',442,27,310.14,0.10),(8,'Backpack','ACCESSORY','2024-08-17',284,12,647.63,0.15),(9,'Chair','EQUIPMENT','2025-11-24',463,28,446.11,0.20),(10,'Phone Case','ACCESSORY','2024-07-19',340,19,566.61,0.00);
/*!40000 ALTER TABLE `PRODUCT` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PRODUCT_BEFORE_DELETE` BEFORE DELETE ON `product` FOR EACH ROW BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CANNOT DELETE PRODUCT.';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `PRODUCT_REVIEW`
--

DROP TABLE IF EXISTS `PRODUCT_REVIEW`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PRODUCT_REVIEW` (
  `REV_NUMBER` int NOT NULL AUTO_INCREMENT,
  `CUS_CODE` int NOT NULL,
  `P_CODE` int NOT NULL,
  `REV_RATING` tinyint NOT NULL,
  `REV_COMMENT` varchar(200) DEFAULT NULL,
  `REV_VALID` tinyint NOT NULL,
  PRIMARY KEY (`REV_NUMBER`),
  KEY `fk_review_customer_idx` (`CUS_CODE`),
  KEY `fk_review_product_idx` (`P_CODE`),
  CONSTRAINT `fk_review_customer` FOREIGN KEY (`CUS_CODE`) REFERENCES `CUSTOMER` (`CUS_CODE`),
  CONSTRAINT `fk_review_product` FOREIGN KEY (`P_CODE`) REFERENCES `PRODUCT` (`P_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PRODUCT_REVIEW`
--

LOCK TABLES `PRODUCT_REVIEW` WRITE;
/*!40000 ALTER TABLE `PRODUCT_REVIEW` DISABLE KEYS */;
/*!40000 ALTER TABLE `PRODUCT_REVIEW` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `yearly_product_sales_summary`
--

DROP TABLE IF EXISTS `yearly_product_sales_summary`;
/*!50001 DROP VIEW IF EXISTS `yearly_product_sales_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `yearly_product_sales_summary` AS SELECT 
 1 AS `SALE_YEAR`,
 1 AS `P_CODE`,
 1 AS `P_DESCRIPT`,
 1 AS `P_CATEGORY`,
 1 AS `TOTAL_UNITS_SOLD`,
 1 AS `TOTAL_REVENUE`,
 1 AS `REVENUE_PERCENTAGE`,
 1 AS `SALES_STATUS`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'shopdb'
--
/*!50003 DROP PROCEDURE IF EXISTS `ADD_CUSTOMER` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADD_CUSTOMER`(IN p_cus_lname VARCHAR(10), IN p_cus_phone CHAR(10), IN secret_key VARCHAR(10))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ADD_LINE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADD_LINE`(IN p_inv_number INT, IN p_p_code INT, IN p_line_units INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ADD_MANAGER` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADD_MANAGER`(IN p_emp_lname VARCHAR(10), IN p_emp_fname VARCHAR(10), IN p_emp_phone CHAR(10), IN temp_password VARCHAR(45), IN secret_key CHAR(10))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ADD_REVIEW` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADD_REVIEW`(IN p_cus_code INT, IN p_p_code INT, IN p_rev_rating TINYINT, IN p_rev_comment VARCHAR(200))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ADD_STAFF` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADD_STAFF`(IN p_emp_lname VARCHAR(10), IN p_emp_fname VARCHAR(10), IN p_emp_phone CHAR(10), IN temp_password VARCHAR(45), IN secret_key CHAR(10))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ADD_STOCK` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADD_STOCK`(IN p_p_code INT, IN p_log_units INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ADJUST_GAIN` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADJUST_GAIN`(IN p_p_code INT, IN p_log_units INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ADJUST_LOSS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADJUST_LOSS`(IN p_p_code INT, IN p_log_units INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CANCEL_INVOICE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CANCEL_INVOICE`(IN p_inv_number INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    IF NOT EXISTS (SELECT 1 FROM INVOICE WHERE INV_NUMBER = p_inv_number) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO INVOICE FOUND. CHECK INVOICE NUMBER.'; END IF;
    
	UPDATE INVOICE SET INV_STATUS = 'CANCELLED' WHERE INV_NUMBER = p_inv_number;
    
    COMMIT;
    
    SELECT * FROM INVOICE WHERE INV_NUMBER = p_inv_number;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CREATE_INVOICE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CREATE_INVOICE`(IN p_cus_code INT, IN p_emp_code INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DEACTIVATE_EMPLOYEE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DEACTIVATE_EMPLOYEE`(IN p_emp_code INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
	IF NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_CODE = p_emp_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO EMPLOYEE FOUND. CHECK EMPLOYEE CODE.'; END IF;
    
    UPDATE EMPLOYEE SET EMP_ACTIVE = 0 WHERE EMP_CODE = p_emp_code;
    
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DELETE_LINE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DELETE_LINE`(IN p_inv_number INT, IN p_p_code INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    IF (SELECT INV_STATUS FROM INVOICE WHERE INV_NUMBER = p_inv_number) <> 'DRAFT' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CAN ONLY EDIT DRAFT INVOICE. CHECK INVOICE STATUS.'; END IF;
    
    IF NOT EXISTS (SELECT 1 FROM LINE WHERE INV_NUMBER = p_inv_number AND P_CODE = p_p_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO LINE FOUND FOR THIS INVOICE.'; END IF;
    
    DELETE FROM LINE WHERE INV_NUMBER = p_inv_number AND P_CODE = p_p_code;
    
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EMPLOYEE_CHANGE_PASSWORD` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EMPLOYEE_CHANGE_PASSWORD`(IN p_emp_code INT, IN new_password VARCHAR(45))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `LOGIN_EMPLOYEE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `LOGIN_EMPLOYEE`(IN p_emp_username VARCHAR(20), IN p_emp_password VARCHAR(45))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `PAY_INVOICE_BANK` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `PAY_INVOICE_BANK`(IN p_inv_number INT, IN p_pay_ref VARCHAR(100), IN p_emp_code INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `PAY_INVOICE_CASH` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `PAY_INVOICE_CASH`(IN p_inv_number INT, IN p_emp_code INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `REMOVE_DAMAGED` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `REMOVE_DAMAGED`(IN p_p_code INT, IN p_log_units INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RESET_EMPLOYEE_PASSWORD` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `RESET_EMPLOYEE_PASSWORD`(IN p_emp_code INT, IN temp_password VARCHAR(45))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
	IF NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_CODE = p_emp_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO EMPLOYEE FOUND. CHECK EMPLOYEE CODE.';
	END IF;
    
    UPDATE EMPLOYEE_ACCOUNT SET EMP_PASSWORD = SHA2(TRIM(temp_password), 256) WHERE EMP_CODE = p_emp_code;
    UPDATE EMPLOYEE_ACCOUNT SET MUST_CHANGE_PASSWORD = 1 WHERE EMP_CODE = p_emp_code;
    
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RESTOCK_LIST` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `RESTOCK_LIST`()
BEGIN
	SELECT P_CODE, P_DESCRIPT, P_QOH, P_MIN, (2 * P_MIN) AS TARGET_QOH, (2 * P_MIN - P_QOH) AS ORDER_UNITS
    FROM PRODUCT WHERE P_QOH <= P_MIN ORDER BY ORDER_UNITS DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SEARCH_CUSTOMER` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SEARCH_CUSTOMER`(IN p_cus_phone CHAR(10), IN secret_key VARCHAR(10))
BEGIN
	IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE CUS_PHONE_HASH = SHA2(TRIM(p_cus_phone), 256)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO CUSTOMER FOUND. ADD NEW CUSTOMER.'; END IF;
    
	SELECT CUS_CODE, CUS_LNAME, CAST(AES_DECRYPT(CUS_PHONE_ENC, secret_key) AS CHAR) AS CUS_PHONE
    FROM CUSTOMER WHERE CUS_PHONE_HASH = SHA2(TRIM(p_cus_phone), 256);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SEARCH_EMPLOYEE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SEARCH_EMPLOYEE`(IN p_emp_phone CHAR(10), IN secret_key CHAR(10))
BEGIN
	SET p_emp_phone = TRIM(p_emp_phone);
    
	IF NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_PHONE_HASH = SHA2(p_emp_phone, 256)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO EMPLOYEE FOUND. ADD NEW EMPLOYEE.'; END IF;
    
    SELECT EMP_CODE, EMP_LNAME, EMP_FNAME, EMP_JOB, EMP_HIREDATE, EMP_ACTIVE, CAST(AES_DECRYPT(EMP_PHONE_ENC, secret_key) AS CHAR) AS EMP_PHONE
    FROM EMPLOYEE WHERE EMP_PHONE_HASH = SHA2(p_emp_phone, 256);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SEARCH_INVOICE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SEARCH_INVOICE`(IN p_cus_code INT)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE CUS_CODE = p_cus_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO CUSTOMER FOUND. CHECK CUSTOMER CODE.'; END IF;
        
	SELECT * FROM INVOICE WHERE CUS_CODE = p_cus_code ORDER BY INV_DATE DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SEARCH_PRODUCT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SEARCH_PRODUCT`(IN p_keyword VARCHAR(45))
BEGIN
	IF p_keyword IS NULL OR TRIM(p_keyword) = '' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'KEYWORD CANNOT BE BLANK.'; END IF;
    
	SELECT * FROM PRODUCT WHERE P_DESCRIPT LIKE CONCAT('%', TRIM(p_keyword), '%') ORDER BY P_DESCRIPT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SHOW_INVOICE_DETAILS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;

CREATE DEFINER=`root`@`localhost` PROCEDURE `SHOW_INVOICE_DETAILS`(IN p_inv_number INT)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM INVOICE WHERE INV_NUMBER = p_inv_number) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO INVOICE FOUND. CHECK INVOICE NUMBER.'; END IF;
    
    SELECT * FROM INVOICE WHERE INV_NUMBER = p_inv_number;
    SELECT 
		LINE_NUMBER, PRODUCT.P_CODE, P_DESCRIPT, LINE_PRICE, LINE_UNITS, P_QOH, 
        CASE WHEN LINE_UNITS <= P_QOH THEN 'YES' ELSE 'NO' END AS IS_STOCK_ENOUGH
	FROM LINE JOIN PRODUCT ON LINE.P_CODE = PRODUCT.P_CODE WHERE INV_NUMBER = p_inv_number;
END ;;
DELIMITER ;

/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UPDATE_CUSTOMER_NAME` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UPDATE_CUSTOMER_NAME`(IN p_cus_code INT , IN p_new_lname VARCHAR(10))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
    SET p_new_lname= TRIM(p_new_lname);
    
	IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE CUS_CODE = p_cus_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO CUSTOMER FOUND. CHECK CUSTOMER CODE.'; END IF;
	UPDATE CUSTOMER SET CUS_LNAME = p_new_lname WHERE CUS_CODE = p_cus_code;
    
	COMMIT;
    
    SELECT CUS_CODE, CUS_LNAME FROM CUSTOMER WHERE CUS_CODE = p_cus_code;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UPDATE_CUSTOMER_PHONE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UPDATE_CUSTOMER_PHONE`(IN p_cus_code INT, IN p_new_phone CHAR(10), IN secret_key VARCHAR(10))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UPDATE_DISCOUNT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UPDATE_DISCOUNT`(IN p_p_code INT, IN new_discount DECIMAL(5,2))
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
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UPDATE_JOB` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UPDATE_JOB`(IN p_emp_code INT, IN new_job VARCHAR(10))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    
    START TRANSACTION;
    
	IF NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_CODE = p_emp_code) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO EMPLOYEE FOUND. CHECK EMPLOYEE CODE.'; END IF;
    
    UPDATE EMPLOYEE SET EMP_JOB = UPPER(TRIM(new_job)) WHERE EMP_CODE = p_emp_code;
    
    COMMIT;
    
    SELECT EMP_CODE, EMP_LNAME, EMP_FNAME, EMP_JOB FROM EMPLOYEE WHERE EMP_CODE = p_emp_code;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UPDATE_PRICE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UPDATE_PRICE`(IN p_p_code INT, IN new_price DECIMAL(9,2))
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
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UPDATE_UNITS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UPDATE_UNITS`(IN p_inv_number INT, IN p_p_code INT, IN new_line_units INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `customer_invoice_summary`
--

/*!50001 DROP VIEW IF EXISTS `customer_invoice_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `customer_invoice_summary` AS select `customer`.`CUS_CODE` AS `CUS_CODE`,`customer`.`CUS_LNAME` AS `CUS_LNAME`,`invoice`.`INV_NUMBER` AS `INV_NUMBER`,`invoice`.`INV_DATE` AS `INV_DATE`,`invoice`.`INV_STATUS` AS `INV_STATUS`,`invoice`.`INV_TOTAL` AS `INV_TOTAL`,`invoice`.`EMP_CODE` AS `EMP_CODE` from (`customer` join `invoice` on((`customer`.`CUS_CODE` = `invoice`.`CUS_CODE`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `customer_purchase_summary`
--

/*!50001 DROP VIEW IF EXISTS `customer_purchase_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `customer_purchase_summary` AS select `customer`.`CUS_CODE` AS `CUS_CODE`,`customer`.`CUS_LNAME` AS `CUS_LNAME`,count(`invoice`.`INV_NUMBER`) AS `TOTAL_PAID_INVOICES`,coalesce(sum(`invoice`.`INV_TOTAL`),0) AS `TOTAL_SPENDING`,coalesce(round(avg(`invoice`.`INV_TOTAL`),2),0) AS `AVERAGE_SPENDING_PER_INVOICE` from (`customer` left join `invoice` on(((`customer`.`CUS_CODE` = `invoice`.`CUS_CODE`) and (`invoice`.`INV_STATUS` = 'PAID')))) group by `customer`.`CUS_CODE`,`customer`.`CUS_LNAME` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `monthly_product_sales_summary`
--

/*!50001 DROP VIEW IF EXISTS `monthly_product_sales_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `monthly_product_sales_summary` AS select year(`invoice`.`INV_DATE`) AS `SALE_YEAR`,month(`invoice`.`INV_DATE`) AS `SALE_MONTH`,`product`.`P_CODE` AS `P_CODE`,`product`.`P_DESCRIPT` AS `P_DESCRIPT`,`product`.`P_CATEGORY` AS `P_CATEGORY`,sum(`line`.`LINE_UNITS`) AS `TOTAL_UNITS_SOLD`,sum((`line`.`LINE_UNITS` * `line`.`LINE_PRICE`)) AS `TOTAL_REVENUE`,round(((sum((`line`.`LINE_UNITS` * `line`.`LINE_PRICE`)) / sum(sum((`line`.`LINE_UNITS` * `line`.`LINE_PRICE`))) OVER (PARTITION BY year(`invoice`.`INV_DATE`),month(`invoice`.`INV_DATE`) ) ) * 100),2) AS `REVENUE_PERCENTAGE`,(case when (sum(`line`.`LINE_UNITS`) < 5) then 'LOW' else 'NORMAL' end) AS `SALES_STATUS` from ((`product` join `line` on((`product`.`P_CODE` = `line`.`P_CODE`))) join `invoice` on((`line`.`INV_NUMBER` = `invoice`.`INV_NUMBER`))) where (`invoice`.`INV_STATUS` = 'PAID') group by year(`invoice`.`INV_DATE`),month(`invoice`.`INV_DATE`),`product`.`P_CODE`,`product`.`P_DESCRIPT`,`product`.`P_CATEGORY` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `monthly_revenue_summary`
--

/*!50001 DROP VIEW IF EXISTS `monthly_revenue_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `monthly_revenue_summary` AS select year(`invoice`.`INV_DATE`) AS `SALE_YEAR`,month(`invoice`.`INV_DATE`) AS `SALE_MONTH`,count(`invoice`.`INV_NUMBER`) AS `TOTAL_PAID_INVOICES`,sum(`invoice`.`INV_TOTAL`) AS `TOTAL_REVENUE`,round(avg(`invoice`.`INV_TOTAL`),2) AS `AVERAGE_REVENUE_PER_INVOICE` from `invoice` where (`invoice`.`INV_STATUS` = 'PAID') group by year(`invoice`.`INV_DATE`),month(`invoice`.`INV_DATE`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `yearly_product_sales_summary`
--

/*!50001 DROP VIEW IF EXISTS `yearly_product_sales_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `yearly_product_sales_summary` AS select year(`invoice`.`INV_DATE`) AS `SALE_YEAR`,`product`.`P_CODE` AS `P_CODE`,`product`.`P_DESCRIPT` AS `P_DESCRIPT`,`product`.`P_CATEGORY` AS `P_CATEGORY`,sum(`line`.`LINE_UNITS`) AS `TOTAL_UNITS_SOLD`,sum((`line`.`LINE_UNITS` * `line`.`LINE_PRICE`)) AS `TOTAL_REVENUE`,round(((sum((`line`.`LINE_UNITS` * `line`.`LINE_PRICE`)) / sum(sum((`line`.`LINE_UNITS` * `line`.`LINE_PRICE`))) OVER (PARTITION BY year(`invoice`.`INV_DATE`) ) ) * 100),2) AS `REVENUE_PERCENTAGE`,(case when (sum(`line`.`LINE_UNITS`) < 5) then 'LOW' else 'NORMAL' end) AS `SALES_STATUS` from ((`product` join `line` on((`product`.`P_CODE` = `line`.`P_CODE`))) join `invoice` on((`line`.`INV_NUMBER` = `invoice`.`INV_NUMBER`))) where (`invoice`.`INV_STATUS` = 'PAID') group by year(`invoice`.`INV_DATE`),`product`.`P_CODE`,`product`.`P_DESCRIPT`,`product`.`P_CATEGORY` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-12  0:10:13

