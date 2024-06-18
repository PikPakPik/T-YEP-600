CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password`, `last_login`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'Admin', 'admin@tyep600.org', '$2b$12$cmhnhE/UgFWLADZDm1BjT.9E28bWkFTgAzlDqIQMnA4b3keTpyWjS', NULL, '2024-06-18 11:23:20', NULL);

ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;