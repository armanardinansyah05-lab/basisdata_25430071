-- Mengecek sql_mode
SELECT @@sql_mode;

-- Membuat Database
CREATE DATABASE kopma_071 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Membuat User
CREATE USER 'mhs_071'@'localhost' IDENTIFIED BY '<PASSWORD>';

-- Memberikan Hak Akses
GRANT ALL PRIVILEGES ON kopma_071.* TO 'mhs_071'@'localhost';