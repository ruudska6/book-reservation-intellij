-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: book_reservation
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
-- Table structure for table `borrow`
--

DROP TABLE IF EXISTS `borrow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `borrow` (
  `borrowId` int NOT NULL AUTO_INCREMENT,
  `bookId` int NOT NULL,
  `userId` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `isbn` varchar(20) NOT NULL,
  `callNum` varchar(50) NOT NULL,
  `borrowDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dueDate` datetime NOT NULL,
  `returnDate` datetime DEFAULT NULL,
  `state` enum('Active','Returned','Overdue') NOT NULL DEFAULT 'Active',
  PRIMARY KEY (`borrowId`),
  KEY `idx_borrow_user` (`userId`,`state`),
  KEY `idx_borrow_book` (`bookId`,`state`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrow`
--

LOCK TABLES `borrow` WRITE;
/*!40000 ALTER TABLE `borrow` DISABLE KEYS */;
INSERT INTO `borrow` VALUES (19,122,6,'Do it! 점프 투 파이썬','9791188612532','005','2025-08-22 16:39:52','2025-09-05 16:39:52','2025-08-22 16:39:58','Returned'),(20,122,6,'Do it! 점프 투 파이썬','9791188612532','005','2025-08-22 16:50:52','2025-09-05 16:50:52','2025-08-22 16:51:10','Returned'),(21,148,8,'1984','9788937460447','800','2025-08-22 16:59:02','2025-09-05 16:59:02',NULL,'Active'),(22,146,10,'총, 균, 쇠','9788970128859','300','2025-08-25 09:19:44','2025-09-08 09:19:44','2025-08-25 09:20:25','Returned'),(23,122,6,'Do it! 점프 투 파이썬','9791188612532','005','2025-08-25 09:53:48','2025-09-08 09:53:48','2025-09-05 17:01:09','Returned'),(24,126,7,'파이썬 코딩 도장','9791165210144','005','2025-08-25 10:49:53','2025-09-08 10:49:53','2025-08-25 10:50:07','Returned'),(25,126,6,'파이썬 코딩 도장','9791165210144','005','2025-08-25 11:14:57','2025-09-08 11:14:57',NULL,'Active'),(26,122,1,'Do it! 점프 투 파이썬','9791188612532','005','2025-09-05 17:27:58','2025-09-19 17:27:58','2025-09-05 17:28:12','Returned');
/*!40000 ALTER TABLE `borrow` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-09  9:26:55
