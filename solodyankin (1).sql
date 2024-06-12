-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Июн 12 2024 г., 21:00
-- Версия сервера: 8.0.19
-- Версия PHP: 7.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `solodyankin`
--

-- --------------------------------------------------------

--
-- Структура таблицы `activ`
--

CREATE TABLE `activ` (
  `id` int NOT NULL,
  `cabNumber` varchar(50) NOT NULL COMMENT 'Номер кабинета',
  `departamentId` int NOT NULL COMMENT 'Название отдела'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `categorys`
--

CREATE TABLE `categorys` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL COMMENT 'Наименование категории'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `departments`
--

CREATE TABLE `departments` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL COMMENT 'Название отдела'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `departments`
--

INSERT INTO `departments` (`id`, `name`) VALUES
(1, 'ИТ Отдел'),
(2, 'Отдел Бухгалтерии и Учета'),
(3, 'Отдел маркетинга');

-- --------------------------------------------------------

--
-- Структура таблицы `lifecycles`
--

CREATE TABLE `lifecycles` (
  `id` int NOT NULL,
  `opened` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата открытия',
  `distributed` datetime DEFAULT NULL COMMENT 'Дата распределения',
  `proccesing` datetime DEFAULT NULL COMMENT 'Дата обработки',
  `checking` datetime DEFAULT NULL COMMENT 'Дата проверки',
  `closed` datetime DEFAULT NULL COMMENT 'Дата закрытия'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='«Жизненный цикл заявки»';

-- --------------------------------------------------------

--
-- Структура таблицы `post`
--

CREATE TABLE `post` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `post`
--

INSERT INTO `post` (`id`, `name`) VALUES
(1, 'Администратор'),
(2, 'Руководитель отдела'),
(3, 'Бухгалтер'),
(4, 'Специалист ОИТ'),
(6, 'Преподаватель'),
(7, 'Старший преподаватель ');

-- --------------------------------------------------------

--
-- Структура таблицы `requests`
--

CREATE TABLE `requests` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL COMMENT 'Наименование заявки',
  `description` varchar(200) NOT NULL COMMENT 'Описание проблемы',
  `comment` varchar(200) DEFAULT NULL COMMENT 'Комментарий',
  `status` int NOT NULL COMMENT 'Статус заявки',
  `priority` datetime DEFAULT NULL COMMENT 'Дата закрытия',
  `activId` int NOT NULL COMMENT 'Номер кабинета',
  `file` binary(200) NOT NULL COMMENT 'Вложение',
  `categoryId` int NOT NULL COMMENT 'Категория заявки',
  `userId` int NOT NULL COMMENT 'Инициатор заявки',
  `xecutorId` int NOT NULL COMMENT 'Исполнитель',
  `lifecycleId` int NOT NULL COMMENT 'Жизненный цикл заявки'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `roles`
--

CREATE TABLE `roles` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL COMMENT 'Наименование роли'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `roles`
--

INSERT INTO `roles` (`id`, `name`) VALUES
(1, 'администратор'),
(2, 'исполнитель'),
(3, 'оператор'),
(4, 'пользователь');

-- --------------------------------------------------------

--
-- Структура таблицы `sessions`
--

CREATE TABLE `sessions` (
  `id` int NOT NULL,
  `userId` int NOT NULL,
  `session` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `sessions`
--

INSERT INTO `sessions` (`id`, `userId`, `session`, `created_at`) VALUES
(50, 1, 'd254e747-e4cb-4161-8567-f6e797851c71', '2024-06-12 02:22:49'),
(53, 1, 'fc9c816a-c455-4b76-abec-3177c053e08f', '2024-06-12 02:28:33'),
(55, 2, 'f0f26199-f6be-4dc9-819b-b234d23e1926', '2024-06-12 20:37:19'),
(59, 1, '17881b92-d519-45d0-b1f1-6e365249b6b1', '2024-06-12 21:59:11');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL COMMENT 'ФИО пользователя',
  `login` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `departmentId` int NOT NULL COMMENT 'Отдел, где работает пользователь',
  `roleId` int NOT NULL COMMENT 'Роль пользователя в системе',
  `postId` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `name`, `login`, `password`, `departmentId`, `roleId`, `postId`) VALUES
(1, 'Солодянкин Юрий Александрович', 'admin', 'admin', 1, 1, 1),
(2, 'Иванов Иван Иванович', 'ivan', 'ivan1234', 1, 2, 2),
(6, 'ghj', 'ghjg', 'ghjghjg', 3, 4, 7);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `activ`
--
ALTER TABLE `activ`
  ADD PRIMARY KEY (`id`),
  ADD KEY `departamentId` (`departamentId`);

--
-- Индексы таблицы `categorys`
--
ALTER TABLE `categorys`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `lifecycles`
--
ALTER TABLE `lifecycles`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `requests`
--
ALTER TABLE `requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoryId` (`categoryId`),
  ADD KEY `activId` (`activId`),
  ADD KEY `status` (`status`),
  ADD KEY `lifecycleId` (`lifecycleId`),
  ADD KEY `xecutorId` (`xecutorId`),
  ADD KEY `userId` (`userId`),
  ADD KEY `file` (`file`);

--
-- Индексы таблицы `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `departmentId` (`departmentId`,`roleId`),
  ADD KEY `roleId` (`roleId`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `activ`
--
ALTER TABLE `activ`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `categorys`
--
ALTER TABLE `categorys`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `lifecycles`
--
ALTER TABLE `lifecycles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `post`
--
ALTER TABLE `post`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `requests`
--
ALTER TABLE `requests`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `sessions`
--
ALTER TABLE `sessions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `activ`
--
ALTER TABLE `activ`
  ADD CONSTRAINT `activ_ibfk_1` FOREIGN KEY (`id`) REFERENCES `requests` (`activId`),
  ADD CONSTRAINT `activ_ibfk_2` FOREIGN KEY (`departamentId`) REFERENCES `departments` (`id`);

--
-- Ограничения внешнего ключа таблицы `lifecycles`
--
ALTER TABLE `lifecycles`
  ADD CONSTRAINT `lifecycles_ibfk_1` FOREIGN KEY (`id`) REFERENCES `requests` (`lifecycleId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
