docker run --name game-database -v game-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=kaiji -d -p 3306:3306 mysql
