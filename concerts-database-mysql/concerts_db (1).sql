-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 29-Dez-2025 às 15:38
-- Versão do servidor: 10.4.32-MariaDB
-- versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `concerts_db`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `customers`
--

CREATE TABLE `customers` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `customer_sales_summary`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `customer_sales_summary` (
`customer_id` int(11)
,`customer_name` varchar(100)
,`number_of_tickets_purchased` bigint(21)
,`total_spent` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Estrutura da tabela `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `venue` varchar(100) NOT NULL,
  `capacity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `event_details`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `event_details` (
`event_id` int(11)
,`event_name` varchar(100)
,`description` text
,`date` date
,`time` time
,`venue` varchar(100)
,`capacity` int(11)
,`total_tickets` bigint(21)
,`sold_tickets` bigint(21)
,`available_tickets` bigint(22)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `event_sales_summary`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `event_sales_summary` (
`event_id` int(11)
,`event_name` varchar(100)
,`number_of_tickets_sold` bigint(21)
,`total_revenue` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Estrutura da tabela `sales`
--

CREATE TABLE `sales` (
  `id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `sale_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `seat_number` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `tickets_status`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `tickets_status` (
`ticket_id` int(11)
,`event_name` varchar(100)
,`price` decimal(10,2)
,`seat_number` varchar(10)
,`status` varchar(9)
);

-- --------------------------------------------------------

--
-- Estrutura para vista `customer_sales_summary`
--
DROP TABLE IF EXISTS `customer_sales_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `customer_sales_summary`  AS SELECT `c`.`id` AS `customer_id`, `c`.`name` AS `customer_name`, count(`s`.`id`) AS `number_of_tickets_purchased`, coalesce(sum(`t`.`price`),0) AS `total_spent` FROM ((`customers` `c` left join `sales` `s` on(`c`.`id` = `s`.`customer_id`)) left join `tickets` `t` on(`s`.`ticket_id` = `t`.`id`)) GROUP BY `c`.`id` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `event_details`
--
DROP TABLE IF EXISTS `event_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `event_details`  AS SELECT `e`.`id` AS `event_id`, `e`.`name` AS `event_name`, `e`.`description` AS `description`, `e`.`date` AS `date`, `e`.`time` AS `time`, `e`.`venue` AS `venue`, `e`.`capacity` AS `capacity`, count(`t`.`id`) AS `total_tickets`, count(`s`.`id`) AS `sold_tickets`, count(`t`.`id`) - count(`s`.`id`) AS `available_tickets` FROM ((`events` `e` left join `tickets` `t` on(`e`.`id` = `t`.`event_id`)) left join `sales` `s` on(`t`.`id` = `s`.`ticket_id`)) GROUP BY `e`.`id` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `event_sales_summary`
--
DROP TABLE IF EXISTS `event_sales_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `event_sales_summary`  AS SELECT `e`.`id` AS `event_id`, `e`.`name` AS `event_name`, count(`s`.`id`) AS `number_of_tickets_sold`, coalesce(sum(`t`.`price`),0) AS `total_revenue` FROM ((`events` `e` left join `tickets` `t` on(`e`.`id` = `t`.`event_id`)) left join `sales` `s` on(`t`.`id` = `s`.`ticket_id`)) GROUP BY `e`.`id` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `tickets_status`
--
DROP TABLE IF EXISTS `tickets_status`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tickets_status`  AS SELECT `t`.`id` AS `ticket_id`, `e`.`name` AS `event_name`, `t`.`price` AS `price`, `t`.`seat_number` AS `seat_number`, CASE WHEN `s`.`id` is not null THEN 'Sold' ELSE 'Available' END AS `status` FROM ((`tickets` `t` join `events` `e` on(`t`.`event_id` = `e`.`id`)) left join `sales` `s` on(`t`.`id` = `s`.`ticket_id`)) ;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ticket_id` (`ticket_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Índices para tabela `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`),
  ADD CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`);

--
-- Limitadores para a tabela `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `tickets_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
