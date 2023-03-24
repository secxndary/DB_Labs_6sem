use Sublish;


go
create or alter trigger BOOKS_AFTER_INSERT
on BOOKS
after INSERT
as
	declare @TITLE			nvarchar(max),
			@PAGES			int,
			@AUTHOR_NAME	nvarchar(max),
			@AUTHOR_SURNAME nvarchar(max)
	set @TITLE = (select TITLE from INSERTED);
	set @PAGES = (select PAGES from INSERTED);
	set @AUTHOR_NAME = (select NAME from INSERTED join AUTHORS on AUTHORS.ID = AUTHOR_ID);
	set @AUTHOR_SURNAME = (select SURNAME from INSERTED join AUTHORS on AUTHORS.ID = AUTHOR_ID);
	print '[OK] BOOK INSERTED: ' + @TITLE + ' by ' + @AUTHOR_NAME + ' ' + 
		  @AUTHOR_SURNAME + ' (' + CAST(@PAGES as varchar) + ' pages).';

go
insert into BOOKS (ID, TITLE, PAGES, AUTHOR_ID) 
values (NEWID(), N'wefweffsdf', 315, '4EB71310-42DE-4783-8A49-AE8699C959F6');
go

	
	


go
create or alter trigger BOOKS_AFTER_DELETE
on BOOKS
after DELETE
as
	declare @TITLE			nvarchar(max),
			@PAGES			int,
			@AUTHOR_NAME	nvarchar(max),
			@AUTHOR_SURNAME nvarchar(max)
	set @TITLE = (select TITLE from DELETED);
	set @PAGES = (select PAGES from DELETED);
	set @AUTHOR_NAME = (select NAME from DELETED join AUTHORS on AUTHORS.ID = AUTHOR_ID);
	set @AUTHOR_SURNAME = (select SURNAME from DELETED join AUTHORS on AUTHORS.ID = AUTHOR_ID);
	print '[WARN] BOOK DELETED: ' + @TITLE + ' by ' + @AUTHOR_NAME + ' ' + 
		  @AUTHOR_SURNAME + ' (' + CAST(@PAGES as varchar) + ' pages).';

go
delete BOOKS where TITLE = 'wefweffsdf';
go





go
create or alter trigger ORDERS_AFTER_UPDATE
on ORDERS
after UPDATE
as
	declare @TITLE			nvarchar(max),
			@AUTHOR_NAME	nvarchar(max),
			@AUTHOR_SURNAME nvarchar(max),
			@COMPANY_NAME	nvarchar(max),
			@QTY			int,
			@AMOUNT			int,
			@RESULT_DATA	nvarchar(max)
if (select COUNT(*) from INSERTED) > 0 and (select COUNT(*) from DELETED) > 0
begin
	print '[INFO] ORDERS UPDATED:';
	set @QTY = (select QTY from DELETED where QTY is NOT NULL);
	set @AMOUNT = (select AMOUNT from DELETED where AMOUNT is NOT NULL);
	set @TITLE = (select TITLE from DELETED join BOOKS on BOOK_ID = BOOKS.ID where BOOK_ID is NOT NULL);
	set @AUTHOR_NAME = 
	(
		select AUTHORS.NAME 
		from DELETED 
		join BOOKS 
			on BOOK_ID = BOOKS.ID 
		join AUTHORS
			on BOOKS.AUTHOR_ID = AUTHORS.ID 
		where BOOK_ID is NOT NULL
	);
	set @AUTHOR_SURNAME = 
	(
		select AUTHORS.SURNAME 
		from DELETED 
		join BOOKS 
			on BOOK_ID = BOOKS.ID 
		join AUTHORS
			on BOOKS.AUTHOR_ID = AUTHORS.ID 
		where BOOK_ID is NOT NULL
	);
	set @COMPANY_NAME = 
	(
		select COMPANY_NAME
		from DELETED
		join CUSTOMERS
			on CUSTOMER_ID = CUSTOMERS.ID
		where CUSTOMER_ID is NOT NULL
	);
	set @RESULT_DATA =  @TITLE + ' by ' + @AUTHOR_NAME + ' ' + 
						@AUTHOR_SURNAME + char(13) + 'COMPANY: ' + @COMPANY_NAME + ', QTY: ' +
						CAST(@QTY as varchar) + ', AMOUNT: ' + CAST(@AMOUNT as varchar);

	set @QTY = (select QTY from INSERTED where QTY is NOT NULL);
	set @AMOUNT = (select AMOUNT from INSERTED where AMOUNT is NOT NULL);
	set @COMPANY_NAME = 
	(
		select COMPANY_NAME
		from INSERTED
		join CUSTOMERS
			on CUSTOMER_ID = CUSTOMERS.ID
		where CUSTOMER_ID is NOT NULL
	);
	set @RESULT_DATA =  @RESULT_DATA + char(13) + 'NEW COMPANY: ' + @COMPANY_NAME + ', NEW QTY: ' + 
						CAST(@QTY as varchar) + ', NEW AMOUNT: ' + CAST(@AMOUNT as varchar);

	print @RESULT_DATA;
end


update ORDERS set QTY = 10 where ID = 'DB05ABAB-F3C5-45A8-B9F4-4EB1801BD460';