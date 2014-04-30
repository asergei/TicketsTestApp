drop table if exists tickets;
drop table if exists tickets_status;
drop table if exists users;

create table tickets (
	id int unsigned not null primary key auto_increment,
	sender int unsigned not null,
	status tinyint unsigned not null,
	updated timestamp not null default current_timestamp on update current_timestamp,
	subject varchar(255) not null,
	content text not null 
) engine=innodb;

create table tickets_status (
	id tinyint unsigned not null primary key auto_increment,
	name varchar(127) not null
) engine=innodb;

create table users (
	id int unsigned not null primary key auto_increment,
	name varchar(255) not null,
	key name (name)
) engine=innodb;

insert into users set name = 'test user';
insert into tickets_status set name = 'test status';