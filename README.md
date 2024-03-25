## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
## คู่มือสร้าง API ใหม่
[Flutter-book-app-API](https://github.com/dragon111333/Flutter-book-app)

1. remote เข้าไปเซิฟเวอร์โดย user ubuntu

2. cd ไปที่ Folder ของตัวเองเช่น `cd /home/users4`

3. ` sudo composer create-project --prefer-dist laravel/lumen bookshop`
4. แก้ไฟล์ .conf ของ apache ของ user ตัวเอง `sudo nano /etc/apache2/conf-available/[userของตัวเอง].conf` ให้ Alias กับ <Directory> ชี้ไปที่ bookshop

5. ให้สิทธิ์  `sudo chmod -R 777 /home/user4/bookshop/*`,`sudo chmod -R 777 /home/user4/bookshop/.env`

6. รีสตาร์ท Apache ด้วย `sudo systemctl restart apache2`

7. เขียน API 
  - ทำ router
  - สร้าง Controller,Model
  - สร้าง DB ตั้งค่า .env 
    -เปิด `$app->withEloquent();` ใน bootstrap/app.php
  -สร้างตาราง
```sql
	CREATE TABLE members(
		id int(8) AUTO_INCREMENT,
    		name varchar(255) DEFAULT "",
    		last_name varchar(255) DEFAULT "",
    		password varchar(255) DEFAULT "",
    		email varchar(255) DEFAULT "",
    		created_at timestamp DEFAULT CURRENT_TIMESTAMP,
		updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
		CONSTRAINT member_pk PRIMARY KEY(id)
	);
	insert into members set name="test" , last_name="kub" ,email="test@gmail.com",password="555";
```
