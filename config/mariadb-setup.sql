DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db LIKE 'test%';
DROP DATABASE test;
UPDATE mysql.user SET password = password('abc123') WHERE user = 'root';
CREATE USER docker;
GRANT ALL PRIVILEGES ON *.* To 'docker' IDENTIFIED BY 'docker';
flush privileges;
