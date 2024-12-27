-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 27, 2024 at 05:03 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sales_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `guest`
--

CREATE TABLE `guest` (
  `id` int(11) NOT NULL,
  `fullname` varchar(200) NOT NULL,
  `contact` varchar(100) NOT NULL,
  `address` text NOT NULL,
  `email` varchar(200) NOT NULL,
  `password` varchar(255) NOT NULL,
  `salt` varchar(64) NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 3 COMMENT '1=SalesSV, 2=Clerks, 3=Guest',
  `date_created` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `guest`
--

INSERT INTO `guest` (`id`, `fullname`, `contact`, `address`, `email`, `password`, `salt`, `type`, `date_created`) VALUES
(1, 'Supervisor', '1234567890', '123 Main Street', 'supervisor@example.com', '1425d5d3160aa6bd140605cc75e63ce0', '', 1, '2024-12-27 22:47:34'),
(2, 'Clerk1', '9876543210', '456 Elm Street', 'clerk1@example.com', 'ad4ac7fa40b0af2bae7374c57173f26c', '', 2, '2024-12-27 22:47:34'),
(3, 'Clerk2', '5678901234', '789 Oak Avenue', 'clerk2@example.com', 'ad4ac7fa40b0af2bae7374c57173f26c', '', 2, '2024-12-27 22:47:34'),
(4, 'Tuan Muhammad Farhan Bin Tuan Rashid', '0197909367', 'No s-48/50-a batu 1  1/2', 'farhanrashid293@gmail.com', 'fba38b34999e2bf6b04b939e61951e03e48979a072bf7f496e109f23090aa9e5', 'fca5f92ad922ee2af30c62342d2fe80021dcc5e0ba3e412c40b8e10e396f4131', 3, '2024-12-27 23:33:23');

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `id` int(11) NOT NULL,
  `product_name` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `category` varchar(50) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `stock_level` int(11) NOT NULL,
  `reorder_point` int(11) NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`id`, `product_name`, `description`, `category`, `unit_price`, `stock_level`, `reorder_point`, `status`, `created_at`, `updated_at`) VALUES
(1, 'White Bread', 'Fresh white bread', 'Bread', 3.50, 50, 20, 'active', '2024-12-27 15:41:16', '2024-12-27 15:41:16'),
(2, 'Whole Wheat Bread', 'Healthy whole wheat bread', 'Bread', 4.00, 38, 15, 'active', '2024-12-27 15:41:16', '2024-12-27 15:56:31'),
(3, 'Chocolate Croissant', 'Buttery croissant with chocolate', 'Pastries', 2.50, 30, 10, 'active', '2024-12-27 15:41:16', '2024-12-27 15:41:16'),
(4, 'Plain Croissant', 'Classic butter croissant', 'Pastries', 2.00, 35, 12, 'active', '2024-12-27 15:41:16', '2024-12-27 15:41:16'),
(5, 'Cheese Cake', 'New York style cheese cake', 'Cakes', 25.00, 10, 5, 'active', '2024-12-27 15:41:16', '2024-12-27 15:41:16'),
(6, 'Chocolate Cake', 'Rich chocolate cake', 'Cakes', 30.00, 8, 4, 'active', '2024-12-27 15:41:16', '2024-12-27 15:41:16'),
(7, 'Butter Cookies', 'Traditional butter cookies', 'Cookies', 8.00, 25, 10, 'active', '2024-12-27 15:41:16', '2024-12-27 15:41:16'),
(8, 'Raisin Bread', 'Sweet bread with raisins', 'Bread', 4.50, 17, 8, 'active', '2024-12-27 15:41:16', '2024-12-27 15:56:31');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `guest_id` int(11) NOT NULL,
  `order_number` varchar(20) NOT NULL,
  `order_date` datetime NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('pending','confirmed','processing','ready','delivered','cancelled') DEFAULT 'pending',
  `payment_method` enum('cash','card','online') NOT NULL,
  `payment_status` enum('pending','paid','failed') DEFAULT 'pending',
  `delivery_address` text DEFAULT NULL,
  `order_type` enum('in-store','online','phone') NOT NULL,
  `clerk_id` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `guest_id`, `order_number`, `order_date`, `total_amount`, `status`, `payment_method`, `payment_status`, `delivery_address`, `order_type`, `clerk_id`, `notes`, `created_at`) VALUES
(1, 4, 'ORD1735314644', '2024-12-27 23:50:44', 4.50, 'pending', '', 'pending', 'No s-48/50-a batu 1  1/2', 'online', NULL, NULL, '2024-12-27 15:50:44'),
(2, 4, 'ORD1735314991', '2024-12-27 23:56:31', 17.00, 'pending', '', 'pending', 'No s-48/50-a batu 1  1/2', 'online', NULL, NULL, '2024-12-27 15:56:31');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `unit_price`, `subtotal`) VALUES
(1, 1, 8, 1, 4.50, 4.50),
(2, 2, 8, 2, 4.50, 9.00),
(3, 2, 2, 2, 4.00, 8.00);

-- --------------------------------------------------------

--
-- Table structure for table `promotions`
--

CREATE TABLE `promotions` (
  `id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `discount_type` enum('percentage','fixed') NOT NULL,
  `discount_value` decimal(10,2) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `promotions`
--

INSERT INTO `promotions` (`id`, `code`, `description`, `discount_type`, `discount_value`, `start_date`, `end_date`, `status`) VALUES
(1, 'WELCOME10', 'Welcome discount 10%', 'percentage', 10.00, '2024-01-01', '2024-12-31', 'active'),
(2, 'SAVE5', 'RM5 off for orders above RM50', 'fixed', 5.00, '2024-01-01', '2024-12-31', 'active');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `guest`
--
ALTER TABLE `guest`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_orders_guest` (`guest_id`),
  ADD KEY `fk_orders_clerk` (`clerk_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_orderitems_order` (`order_id`),
  ADD KEY `fk_orderitems_product` (`product_id`);

--
-- Indexes for table `promotions`
--
ALTER TABLE `promotions`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `guest`
--
ALTER TABLE `guest`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `promotions`
--
ALTER TABLE `promotions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_clerk` FOREIGN KEY (`clerk_id`) REFERENCES `guest` (`id`),
  ADD CONSTRAINT `fk_orders_guest` FOREIGN KEY (`guest_id`) REFERENCES `guest` (`id`),
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`guest_id`) REFERENCES `guest` (`id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`clerk_id`) REFERENCES `guest` (`id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_orderitems_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `fk_orderitems_product` FOREIGN KEY (`product_id`) REFERENCES `inventory` (`id`),
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `inventory` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
