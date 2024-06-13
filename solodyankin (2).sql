-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Июн 13 2024 г., 19:41
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

--
-- Дамп данных таблицы `activ`
--

INSERT INTO `activ` (`id`, `cabNumber`, `departamentId`) VALUES
(1, '202', 2),
(2, '203', 1),
(3, '201', 3);

-- --------------------------------------------------------

--
-- Структура таблицы `categorys`
--

CREATE TABLE `categorys` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL COMMENT 'Наименование категории'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `categorys`
--

INSERT INTO `categorys` (`id`, `name`) VALUES
(1, '1С бухгалтерия'),
(2, 'Учебные кабинеты'),
(3, 'Оборудование');

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

--
-- Дамп данных таблицы `lifecycles`
--

INSERT INTO `lifecycles` (`id`, `opened`, `distributed`, `proccesing`, `checking`, `closed`) VALUES
(8, '2024-06-13 19:47:45', NULL, NULL, NULL, NULL),
(11, '2024-06-13 19:48:54', NULL, NULL, NULL, NULL),
(12, '2024-06-13 19:50:21', NULL, NULL, NULL, NULL),
(13, '2024-06-13 20:02:44', NULL, NULL, NULL, NULL),
(14, '2024-06-13 20:02:45', NULL, NULL, NULL, NULL),
(15, '2024-06-13 20:02:45', NULL, NULL, NULL, NULL),
(16, '2024-06-13 20:02:46', NULL, NULL, NULL, NULL);

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
  `status` varchar(50) NOT NULL DEFAULT 'ожидание' COMMENT 'Статус заявки',
  `priority` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Приоритет',
  `activId` int NOT NULL COMMENT 'Номер кабинета',
  `file` binary(200) DEFAULT NULL COMMENT 'Вложение',
  `categoryId` int NOT NULL COMMENT 'Категория заявки',
  `userId` int NOT NULL COMMENT 'Инициатор заявки',
  `xecutorId` int DEFAULT NULL COMMENT 'Исполнитель',
  `lifecycleId` int NOT NULL COMMENT 'Жизненный цикл заявки'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `requests`
--

INSERT INTO `requests` (`id`, `name`, `description`, `comment`, `status`, `priority`, `activId`, `file`, `categoryId`, `userId`, `xecutorId`, `lifecycleId`) VALUES
(3, 'sdf', 'sdf', 'sdfsdf', 'ожидание', 'Высокий', 2, 0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000, 3, 1, NULL, 12),
(4, 'sdfsdf', 'sdfsdf', '', 'обработка', 'Средний', 1, 0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000, 1, 1, NULL, 13),
(5, 'sdfsdf', 'sdfsdf', '', 'завершена', 'Низкий', 1, 0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000, 1, 1, NULL, 14),
(6, 'sdfsdf', 'sdfsdf', '', 'отклонена', 'Низкий', 1, 0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000, 1, 1, NULL, 15),
(7, 'sdfsdf', 'sdfsdf', '', 'обработка', 'Низкий', 1, 0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000, 1, 1, NULL, 16);

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
(72, 4, '85b967c3-3d01-4979-925d-ываы000dace3b7c8', '2024-06-12 23:07:10'),
(76, 1, 'ee7716b0-21f3-4c18-a27f-f8e221109298', '2024-06-12 23:13:31'),
(77, 1, '1ea7041e-3dfc-4107-ac77-8eaeab61f20c', '2024-06-13 18:18:05'),
(79, 1, 'a84c26ea-7b42-47d3-9c6b-1db61bf6ea23', '2024-06-13 18:31:19');

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `categorys`
--
ALTER TABLE `categorys`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `lifecycles`
--
ALTER TABLE `lifecycles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT для таблицы `post`
--
ALTER TABLE `post`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `requests`
--
ALTER TABLE `requests`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `sessions`
--
ALTER TABLE `sessions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `activ`
--
ALTER TABLE `activ`
  ADD CONSTRAINT `activ_ibfk_2` FOREIGN KEY (`departamentId`) REFERENCES `departments` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
