--create database Sublish;
use Sublish;
drop table BOOKS_GENRES;
drop table GENRES;
drop table BOOKS;
drop table AUTHORS;


create table AUTHORS (
	ID uniqueidentifier constraint PK_dbo_AUTHORS primary key,
	NAME nvarchar(100),
	SURNAME nvarchar(100),
	COUNTRY nvarchar(100),
	DATE_OF_BIRTH date
);

create table BOOKS (
	ID uniqueidentifier constraint PK_dbo_BOOKS primary key,
	TITLE nvarchar(max),
	AUTHOR_ID uniqueidentifier foreign key references AUTHORS(ID),
	PAGES int,
	PUBLISH_YEAR int
);

create table GENRES (
	ID uniqueidentifier constraint PK_dbo_GENRES primary key,
	NAME nvarchar(100),
	DESCRIPTION nvarchar(max)
);

create table BOOKS_GENRES (
	BOOK_ID uniqueidentifier foreign key references BOOKS(ID),
	GENRE_ID uniqueidentifier foreign key references GENRES(ID)
);