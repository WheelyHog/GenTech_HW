create database Ditok;

use ditok;

create table registration(
id integer primary key auto_increment,
username varchar(128),
email varchar(128),
date datetime,
password varchar(128),
isblocked bool
);

create table upload(
id integer primary key auto_increment,
title varchar(128),
description varchar(255),
date datetime,
duration integer,
user_id integer
);

create table reaction(
id integer primary key auto_increment,
video_id integer,
user_id integer,
date datetime,
type bool
);

create table comment(
id integer primary key auto_increment,
video_id integer,
user_id integer,
date datetime,
text varchar(255)
);

create database if not exists platform;
use platform;

create table if not exists users(
    user_id integer primary key auto_increment,
	fullname varchar(256) not null,
	email varchar(64) not null,
	is_blocked BOOL default false,
	created_at datetime default current_timestamp
    
);

create table if not exists streams(
    stream_id integer primary key auto_increment,
	user_id integer,
	title varchar(256) not null,
    created_at datetime default current_timestamp,
	is_completed bool default false,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


create table if not exists reactions(
    reaction_id integer primary key auto_increment,
	user_id integer,
    value integer not null check(value between 1 and 5),
    stream_id integer,
    created_at datetime default current_timestamp,
	is_blocked bool default false,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (stream_id) REFERENCES streams(stream_id)
);

insert into streams (user_id, title)
values(1, 'stream1'),
(2, 'stream 2'),
(3, 'stream 3'),
(4, 'stream 4'),
(5, 'stream 5');

insert into reactions (user_id, value, stream_id)
values(1 , 5, 2),
(2 , 4, 7),
(3 , 1, 6),
(1 , 3, 2),
(2 , 5, 2);

use platform

select users.fullname, donations.amount
from users
join streams on streams.user_id=users.user_id
join donations on donations.stream_id=streams.stream_id
order by donations.amount desc
limit 1

select users.fullname, sum(donations.amount)
from users
join streams on streams.user_id=users.user_id
join donations on donations.stream_id=streams.stream_id
group by streams.stream_id
order by sum(donations.amount) desc
limit 3

-- ============================================================
CREATE DATABASE online_chat;

use online_chat

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE friends (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user1_id INT NOT NULL,
    user2_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user1_id) REFERENCES users (id),
    FOREIGN KEY (user2_id) REFERENCES users (id)
);

CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE reactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message_id INT NOT NULL,
    value int,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_blocked tinyint(1),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (message_id) REFERENCES messages (id)
);