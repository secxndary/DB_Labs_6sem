use Sublish;


create index IX_dbo_ORDERS on ORDERS (QTY, AMOUNT);
create index IX_dbo_BOOKS  on BOOKS(PAGES) where PAGES > 300;
create index IX_dbo_CUSTOMERS on CUSTOMERS(ID) include (COMPANY_NAME);

select AVG(QTY/AMOUNT) from ORDERS;
select PAGES from BOOKS;
select * from CUSTOMERS;