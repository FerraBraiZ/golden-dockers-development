CREATE DATABASE IF NOT EXISTS database;
CREATE USER 'database'@'localhost' IDENTIFIED BY 'database';
GRANT ALL PRIVILEGES ON * . * TO '%'@'localhost';
FLUSH PRIVILEGES;
USE database;
