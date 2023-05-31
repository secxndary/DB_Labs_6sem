-- 1. ������� � ���������� JTDS Driver, ������ 1.2!!!
-- ����: https://smarttechways.com/2017/07/03/sql-developer-configured-for-microsoft-sql-server/


-- 2. ����� ������ �� �� ����� �����:
-- https://smarttechways.com/2017/07/05/migrate-database-from-sql-server-to-oracle/
alter session set "_ORACLE_SCRIPT"=true;
create user MIGRANT identified by MIGRANT;
grant dba to MIGRANT;


-- 3. ���� �� ����������, �� �������� �������� � ������� ChatGPT:
CREATE TABLE AUTHORS (
    ID RAW(16) PRIMARY KEY,
    NAME NVARCHAR2(100) NOT NULL,
    SURNAME NVARCHAR2(100) NOT NULL,
    COUNTRY NVARCHAR2(100),
    DATE_OF_BIRTH DATE NOT NULL
);

CREATE TABLE BOOKS (
    ID RAW(16) PRIMARY KEY,
    AUTHOR_ID raw(16),
    TITLE NVARCHAR2(1000) NOT NULL,
    PAGES NUMBER(10) NOT NULL,
    FOREIGN KEY (AUTHOR_ID) REFERENCES AUTHORS (ID)
);

CREATE TABLE GENRES (
    ID RAW(16) PRIMARY KEY,
    name nvarchar2(100) not null,
    DESCRIPTION NVARCHAR2(2000)
);

CREATE TABLE BOOKS_GENRES (
    BOOK_ID RAW(16),
    GENRE_ID RAW(16),
    FOREIGN KEY (BOOK_ID) REFERENCES BOOKS (ID),
    FOREIGN KEY (GENRE_ID) REFERENCES GENRES (ID)
);


CREATE TABLE CLIENTS (
    id raw(16) primary key,
    COMPANY_NAME nvarchar2(500) not null,
    ADDRESS NVARCHAR2(1000),
    PHONE NVARCHAR2(20)
);

CREATE TABLE ORDERSS (
    ID RAW(16) PRIMARY KEY,
    BOOK_ID RAW(16),
    CLIENT_ID RAW(16),
    ORDER_DATE TIMESTAMP(6) NOT NULL,
    QTY NUMBER(10) NOT NULL,
    AMOUNT NUMBER(19, 4) NOT NULL,
    foreign key (BOOK_ID) references BOOKS (id),
    FOREIGN KEY (CLIENT_ID) REFERENCES CLIENTS (ID)
);




delete from GENRES;
INSERT INTO GENRES(ID, NAME, DESCRIPTION) 
SELECT SYS_GUID(), '�������', '���� ����������� ���� ������������� ����� ����� ����� ��� �����' FROM DUAL UNION ALL
SELECT SYS_GUID(), '����������', '�� �� �������������� �� ��� ���� ���� ����������� �� ������� �����' FROM DUAL UNION ALL
SELECT SYS_GUID(), '��������', '���� �� �������� � �� ������� ����� � ��� ��� ��� � ��� ����� ������' FROM DUAL UNION ALL
SELECT SYS_GUID(), '�������', '����� ������ ��� �� ���� � ������� ����� ������� ���� �� ����� �����' FROM DUAL UNION ALL
SELECT SYS_GUID(), '��������', '��������� ������� ��������� ����������. ��� ��������� �������' FROM DUAL UNION ALL
SELECT SYS_GUID(), '�����', '� � ��� ���� ������� � ��������� � ��� �� ��� ������� ����' FROM DUAL UNION ALL
SELECT SYS_GUID(), '�����', '������� ���� � �� ���� � �� ������� ��� ��� ������� ������ ���� ����' FROM DUAL UNION ALL
select SYS_GUID(), '������', '����� ��� ��������� � ������ ����� �� ���� ��� ����� �� ���� �� ����' from DUAL;
select * from GENRES;


delete from AUTHORS;
insert into AUTHORS(ID, NAME, SURNAME, COUNTRY, DATE_OF_BIRTH) values
(SYS_GUID(), N'���', N'�������', N'���', TO_DATE('12-23-1968', 'MM-DD-YYYY'));
insert into AUTHORS(ID, NAME, SURNAME, COUNTRY, DATE_OF_BIRTH) values
(SYS_GUID(), N'�����', N'�������', N'��������������', TO_DATE('10-25-1983', 'MM-DD-YYYY'));
insert into AUTHORS(id, name, SURNAME, COUNTRY, DATE_OF_BIRTH) values
(SYS_GUID(), N'���� �����', N'������', N'��������', TO_DATE('12-04-1946', 'MM-DD-YYYY'));
insert into AUTHORS(ID, NAME, SURNAME, COUNTRY, DATE_OF_BIRTH) values
(SYS_GUID(), N'������', N'����������', N'������', TO_DATE('03-21-1969', 'MM-DD-YYYY'));
insert into AUTHORS(id, name, SURNAME, COUNTRY, DATE_OF_BIRTH) values
(SYS_GUID(), N'���i��', N'����', N'��������', TO_DATE('02-25-1935', 'MM-DD-YYYY'));
insert into AUTHORS(id, name, SURNAME, COUNTRY, DATE_OF_BIRTH) values
(SYS_GUID(), N'������', N'��������', N'������', TO_DATE('05-06-1905', 'MM-DD-YYYY'));
insert into AUTHORS(ID, NAME, SURNAME, COUNTRY, DATE_OF_BIRTH) values
(SYS_GUID(), N'�����', N'�������', N'���', TO_DATE('07-19-1949', 'MM-DD-YYYY'));
select * from AUTHORS;


delete from BOOKS;
insert into BOOKS(id, TITLE, PAGES, AUTHOR_ID) values
(SYS_GUID(), N'�����������', 315, HEXTORAW('8A7597F62C4C4EE4886CAAAE37AE3048'));
insert into BOOKS(id, TITLE, PAGES, AUTHOR_ID) values
(SYS_GUID(), N'���������� ����', 401, HEXTORAW('8A7597F62C4C4EE4886CAAAE37AE3048'));
insert into BOOKS(id, TITLE, PAGES, AUTHOR_ID) values
(SYS_GUID(), N'������', 294, HEXTORAW('8A7597F62C4C4EE4886CAAAE37AE3048'));
insert into BOOKS(id, TITLE, PAGES, AUTHOR_ID) values
(SYS_GUID(), N'����', 405, HEXTORAW('5A6F0AAEC1D94B5BAA098784D2687CF9'));
insert into BOOKS(id, TITLE, PAGES, AUTHOR_ID) values
(SYS_GUID(), N'������ ����', 510, HEXTORAW('5A6F0AAEC1D94B5BAA098784D2687CF9'));
insert into BOOKS(id, TITLE, PAGES, AUTHOR_ID) values
(SYS_GUID(), N'���� ����', 572, HEXTORAW('5A6F0AAEC1D94B5BAA098784D2687CF9'));
insert into BOOKS(id, TITLE, PAGES, AUTHOR_ID) values
(SYS_GUID(), N'����� ������ � ����� ��������', 340, HEXTORAW('30FDD70A2C0E44DF96FB45FC45E66010'));
insert into BOOKS(id, TITLE, PAGES, AUTHOR_ID) values
(SYS_GUID(), N'����� ������ � ����������� ������', 385, HEXTORAW('30FDD70A2C0E44DF96FB45FC45E66010'));
select * from BOOKS;


DELETE FROM CLIENTS;
insert into CLIENTS (id, COMPANY_NAME, ADDRESS, PHONE)
values (SYS_GUID(), N'OZ', NULL, N'+375291847734');
insert into CLIENTS (id, COMPANY_NAME, ADDRESS, PHONE)
values (SYS_GUID(), N'������ �����', N'�. �����, ��. ������, 3-105', '+375447295733');
insert into CLIENTS (id, COMPANY_NAME, ADDRESS, PHONE)
values (SYS_GUID(), N'Superlama.by', NULL, '+375333874924');
insert into CLIENTS (id, COMPANY_NAME, ADDRESS, PHONE)
values (SYS_GUID(), N'������� ������� �� ����������', N'�. �����, ��. �������, 105', NULL);
insert into CLIENTS (id, COMPANY_NAME, ADDRESS, PHONE)
values (SYS_GUID(), N'��������', N'�. �����, ��. �������������, 65-104', '+375448773954');
insert into CLIENTS (id, COMPANY_NAME, ADDRESS, PHONE)
values (SYS_GUID(), N'���������', N'�. �����, ��. ���������, 1', '+375257749385');
insert into CLIENTS (id, COMPANY_NAME, ADDRESS, PHONE)
values (SYS_GUID(), N'Mybooks.by', N'�. �����, ��. ������������, 54', '+375333847582');
select * from CLIENTS;


delete ORDERSS;
insert into ORDERSS(id, BOOK_ID, CLIENT_ID, ORDER_DATE, QTY, AMOUNT) values
(SYS_GUID(), '47551648A7774BDCBB2E7099A871C15F', '5B18FA478A894EE5AA3B88B976174BB9', TO_DATE('10-10-2023', 'MM-DD-YYYY'), 10, 280);
insert into ORDERSS(id, BOOK_ID, CLIENT_ID, ORDER_DATE, QTY, AMOUNT) values
(SYS_GUID(), '033BA793878A49519A499AB28830F30D', '732F6AB4FFC6411D8A91608F7954F650', TO_DATE('04-05-2023', 'MM-DD-YYYY'), 28, 360);
insert into ORDERSS(id, BOOK_ID, CLIENT_ID, ORDER_DATE, QTY, AMOUNT) values
(SYS_GUID(), '6B46DF6109D84BAEB40C1980DFB738B4', '732F6AB4FFC6411D8A91608F7954F650', TO_DATE('12-02-2023', 'MM-DD-YYYY'), 5, 55);
insert into ORDERSS(id, BOOK_ID, CLIENT_ID, ORDER_DATE, QTY, AMOUNT) values
(SYS_GUID(), '47551648A7774BDCBB2E7099A871C15F', 'AB56614CFE8F4151B743009AA9DA2919', TO_DATE('08-20-2023', 'MM-DD-YYYY'), 12, 350);
insert into ORDERSS(id, BOOK_ID, CLIENT_ID, ORDER_DATE, QTY, AMOUNT) values
(SYS_GUID(), 'ED2DA30BA3A847428B91EE81DE1439EB', 'A94D2D86193A402695F57789F63701E6', TO_DATE('01-02-2023', 'MM-DD-YYYY'), 11, 340);
insert into ORDERSS(id, BOOK_ID, CLIENT_ID, ORDER_DATE, QTY, AMOUNT) values
(SYS_GUID(), '50B7999F130A4067B3E1F923E0E1274A', '5B18FA478A894EE5AA3B88B976174BB9', TO_DATE('02-02-2023', 'MM-DD-YYYY'), 15, 300);
insert into ORDERSS(id, BOOK_ID, CLIENT_ID, ORDER_DATE, QTY, AMOUNT) values
(SYS_GUID(), 'CF8D4A4981F94F198F9AB12F2B02FA6A', 'ED68F1627D2647A6A427DAAE010BF649', TO_DATE('03-02-2023', 'MM-DD-YYYY'), 8, 256);
insert into ORDERSS(id, BOOK_ID, CLIENT_ID, ORDER_DATE, QTY, AMOUNT) values
(SYS_GUID(), 'ED2DA30BA3A847428B91EE81DE1439EB', '5B18FA478A894EE5AA3B88B976174BB9', TO_DATE('03-05-2023', 'MM-DD-YYYY'), 15, 350);
insert into ORDERSS(id, BOOK_ID, CLIENT_ID, ORDER_DATE, QTY, AMOUNT) values
(SYS_GUID(), 'ECBC69DE4A33464E98E26DBAC9C1F1F4', '732F6AB4FFC6411D8A91608F7954F650', TO_DATE('10-19-2023', 'MM-DD-YYYY'), 18, 405);
insert into ORDERSS(id, BOOK_ID, CLIENT_ID, ORDER_DATE, QTY, AMOUNT) values
(SYS_GUID(), '64B77B1B8E7D49FC9CDE5A68BD9D6DCF', '79324BA9A0EF4AC5BFD2B43AD575BC2A', TO_DATE('05-25-2023', 'MM-DD-YYYY'), 10, 270);
