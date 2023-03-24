--create database Sublish;
use Sublish;
drop table BOOKS_GENRES;
drop table GENRES;
drop table BOOKS;
drop table AUTHORS;


create table AUTHORS (
	ID uniqueidentifier constraint PK_dbo_AUTHORS primary key,
	NAME nvarchar(100) NOT NULL,
	SURNAME nvarchar(100) NOT NULL,
	COUNTRY nvarchar(100),
	DATE_OF_BIRTH date NOT NULL
);

create table BOOKS (
	ID uniqueidentifier constraint PK_dbo_BOOKS primary key,
	AUTHOR_ID uniqueidentifier foreign key references AUTHORS(ID),
	TITLE nvarchar(max) NOT NULL,
	PAGES int NOT NULL
);

create table GENRES (
	ID uniqueidentifier constraint PK_dbo_GENRES primary key,
	NAME nvarchar(100) NOT NULL,
	DESCRIPTION nvarchar(max)
);

create table BOOKS_GENRES (
	BOOK_ID uniqueidentifier foreign key references BOOKS(ID) NOT NULL,
	GENRE_ID uniqueidentifier foreign key references GENRES(ID) NOT NULL
);

create table CUSTOMERS (
	ID uniqueidentifier constraint PK_dbo_CUSTOMERS primary key,
	COMPANY_NAME nvarchar(max) NOT NULL,
	ADDRESS nvarchar(max),
	PHONE nvarchar(20)
);

create table ORDERS (
	ID uniqueidentifier constraint PK_dbo_ORDERS primary key,
	BOOK_ID uniqueidentifier foreign key references BOOKS(ID),
	CUSTOMER_ID uniqueidentifier foreign key references CUSTOMERS(ID),
	ORDER_DATE datetime NOT NULL,
	QTY int NOT NULL,
	AMOUNT money NOT NULL
);