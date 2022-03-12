t=

backup-db:
	docker exec bookstacksql /usr/bin/mysqldump -u root --password=root bookstack > database/backup.sql
restore-db:
	cat backup.sql | docker exec -i bookstacksql /usr/bin/mysql -u root --password=root bookstack
up:
	docker-compose up
db:
	docker exec -it bookstacksql bash
php:
	docker exec -it bookstackphp bash
backup-files:
	docker exec bookstackphp tar -czvf bookstack-files-backup.tar.gz .env public/uploads storage/uploads && docker cp bookstackphp:/var/www/html/bookstack-files-backup.tar.gz files/bookstack-files-backup.tar.gz
restore-files:
	docker cp files/bookstack-files-backup.tar.gz bookstackphp:/var/www/html/bookstack-files-backup.tar.gz
	docker exec bookstackphp tar -xvzf bookstack-files-backup.tar.gz