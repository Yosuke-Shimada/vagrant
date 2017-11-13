# VM起動  
```sh
$ vagrant up
```  
# インストール内容の確認  
```sh
$ vagrant ssh
```  
## php  
7.1  
```sh
$ php -v
```  
## composer  
プロビジョニング実行時点での最新が入っていればOK  
```sh
$ composer --version
```  
## nginx  
nginx version: nginx/1.10.3 (Ubuntu)  
ドキュメントルート : `/var/www/html`  
confファイル : `/etc/nginx/sites-available/my-server.conf`  
```sh
$ nginx -v
# ホストOSから
$ curl -I http://192.168.33.10/

```  
## mysql  
mysql  Ver 14.14 Distrib 5.7.20, for Linux (x86_64) using  EditLine wrapper  
```sh
$ mysql -V
$ mysql -u root -proot
$ mysql -u vagrant -pvagrant
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| sample             |
+--------------------+
2 rows in set (0.00 sec)

```  
# VM破棄  
```sh
$ vagrant destory
