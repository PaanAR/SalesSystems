-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 28, 2024 at 05:02 AM
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
-- Table structure for table `daily_sales`
--

CREATE TABLE `daily_sales` (
  `id` int(11) NOT NULL,
  `clerk_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `total_orders` int(11) DEFAULT 0,
  `total_sales` decimal(10,2) DEFAULT 0.00,
  `cash_orders` int(11) DEFAULT 0,
  `cash_sales` decimal(10,2) DEFAULT 0.00,
  `card_orders` int(11) DEFAULT 0,
  `card_sales` decimal(10,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `daily_sales`
--

INSERT INTO `daily_sales` (`id`, `clerk_id`, `date`, `total_orders`, `total_sales`, `cash_orders`, `cash_sales`, `card_orders`, `card_sales`, `created_at`) VALUES
(1, 6, '2024-12-28', 6, 113.50, 5, 78.00, 1, 35.50, '2024-12-27 18:44:45'),
(5, 16, '2024-12-28', 1, 12.00, 1, 12.00, 0, 0.00, '2024-12-28 03:45:51');

-- --------------------------------------------------------

--
-- Table structure for table `employee_ids`
--

CREATE TABLE `employee_ids` (
  `id` int(11) NOT NULL,
  `employee_id` varchar(255) NOT NULL,
  `fullname` varchar(200) NOT NULL,
  `role` enum('Supervisor','Clerk') NOT NULL,
  `assigned` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_ids`
--

INSERT INTO `employee_ids` (`id`, `employee_id`, `fullname`, `role`, `assigned`, `created_at`) VALUES
(1, 'SV-1001', 'Alice Johnson', 'Supervisor', 0, '2024-12-28 02:43:55'),
(2, 'SV-1002', 'Bob Smith', 'Supervisor', 1, '2024-12-28 02:43:55'),
(3, 'CL-2001', 'Charlie Brown', 'Clerk', 0, '2024-12-28 02:43:55'),
(4, 'CL-2002', 'Diana Prince', 'Clerk', 1, '2024-12-28 02:43:55');

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
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `employee_id` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `guest`
--

INSERT INTO `guest` (`id`, `fullname`, `contact`, `address`, `email`, `password`, `salt`, `type`, `date_created`, `employee_id`) VALUES
(4, 'Tuan Muhammad Farhan Bin Tuan Rashid', '0197909367', 'No s-48/50-a batu 1  1/2', 'farhanrashid293@gmail.com', 'fba38b34999e2bf6b04b939e61951e03e48979a072bf7f496e109f23090aa9e5', 'fca5f92ad922ee2af30c62342d2fe80021dcc5e0ba3e412c40b8e10e396f4131', 3, '2024-12-27 23:33:23', NULL),
(5, 'Tuan Muhammad Farhan Bin Tuan Rashid', '0197909367', 'NO S-48/50-A BATU 1  1/2\r\nJALAN PENGKALAN CHEPA', 'farhanras@gmail.com', '$2y$10$QTXJAwLXqGqmTO9d.duy.uQRubI1lSlINF/k58gTnmZOVZ8RhkNjW', '28a9773d496d0119b56c221fa55a6f32467c03094c4697cd7764ec3f0a75894c', 3, '2024-12-28 01:33:17', NULL),
(6, 'Clerk inas', '01112222342', 'No s-48/50-a batul 1  1/2', 'inas@gmail.com', '$2y$10$tIYTyPG4.DDUFqQ3o90KJer69VmJ7bx8C3SZ/RhmhB.QUhvhMAIqu', '0b28f58038873d511d86a428b755ce286ccadcc388b371c89e079ac80a076233', 2, '2024-12-28 02:00:56', NULL),
(7, '', '', '-', 'walk-in-1735324293', '', '', 3, '2024-12-28 02:31:33', NULL),
(8, 'farhanrashid', '0197909367', '-', 'walk-in-1735324429', '', '', 3, '2024-12-28 02:33:49', NULL),
(9, 'PAAN', '0197909367', '-', 'walk-in-1735324784', '', '', 3, '2024-12-28 02:39:44', NULL),
(10, 'farhan', '0197909367', '-', 'walk-in-1735325157', '', '', 3, '2024-12-28 02:45:57', NULL),
(11, 'Ikmal', '01112222341', '-', 'walk-in-1735344994', '', '', 3, '2024-12-28 08:16:34', NULL),
(12, 'Hafizudin', '0123212121', '-', 'walk-in-1735346393', '', '', 3, '2024-12-28 08:39:53', NULL),
(15, 'Bob Smith', '0112223333', '', 'bob@gmail.com', '$2y$10$t4jxQs6rBbqH4x14B00lf.0Bt1/xJsfbEOwuqAtwRk5HgLzpRM6EG', '', 1, '2024-12-28 11:09:06', 'SV-1002'),
(16, 'Diana Prince', '01122233332', '', 'diana@gmail.com', '$2y$10$s1OvABlalF5X66aXXHscaOIV2BQD1ynvAqghtxAuuPqcUPv3LEcuO', '', 2, '2024-12-28 11:11:12', 'CL-2002'),
(17, 'farhanrashid', '0197909367', '-', 'walk-in-1735357551', '', '', 3, '2024-12-28 11:45:51', NULL);

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
(1, 'White Bread', 'Fresh white bread', 'Bread', 3.50, 33, 20, 'active', '2024-12-27 15:41:16', '2024-12-28 03:45:51'),
(2, 'Whole Wheat Bread', 'Healthy whole wheat bread', 'Bread', 4.00, 37, 15, 'active', '2024-12-27 15:41:16', '2024-12-28 03:45:51'),
(3, 'Chocolate Croissant', 'Buttery croissant with chocolate', 'Pastries', 2.50, 29, 10, 'active', '2024-12-27 15:41:16', '2024-12-28 00:39:53'),
(4, 'Plain Croissant', 'Classic butter croissant', 'Pastries', 2.00, 35, 12, 'active', '2024-12-27 15:41:16', '2024-12-27 15:41:16'),
(5, 'Cheese Cake', 'New York style cheese cake', 'Cakes', 25.00, 8, 5, 'active', '2024-12-27 15:41:16', '2024-12-28 00:39:53'),
(6, 'Chocolate Cake', 'Rich chocolate cake', 'Cakes', 30.00, 8, 4, 'active', '2024-12-27 15:41:16', '2024-12-27 15:41:16'),
(7, 'Butter Cookies', 'Traditional butter cookies', 'Cookies', 8.00, 23, 10, 'active', '2024-12-27 15:41:16', '2024-12-28 00:39:53'),
(8, 'Raisin Bread', 'Sweet bread with raisins', 'Bread', 4.50, 3, 8, 'active', '2024-12-27 15:41:16', '2024-12-28 03:45:51');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_transactions`
--

CREATE TABLE `inventory_transactions` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `clerk_id` int(11) DEFAULT NULL,
  `transaction_type` enum('sale','restock','adjustment') NOT NULL,
  `quantity` int(11) NOT NULL,
  `previous_stock` int(11) NOT NULL,
  `new_stock` int(11) NOT NULL,
  `transaction_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_transactions`
--

INSERT INTO `inventory_transactions` (`id`, `product_id`, `order_id`, `clerk_id`, `transaction_type`, `quantity`, `previous_stock`, `new_stock`, `transaction_date`) VALUES
(1, 8, 14, 6, 'sale', 2, 15, 13, '2024-12-27 18:31:33'),
(2, 1, 14, 6, 'sale', 2, 48, 46, '2024-12-27 18:31:33'),
(3, 8, 15, 6, 'sale', 1, 11, 10, '2024-12-27 18:33:49'),
(4, 8, 16, 6, 'sale', 1, 9, 8, '2024-12-27 18:39:44'),
(5, 1, 16, 6, 'sale', 1, 44, 43, '2024-12-27 18:39:44'),
(6, 8, 17, 6, 'sale', 3, 8, 5, '2024-12-27 18:45:57'),
(7, 1, 17, 6, 'sale', 8, 43, 35, '2024-12-27 18:45:57'),
(8, 8, 18, 6, 'sale', 1, 5, 4, '2024-12-28 00:16:34'),
(9, 1, 18, 6, 'sale', 1, 35, 34, '2024-12-28 00:16:34'),
(10, 5, 19, 6, 'sale', 1, 9, 8, '2024-12-28 00:39:53'),
(11, 7, 19, 6, 'sale', 1, 24, 23, '2024-12-28 00:39:53'),
(12, 3, 19, 6, 'sale', 1, 30, 29, '2024-12-28 00:39:53'),
(13, 8, 20, 16, 'sale', 1, 4, 3, '2024-12-28 03:45:51'),
(14, 1, 20, 16, 'sale', 1, 34, 33, '2024-12-28 03:45:51'),
(15, 2, 20, 16, 'sale', 1, 38, 37, '2024-12-28 03:45:51');

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
  `status` enum('pending','processing','completed','cancelled') NOT NULL DEFAULT 'pending',
  `payment_method` enum('cash','card','online') NOT NULL,
  `payment_status` enum('pending','paid','failed') NOT NULL DEFAULT 'pending',
  `delivery_address` text DEFAULT NULL,
  `order_type` enum('in-store','online') NOT NULL,
  `clerk_id` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `guest_id`, `order_number`, `order_date`, `total_amount`, `status`, `payment_method`, `payment_status`, `delivery_address`, `order_type`, `clerk_id`, `notes`, `created_at`) VALUES
(1, 4, 'ORD1735314644', '2024-12-27 23:50:44', 4.50, 'pending', '', 'pending', 'No s-48/50-a batu 1  1/2', 'online', NULL, NULL, '2024-12-27 15:50:44'),
(2, 4, 'ORD1735314991', '2024-12-27 23:56:31', 17.00, 'pending', '', 'pending', 'No s-48/50-a batu 1  1/2', 'online', NULL, NULL, '2024-12-27 15:56:31'),
(3, 4, 'ORD1735317317', '2024-12-28 00:35:17', 8.00, 'pending', '', 'pending', 'No s-48/50-a batu 1  1/2', 'online', NULL, NULL, '2024-12-27 16:35:17'),
(4, 5, 'ORD1735320840', '2024-12-28 01:34:00', 16.00, 'pending', '', 'pending', 'NO S-48/50-A BATU 1  1/2\r\nJALAN PENGKALAN CHEPA', 'online', NULL, NULL, '2024-12-27 17:34:00'),
(5, 5, 'ORD1735320884', '2024-12-28 01:34:44', 25.00, 'pending', '', 'pending', 'NO S-48/50-A BATU 1  1/2\r\nJALAN PENGKALAN CHEPA', 'online', NULL, NULL, '2024-12-27 17:34:44'),
(14, 7, 'POS1735324293', '2024-12-28 02:31:33', 16.00, 'completed', 'cash', 'paid', NULL, 'in-store', 6, NULL, '2024-12-27 18:31:33'),
(15, 8, 'POS1735324429', '2024-12-28 02:33:49', 4.50, 'completed', 'cash', 'paid', NULL, 'in-store', 6, NULL, '2024-12-27 18:33:49'),
(16, 9, 'POS1735324784', '2024-12-28 02:39:44', 8.00, 'completed', 'cash', 'paid', NULL, 'in-store', 6, NULL, '2024-12-27 18:39:44'),
(17, 10, 'POS1735325157', '2024-12-28 02:45:57', 41.50, 'completed', 'cash', 'paid', NULL, 'in-store', 6, NULL, '2024-12-27 18:45:57'),
(18, 11, 'POS1735344994', '2024-12-28 08:16:34', 8.00, 'completed', 'cash', 'paid', NULL, 'in-store', 6, NULL, '2024-12-28 00:16:34'),
(19, 12, 'POS1735346393', '2024-12-28 08:39:53', 35.50, 'completed', 'card', 'paid', NULL, 'in-store', 6, NULL, '2024-12-28 00:39:53'),
(20, 17, 'POS1735357551', '2024-12-28 11:45:51', 12.00, 'completed', 'cash', 'paid', NULL, 'in-store', 16, NULL, '2024-12-28 03:45:51');

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `after_order_insert` AFTER INSERT ON `orders` FOR EACH ROW BEGIN
    INSERT INTO daily_sales (
        clerk_id, 
        date, 
        total_orders,
        total_sales,
        cash_orders,
        cash_sales,
        card_orders,
        card_sales
    )
    VALUES (
        NEW.clerk_id,
        DATE(NEW.order_date),
        1,
        NEW.total_amount,
        IF(NEW.payment_method = 'cash', 1, 0),
        IF(NEW.payment_method = 'cash', NEW.total_amount, 0),
        IF(NEW.payment_method = 'card', 1, 0),
        IF(NEW.payment_method = 'card', NEW.total_amount, 0)
    )
    ON DUPLICATE KEY UPDATE
        total_orders = total_orders + 1,
        total_sales = total_sales + VALUES(total_sales),
        cash_orders = cash_orders + VALUES(cash_orders),
        cash_sales = cash_sales + VALUES(cash_sales),
        card_orders = card_orders + VALUES(card_orders),
        card_sales = card_sales + VALUES(card_sales);
END
$$
DELIMITER ;

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
(3, 2, 2, 2, 4.00, 8.00),
(4, 3, 7, 1, 8.00, 8.00),
(5, 4, 8, 2, 4.50, 9.00),
(6, 4, 1, 2, 3.50, 7.00),
(7, 5, 5, 1, 25.00, 25.00),
(8, 14, 8, 2, 4.50, 9.00),
(9, 14, 1, 2, 3.50, 7.00),
(10, 15, 8, 1, 4.50, 4.50),
(11, 16, 8, 1, 4.50, 4.50),
(12, 16, 1, 1, 3.50, 3.50),
(13, 17, 8, 3, 4.50, 13.50),
(14, 17, 1, 8, 3.50, 28.00),
(15, 18, 8, 1, 4.50, 4.50),
(16, 18, 1, 1, 3.50, 3.50),
(17, 19, 5, 1, 25.00, 25.00),
(18, 19, 7, 1, 8.00, 8.00),
(19, 19, 3, 1, 2.50, 2.50),
(20, 20, 8, 1, 4.50, 4.50),
(21, 20, 1, 1, 3.50, 3.50),
(22, 20, 2, 1, 4.00, 4.00);

--
-- Triggers `order_items`
--
DELIMITER $$
CREATE TRIGGER `after_order_item_insert` AFTER INSERT ON `order_items` FOR EACH ROW BEGIN
    -- Update inventory stock level
    UPDATE inventory 
    SET stock_level = stock_level - NEW.quantity 
    WHERE id = NEW.product_id;
    
    -- Record inventory transaction
    INSERT INTO inventory_transactions (
        product_id, 
        order_id, 
        clerk_id,
        transaction_type,
        quantity,
        previous_stock,
        new_stock
    )
    SELECT 
        NEW.product_id,
        NEW.order_id,
        o.clerk_id,
        'sale',
        NEW.quantity,
        i.stock_level + NEW.quantity,
        i.stock_level
    FROM orders o
    JOIN inventory i ON i.id = NEW.product_id
    WHERE o.id = NEW.order_id;
END
$$
DELIMITER ;

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
-- Indexes for table `daily_sales`
--
ALTER TABLE `daily_sales`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_clerk_date` (`clerk_id`,`date`);

--
-- Indexes for table `employee_ids`
--
ALTER TABLE `employee_ids`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `employee_id` (`employee_id`);

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
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_inventory_status` (`status`);

--
-- Indexes for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `clerk_id` (`clerk_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_orders_clerk_date` (`clerk_id`,`order_date`),
  ADD KEY `idx_orders_status` (`status`),
  ADD KEY `fk_orders_guest` (`guest_id`);

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
-- AUTO_INCREMENT for table `daily_sales`
--
ALTER TABLE `daily_sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `employee_ids`
--
ALTER TABLE `employee_ids`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `guest`
--
ALTER TABLE `guest`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `promotions`
--
ALTER TABLE `promotions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `daily_sales`
--
ALTER TABLE `daily_sales`
  ADD CONSTRAINT `daily_sales_ibfk_1` FOREIGN KEY (`clerk_id`) REFERENCES `guest` (`id`);

--
-- Constraints for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  ADD CONSTRAINT `inventory_transactions_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `inventory` (`id`),
  ADD CONSTRAINT `inventory_transactions_ibfk_2` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `inventory_transactions_ibfk_3` FOREIGN KEY (`clerk_id`) REFERENCES `guest` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_clerk` FOREIGN KEY (`clerk_id`) REFERENCES `guest` (`id`),
  ADD CONSTRAINT `fk_orders_guest` FOREIGN KEY (`guest_id`) REFERENCES `guest` (`id`);

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
