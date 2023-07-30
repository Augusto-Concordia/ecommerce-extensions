# create database and use it
CREATE DATABASE IF NOT EXISTS ecommjava;
USE ecommjava;

# create the customer table
CREATE TABLE IF NOT EXISTS CUSTOMER(
customer_id       int unique key not null auto_increment primary key,
email    varchar(255) null,
password varchar(255) null,
role     ENUM('ROLE_NORMAL', 'ROLE_ADMIN') null,
username varchar(255) null,
paired_product_id int null DEFAULT '0'
);

# insert default customers
INSERT INTO CUSTOMER(email, password, role, username, accumulatedPurchases) VALUES
('admin@nyan.cat', '123', 'ROLE_ADMIN', 'admin', 0.0 ),
('lisa@gmail.com', '765', 'ROLE_NORMAL', 'lisa', 0.0 ),
('amrit@gmail.com', 'password', 'ROLE_NORMAL', 'amrit', 0.0 ),
('yupei@gmail.com', 'password', 'ROLE_NORMAL', 'yupei', 0.0);


# create the product table
CREATE TABLE IF NOT EXISTS PRODUCT(
product_id  int unique key not null auto_increment primary key,
image       varchar(255) null,
name        varchar(255) null,
price       int null,
quantity    int null,
paired_product_id int null
);

# insert default products
INSERT INTO PRODUCT(image, name, price, quantity) VALUES
('https://freepngimg.com/save/9557-apple-fruit-transparent/744x744', 'Apple', 3, 40),
('https://www.nicepng.com/png/full/813-8132637_poiata-bunicii-cracked-egg.png', 'Cracked Eggs', 1, 90),
('https://www.nicepng.com/png/detail/923-9237061_orange-naranja-orange-slide-middle-media-naranja-png.png', 'Orange', 3, 40),
('https://www.nicepng.com/png/detail/14-146654_free-png-pear-png-images-transparent-pear-png.png', 'Pear', 3, 60),
('https://www.nicepng.com/png/detail/45-455648_berry-vector-acai-strawberry-clipart-transparent-background.png', 'Strawberry', 2, 40),
('https://www.nicepng.com/png/detail/51-510169_cherries-clipart-red-cherry-cherry-fruit-png.png', 'cherry', 2, 40),
('https://www.nicepng.com/png/detail/16-161611_blueberries-png-blueberry-png.png', 'blueberry', 2, 40);

# create coupon table
CREATE TABLE IF NOT EXISTS COUPON (
coupon_id int unique key not null auto_increment primary key,
customer_id int
);

# insert default coupons
INSERT INTO COUPON (customer_id) VALUES (2);
INSERT INTO COUPON (customer_id) VALUES (1);

CREATE TABLE IF NOT EXISTS BASKET (
basket_id  int unique key not null auto_increment primary key,
customer_id int,
basket_type ENUM ('CUSTOM_BASKET', 'BASKET')
);

# insert default basket
INSERT INTO BASKET (customer_id, basket_type) VALUES (2, 'CUSTOM_BASKET');
INSERT INTO BASKET (customer_id, basket_type) VALUES (1, 'BASKET');

CREATE TABLE IF NOT EXISTS BASKET_PRODUCT (
basket_product_id  int unique key not null auto_increment primary key,
basket_id  int,
product_id int,
quantity int
);

# insert products basket
INSERT INTO BASKET_PRODUCT (basket_id, product_id, quantity) VALUES (2, 2, 10);
INSERT INTO BASKET_PRODUCT (basket_id, product_id, quantity) VALUES (2, 3, 10);
INSERT INTO BASKET_PRODUCT (basket_id, product_id, quantity) VALUES (1, 2, 10);
INSERT INTO BASKET_PRODUCT (basket_id, product_id, quantity) VALUES (1, 3, 10);