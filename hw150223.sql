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

SELECT sum(amount) AS total_sum, users.fullname
FROM donations
LEFT JOIN users ON donations.donator_id=users.user_id
GROUP BY donations.donator_id
ORDER BY total_sum DESC
LIMIT 1;

select users.fullname, sum(donations.amount)
from users
join streams on streams.user_id=users.user_id
join donations on donations.stream_id=streams.stream_id
group by streams.stream_id
order by sum(donations.amount) desc
limit 3

select	users.fullname,    sum(donations.amount) as total_sum_donat
	from donations
	left join streams on donations.stream_id = streams.stream_id
	left join users on streams.user_id = users.user_id
	group by users.user_id
	ORDER BY total_sum_donat DESC
    LIMIT 3
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
-- ============================================

create database if not exists chat;
use chat;

create table if not exists users
(
    user_id integer primary key auto_increment,
    fullname varchar(256) not null,
    country varchar(64),
    is_blocked BOOL default false,
    created_at datetime default current_timestamp
);
create table chats(
    chat_id int primary key auto_increment,
    topic nvarchar(256) not null,
    created_at datetime default current_timestamp,
    user1_id INTEGER,
    user2_id INTEGER,
    FOREIGN KEY (user1_id) REFERENCES users(user_id),
    FOREIGN KEY (user2_id) REFERENCES users(user_id)
);

create table if not exists messages(
    message_id integer primary key auto_increment,
    chat_id integer,
    author_id integer,
    recipient_id integer,
    text text not null,
    created_at datetime default current_timestamp,
    is_removed BOOL default false,
    FOREIGN KEY (author_id) REFERENCES users(user_id),
    FOREIGN KEY (recipient_id) REFERENCES users(user_id),
    FOREIGN KEY (chat_id) REFERENCES chats(chat_id)
);

create table if not exists reactions(
    reaction_id integer primary key auto_increment,
    user_id integer,
    message_id integer,
    value integer not null check(value between 1 and 5),
    created_at datetime default current_timestamp,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (message_id) REFERENCES messages(message_id)
);

insert into users (fullname, country)
values ('John Doe' , 'USA'),
('Homer Simpson' , 'USA'),
('Marge Simpson', 'Canada'),
('Lisa Simpson' , 'France'),
('Montgomery Burns' , 'Germany')

insert into  messages (chat_id, author_id, recipient_id, text)
values (2, 1, 2, 'safsa'),
(3, 3, 1, 'gregdsg'),
(4, 2, 5, 'fsafsfsafs'),
(1, 4, 2, 'gfesafegaeg'),
(5 , 2, 4, 'cs\cf\vc')

INSERT INTO chats (topic, user1_id, user2_id)
VALUES	('animals', 1, 2),    ('small talk', 2, 3),  	('animals', 4, 5),   ('small talk', 3, 4),    	('animals', 1, 5);

insert into reactions (user_id, value)
values (1 , 2),
(3 , 1),
(4 , 5),
(2, 2),
(5  ,4)

select * from users
select * from chats
select * from messages

select users.fullname as author, 
from users
join chats on chats.user1_id=users.user_id
join chats on chats.user2_id=users.user_id

SELECT user1.fullname AS 'СОБЕСЕДНИК_1', user2.fullname AS 'СОБЕСЕДНИК_2'
FROM chats
JOIN users user1 ON chats.user1_id = user1.user_id
JOIN users user2 ON chats.user2_id = user2.user_id;


select distinct country
from users

select users.fullname, count(*) as sum_messages
from users
join chats on chats.user1_id=users.user_id
group by user_id
order by sum_messages
limit 1

SELECT COUNT(message_id) AS total_messages, users.fullname
FROM messages
LEFT JOIN users ON messages.author_id = users.user_id
GROUP BY messages.author_id
ORDER BY total_messages DESC
LIMIT 1;

SELECT COUNT(message_id) AS total_messages, users.country
FROM messages
LEFT JOIN users ON messages.author_id = users.user_id
GROUP BY users.country
ORDER BY total_messages DESC
LIMIT 1;

SELECT AVG(LENGTH(messages.text)) AS avg_length, users.country
FROM messages
LEFT JOIN users ON messages.author_id = users.user_id
GROUP BY users.country
ORDER BY avg_length DESC
LIMIT 1;

SELECT AVG(value) AS rating
FROM reactions

SELECT AVG(value) AS rating
FROM reactions
where user_id=1

select text, users.fullname
from messages 
where chat_id=1
join users on users.user_id=messages.author_id
order by created_at desc
limit 1


select 	messages.created_at,		messages.text,	users.fullname
	from messages
	left join users on messages.author_id = users.user_id
	where messages.chat_id = 1
	order by messages.created_at desc
	LIMIT 40 OFFSET 0
    
    select * from chats
    
    select topic
    from chats
    where created_at between 2023-01-31 and 2023-03-01
    
    select value, count(*) as total_marks
    from reactions
    group by value
    order by value desc
    
    select count(*)
    from messages
    where chat_id=1
    
    select 	author_id,	count(message_id) as total_messages 
    from messages 
    where chat_id = 1 
    group by author_id;

SELECT chat_id, COUNT(*) AS num_messages
FROM messages
GROUP BY chat_id
HAVING num_messages > 1;

SELECT chat_id, COUNT(*) AS num_messages
FROM messages
where created_at = '2023-02-16'
GROUP BY chat_id
HAVING num_messages > 1;

select avg(length(messages.text)), chat_id
from messages
group by chat_id

alter table users
alter is_worker set default false

update users
set is_worker=1
where user_id in(2,3,4)

select messages.text
from messages
join users on users.user_id=messages.author_id
where users.is_worker=1

CREATE TABLE salaries (
    salary_id INT AUTO_INCREMENT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    worker_id INT NOT NULL,
    value NUMERIC(8,2)
     );
     
     CREATE TABLE IF NOT EXISTS salaries (  salary_id INTEGER PRIMARY KEY AUTO_INCREMENT,
     created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
     worker_id INTEGER NOT NULL,
     value NUMERIC(10, 2) NOT NULL CHECK (value > 0),
     FOREIGN KEY (worker_id) REFERENCES users(user_id));
     
     insert into salaries (worker_id, value)
     values (4, 300),
     (1,13460),
     (5,25000)
     
     select users.fullname, sum(salaries.value)
     from users
     join salaries on salaries.worker_id=users.user_id
      where users.is_worker=1
      
      SELECT SUM(value) total_payment, users.fullname
      FROM salaries
      LEFT JOIN users ON salaries.worker_id = users.user_id
      WHERE users.is_worker=true and salaries.created_at >= '2023-02-01' AND  salaries.created_at < '2023-03-01'
      GROUP BY salaries.worker_id
      ORDER BY total_payment DESC
      LIMIT 1;
    
    -- Описание занятия: В рамках БД 'chat' с помощью SQL напишите запрос, который вывеадет информацию о чатах  (КТО С КЕМ ОБЩАЕТСЯ), отсортированных по дате посл/сообщения
    
      use chat
      
SELECT c.chat_id, u1.fullname AS user1, u2.fullname AS user2, m.created_at AS last_message_date
FROM chats c
JOIN users u1 ON c.user1_id = u1.id
JOIN users u2 ON c.user2_id = u2.id
JOIN (
  SELECT chat_id, MAX(created_at) AS date
  FROM messages m
  GROUP BY chat_id
) AS m ON c.id = m.chat_id
ORDER BY last_message_date DESC;

select * from chats
select * from messages
select * from reactions
select * from users
select * from salaries

select chats.chat_id, users.fullname as user1, users.fullname as user2, messages.created_at
from chats
join users on users.user_id=chats.user1_id
join users on users.user_id=chats.user2_id
join messages on users.user_id=messages.author_id
join messages on users.user_id=messages.recipient_id
-- group by messages.chat_id