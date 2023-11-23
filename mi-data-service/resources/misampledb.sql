-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Feb 20, 2023 at 01:20 PM
-- Server version: 8.0.32
-- PHP Version: 7.4.3-4ubuntu2.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `misampledb`
--

-- --------------------------------------------------------

--
-- Table structure for table `Employees`
--

CREATE TABLE `Employees` (
  `EmployeeNumber` int NOT NULL,
  `FirstName` varchar(255) NOT NULL,
  `LastName` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Salary` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Employees`
--

INSERT INTO `Employees` (`EmployeeNumber`, `FirstName`, `LastName`, `Email`, `Salary`) VALUES (14001, 'Will', 'Smith', 'will@google.com', '12000.0');
INSERT INTO `Employees` (`EmployeeNumber`, `FirstName`, `LastName`, `Email`, `Salary`) VALUES (14002, 'Sam', 'Rayan', 'sam@google.com', '1600.0');
INSERT INTO `Employees` (`EmployeeNumber`, `FirstName`, `LastName`, `Email`, `Salary`) VALUES (14003, 'John', 'Ben', 'john@google.com', '18500.0');
INSERT INTO `Employees` (`EmployeeNumber`, `FirstName`, `LastName`, `Email`, `Salary`) VALUES (14004, 'Mash', 'Sean', 'mash@google.com', '17500.0');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
