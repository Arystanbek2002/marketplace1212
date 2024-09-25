-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Сен 05 2024 г., 17:06
-- Версия сервера: 10.4.28-MariaDB
-- Версия PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `marketplace`
--

-- --------------------------------------------------------

--
-- Структура таблицы `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` text NOT NULL,
  `email` varchar(100) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `modified_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`, `email`, `first_name`, `last_name`, `created_at`, `modified_at`) VALUES
(1, 'bekenov', '231231', 'adsad@mail.ru', 'ads', 'asdada', '2024-08-09 08:21:57', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `cart_item`
--

CREATE TABLE `cart_item` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `cart_item`
--

INSERT INTO `cart_item` (`id`, `client_id`, `product_id`, `quantity`, `created_at`, `modified_at`) VALUES
(1, 2, 123, 2, '2024-08-09 08:10:34', '0000-00-00 00:00:00'),
(2, 3, 3, 1, '2024-08-09 08:21:06', '0000-00-00 00:00:00'),
(3, 2, 3, 1, '2024-08-09 08:21:11', '0000-00-00 00:00:00'),
(4, 1, 4, 1, '2024-08-09 08:21:15', '0000-00-00 00:00:00'),
(5, 5, 5, 1, '2024-08-09 08:21:21', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Структура таблицы `discount`
--

CREATE TABLE `discount` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `discount_percent` decimal(10,0) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `deleted_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `discount`
--

INSERT INTO `discount` (`id`, `product_id`, `name`, `description`, `discount_percent`, `active`, `created_at`, `modified_at`, `deleted_at`) VALUES
(1, 0, 'Ручка', 'Пишет', 44, 1, '2024-08-21 13:53:55', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(2, 0, 'Карандаш', 'Пишет', 44, 1, '2024-08-21 14:40:57', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(3, 0, 'Карандаш', 'Пишет', 44, 1, '2024-08-21 14:41:12', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(4, 2, 'Тетрадь', 'Пишет', 44, 1, '2024-08-21 14:42:35', '0000-00-00 00:00:00', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Структура таблицы `favorites`
--

CREATE TABLE `favorites` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `favorites`
--

INSERT INTO `favorites` (`id`, `product_id`, `client_id`) VALUES
(1, 1, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `image`
--

CREATE TABLE `image` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `image_url` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `image`
--

INSERT INTO `image` (`id`, `product_id`, `image_url`) VALUES
(1, 1, 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Macaca_nigra_self-portrait_large.jpg/220px-Macaca_nigra_self-portrait_large.jpg'),
(3, 2, 'https://avatars.dzeninfra.ru/get-zen_doc/9278169/pub_641d5026a56f6a4d500857d1_641e385b7eb49d4e1823543a/scale_1200');

-- --------------------------------------------------------

--
-- Структура таблицы `information`
--

CREATE TABLE `information` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `articul` int(255) NOT NULL,
  `brand` varchar(100) NOT NULL,
  `series` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL,
  `color` varchar(100) NOT NULL,
  `quantity` int(11) NOT NULL,
  `size` varchar(100) NOT NULL,
  `packing_size` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `information`
--

INSERT INTO `information` (`id`, `product_id`, `articul`, `brand`, `series`, `country`, `color`, `quantity`, `size`, `packing_size`) VALUES
(1, 456, 789, '1', '2', '3', '4', 100, '10', '5'),
(2, 1, 789, '1', '2', '3', '4', 100, '10', '5'),
(3, 2, 7892, '2', '3', '3', '4', 100, '10', '5'),
(4, 3, 7892, '2', '3', '3', '4', 100, '10', '5'),
(5, 4, 7892, '2', '3', '3', '4', 100, '10', '5'),
(6, 5, 7892, '2', '3', '3', '4', 100, '10', '5'),
(7, 6, 78923242, '2', '3', '3', '4', 12100, '10', '5'),
(8, 8, 7892242, '2', '3', '3', '4', 12100, '10', '5');

-- --------------------------------------------------------

--
-- Структура таблицы `order`
--

CREATE TABLE `order` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` varchar(50) NOT NULL,
  `address` varchar(50) NOT NULL,
  `price` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `order`
--

INSERT INTO `order` (`id`, `user_id`, `status`, `address`, `price`, `product_id`, `quantity`) VALUES
(1, 1, 'Доставлен', 'Астана', 11111, 0, 0),
(2, 123, 'pending', '123 Main St, Anytown, USA', 250, 2, 2),
(3, 2131, 'pending', '123 Main St, Anytown, USA', 250, 2, 2);

-- --------------------------------------------------------

--
-- Структура таблицы `order_item`
--

CREATE TABLE `order_item` (
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `qty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `order_item`
--

INSERT INTO `order_item` (`order_id`, `product_id`, `price`, `qty`) VALUES
(1, 1, 100, 2),
(2, 1, 12200, 2),
(3, 1, 12200, 2),
(5, 1, 12200, 2),
(4, 1, 122032420, 22);

-- --------------------------------------------------------

--
-- Структура таблицы `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `inventory_id` int(11) NOT NULL,
  `price` decimal(10,0) NOT NULL,
  `discount_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `category_id`, `inventory_id`, `price`, `discount_id`, `created_at`, `modified_at`) VALUES
(1, 'Product 1', '', 1, 0, 0, 0, '2024-07-12 01:47:17', '0000-00-00 00:00:00'),
(2, 'Системный блок', '', 0, 0, 0, 0, '2024-07-12 01:43:54', '0000-00-00 00:00:00'),
(3, 'Product Name', 'Description of the product', 10, 50, 100, 5, '2024-08-09 09:03:08', '0000-00-00 00:00:00'),
(4, 'asdad Name', 'Description of the product', 10, 50, 100, 5, '2024-08-09 09:03:13', '0000-00-00 00:00:00'),
(5, 'Стол', 'Лучший стол', 1, 2, 100, 1, '2024-08-20 13:29:00', '0000-00-00 00:00:00'),
(6, 'Стул', 'Лучший стул', 2, 2, 10000, 1, '2024-08-20 13:29:15', '0000-00-00 00:00:00'),
(7, 'Ручка', 'Лучшая ручка', 1, 2, 3, 1, '2024-08-20 13:29:38', '0000-00-00 00:00:00'),
(8, 'Ластик', 'Лучший ластик', 1, 1, 111, 1, '2024-08-20 13:30:03', '0000-00-00 00:00:00'),
(9, 'Карандаш', 'Лучший карандаш', 1, 1, 111, 1, '2024-08-20 13:30:21', '0000-00-00 00:00:00'),
(10, 'Фломастер', 'Рисует', 1, 1, 1, 1, '2024-08-20 13:30:39', '0000-00-00 00:00:00'),
(11, 'Ручка белая', 'Пишет', 1, 1, 100, 1, '2024-08-20 13:31:02', '0000-00-00 00:00:00'),
(12, 'Тетрадь', 'Бумажная', 1, 1, 1, 1, '2024-08-20 13:31:24', '0000-00-00 00:00:00'),
(13, 'Черная тетрадь', 'Темнее остальных', 1, 1, 1, 1, '2024-08-20 13:31:40', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Структура таблицы `product_category`
--

CREATE TABLE `product_category` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `desc` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `deleted_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `product_category`
--

INSERT INTO `product_category` (`id`, `name`, `desc`, `created_at`, `modified_at`, `deleted_at`) VALUES
(1, 'Канцелярские товары', 'Товары для школы', '2024-07-12 02:01:34', '2024-07-12 02:00:00', '2024-07-20 02:00:00');

-- --------------------------------------------------------

--
-- Структура таблицы `product_inventory`
--

CREATE TABLE `product_inventory` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `deleted_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `product_inventory`
--

INSERT INTO `product_inventory` (`id`, `product_id`, `quantity`, `created_at`, `modified_at`, `deleted_at`) VALUES
(1, 1, 1, '2024-08-09 09:31:57', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(2, 2, -2, '2024-08-09 09:39:05', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(3, 3, 3, '2024-08-09 09:32:13', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(4, 4, 4, '2024-08-09 09:32:18', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(5, 0, 5, '2024-08-09 07:54:56', '0000-00-00 00:00:00', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Структура таблицы `reviews`
--

CREATE TABLE `reviews` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `review` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `reviews`
--

INSERT INTO `reviews` (`id`, `product_id`, `rating`, `review`) VALUES
(1, 1, 5, 'Советую!'),
(2, 1, 1, 'Херня'),
(3, 1, 1, 'Good');

-- --------------------------------------------------------

--
-- Структура таблицы `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `telephone` int(11) NOT NULL,
  `password` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `user`
--

INSERT INTO `user` (`id`, `telephone`, `password`, `created_at`, `modified_at`) VALUES
(1, 1234567890, '$2a$12$pbPHPFLrTtFK8b44E1mj2u4SyA.EWyAdmhBLjqpmYrZvuHiJHoUIK', '2024-08-09 08:30:38', '0000-00-00 00:00:00'),
(2, 1234567890, '$2a$12$hGrhaKKRbTiZ2mgqxyN7TOyveW/IF.t3MFFICmC/ytB5sA8xUI/DS', '2024-08-09 08:30:45', '0000-00-00 00:00:00'),
(3, 1234567890, '$2a$12$ONuwPTSN69bS0htYrRkb9.yguCFG02l/3W/GXDGNPFTziYBroAX3a', '2024-08-09 08:30:53', '0000-00-00 00:00:00'),
(4, 1234567890, '$2a$12$JygTTpUJNFNmXDBUgrUgSeVvlm/O4Amnqkaz8i8BX0TbUEUrt7ql2', '2024-08-09 08:30:56', '0000-00-00 00:00:00'),
(5, 1234567890, '$2a$12$u5k80ag3/mRL2EdzCN1fxuxwR/0QX.3QVXrbUugP3cIFej5eby5Xi', '2024-08-09 09:39:50', '0000-00-00 00:00:00'),
(6, 1234567890, '$2a$12$ajXCmsFQRqu6ENIsHyBNmODv/J6Mo1pgBFu7Bzo6iogVZnD9nNffm', '2024-08-09 09:39:59', '0000-00-00 00:00:00'),
(7, 1312131, '$2a$12$hwYLfzL40X4HlSwgPb3j9O2tAVLnvbl92QTLUgVULTxx/iTV79gU2', '2024-08-09 09:45:23', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Структура таблицы `user_address`
--

CREATE TABLE `user_address` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `address_line1` varchar(100) NOT NULL,
  `address_line2` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `postal_code` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL,
  `telephone` varchar(100) NOT NULL,
  `mobile` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `user_address`
--

INSERT INTO `user_address` (`id`, `user_id`, `address_line1`, `address_line2`, `city`, `postal_code`, `country`, `telephone`, `mobile`) VALUES
(1, 1, 'asdada', 'asdad', 'Astana', '00000', 'Kaz', '111', '111');

-- --------------------------------------------------------

--
-- Структура таблицы `user_law`
--

CREATE TABLE `user_law` (
  `company_name` varchar(100) NOT NULL,
  `contact_name` varchar(100) NOT NULL,
  `password` text NOT NULL,
  `law_address` text NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` int(11) NOT NULL,
  `bin` int(11) NOT NULL,
  `bik` int(11) NOT NULL,
  `iik` int(11) NOT NULL,
  `bank` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `user_law`
--

INSERT INTO `user_law` (`company_name`, `contact_name`, `password`, `law_address`, `email`, `phone`, `bin`, `bik`, `iik`, `bank`) VALUES
('Nusa', 'Nursultan', '$2a$12$hJgyM4IaTmXnZQItCFdTHOMcax/intlLSSFWjv5MEzJaC.gsFSzXi', 'Astana', 'nursultan.bekenov1@gmail.com', 1234567, 44444, 45678, 9499866, 'Kaspi bank');

-- --------------------------------------------------------

--
-- Структура таблицы `user_payment`
--

CREATE TABLE `user_payment` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `payment_type` varchar(100) NOT NULL,
  `provider` varchar(100) NOT NULL,
  `account_no` int(11) NOT NULL,
  `expiry` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `user_payment`
--

INSERT INTO `user_payment` (`id`, `user_id`, `payment_type`, `provider`, `account_no`, `expiry`) VALUES
(1, 1, 'Kaspi', 'None', 1, '2024-08-09');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `cart_item`
--
ALTER TABLE `cart_item`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `discount`
--
ALTER TABLE `discount`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `image`
--
ALTER TABLE `image`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `information`
--
ALTER TABLE `information`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `product_category`
--
ALTER TABLE `product_category`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `product_inventory`
--
ALTER TABLE `product_inventory`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `user_address`
--
ALTER TABLE `user_address`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `user_payment`
--
ALTER TABLE `user_payment`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `cart_item`
--
ALTER TABLE `cart_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `discount`
--
ALTER TABLE `discount`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `image`
--
ALTER TABLE `image`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `information`
--
ALTER TABLE `information`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `order`
--
ALTER TABLE `order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT для таблицы `product_category`
--
ALTER TABLE `product_category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `product_inventory`
--
ALTER TABLE `product_inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `user_address`
--
ALTER TABLE `user_address`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `user_payment`
--
ALTER TABLE `user_payment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
