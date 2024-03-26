## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
## คู่มือสร้าง API ใหม่

### API : [Flutter-app-API](https://github.com/dragon111333/flutter-book-app-API/tree/main-group-2)


1. remote เข้าไปเซิฟเวอร์โดย user ubuntu

2. cd ไปที่ Folder ของตัวเองเช่น `cd /home/users4`

3. ` sudo composer create-project --prefer-dist laravel/lumen [ชื่อโปรเจค]`
4. แก้ไฟล์ .conf ของ apache ของ user ตัวเอง `sudo nano /etc/apache2/conf-available/[userของตัวเอง].conf` ให้ Alias กับ <Directory> ชี้ไปที่ โฟลเดอร์ public ของ [ชื่อโปรเจค]

5. ให้สิทธิ์  `sudo chmod -R 777 /home/user4/[ชื่อโปรเจค]/*`,`sudo chmod -R 777 /home/user4/[ชื่อโปรเจค]/.env`

6. รีสตาร์ท Apache ด้วย `sudo systemctl restart apache2`

7. เขียน API 
  - ทำ router
  - สร้าง Controller,Model
  - สร้าง DB ตั้งค่า .env 
    -เปิด `$app->withEloquent();` ใน bootstrap/app.php
  -สร้างตาราง
```sql
CREATE TABLE `facultys` (
  `f_id` int NOT NULL,
  `f_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `details` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `f_img` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

INSERT INTO
  `facultys` (
    `f_id`,
    `f_name`,
    `details`,
    `created_at`,
    `updated_at`,
    `f_img`
  )
VALUES
  (
    1,
    'คณะการบัญชีและการจัดการ',
    'สาขาคอมพิวเตอร์',
    '2024-03-25 05:45:37',
    '2024-03-25 05:45:37',
    '20240305160300.png'
  );

CREATE TABLE `members` (
  `id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `student_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `m_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '',
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '123',
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT ''
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

INSERT INTO
  `members` (
    `id`,
    `name`,
    `last_name`,
    `student_id`,
    `created_at`,
    `updated_at`,
    `m_img`,
    `password`,
    `email`
  )
VALUES
  (
    1,
    'ทดสอบ',
    'ทดสอบ',
    '99999',
    '2024-03-26 16:18:09',
    '2024-03-26 16:18:09',
    '20240326160309.jpg',
    '1',
    'love-you@gmail.com'
  );

CREATE TABLE `users` (
  `u_id` int NOT NULL,
  `first_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `password` varchar(50) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

INSERT INTO
  `users` (
    `u_id`,
    `first_name`,
    `last_name`,
    `email`,
    `created_at`,
    `updated_at`,
    `password`
  )
VALUES
  (
    1,
    'foam',
    'supornphan',
    'foam@gmail.com',
    '2024-03-25 06:03:55',
    '2024-03-25 06:03:55',
    '1234'
  );

ALTER TABLE
  `facultys`
ADD
  PRIMARY KEY (`f_id`);

ALTER TABLE
  `members`
ADD
  PRIMARY KEY (`id`);

ALTER TABLE
  `users`
ADD
  PRIMARY KEY (`u_id`);

ALTER TABLE
  `facultys`
MODIFY
  `f_id` int NOT NULL AUTO_INCREMENT,
  AUTO_INCREMENT = 5;

ALTER TABLE
  `members`
MODIFY
  `id` int NOT NULL AUTO_INCREMENT,
  AUTO_INCREMENT = 16;

ALTER TABLE
  `users`
MODIFY
  `u_id` int NOT NULL AUTO_INCREMENT,
  AUTO_INCREMENT = 2;

COMMIT;

```

