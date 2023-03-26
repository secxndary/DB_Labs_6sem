use Sublish;


go
create or alter proc PLACE_ORDER
	@COMPANY_NAME	nvarchar(max), 
	@BOOK_TITLE		nvarchar(max),
	@DATE			datetime,
	@QTY			int,
	@AMOUNT			money
as
begin
set nocount on;
begin try
	if (NULLIF(@COMPANY_NAME, '') IS NULL or 
		NULLIF(@BOOK_TITLE, '') IS NULL or 
		NULLIF(@AMOUNT, '') IS NULL or
		NULLIF(@DATE, '') IS NULL or
		NULLIF(@QTY, '') IS NULL)
			raiserror('[ERROR] PLACE_ORDER: Parameters cannot be null.', 17, 1);
			
	if NOT EXISTS
	(
		select *
		from   CUSTOMERS
		where  COMPANY_NAME = ltrim(rtrim(@COMPANY_NAME))
	)
		raiserror ('[ERROR] PLACE_ORDER: There is no customer with such company name.', 17, 1);

	if NOT EXISTS
	(
		select *
		from   BOOKS
		where  TITLE = ltrim(rtrim(@BOOK_TITLE))
	)
		raiserror ('[ERROR] PLACE_ORDER: There is no books with such title.', 17, 1);

	if (@QTY <= 0)
		raiserror ('[ERROR] PLACE_ORDER: QTY must be a positive number.', 17, 1);
		
	if (@AMOUNT <= 0)
		raiserror ('[ERROR] PLACE_ORDER: AMOUNT must be a positive number.', 17, 1);

	if
	(
		select COUNT(*)
		from   ORDERS
		where  DATEADD(dd, 0, DATEDIFF(dd, 0, ORDER_DATE)) = DATEADD(dd, 0, DATEDIFF(dd, 0, @DATE))
	) > 20
		raiserror ('[ERROR] PLACE_ORDER: Too many orders on this date.', 17, 1);


	declare @BOOK_ID uniqueidentifier = (select ID from BOOKS where TITLE = @BOOK_TITLE),
			@CUSTOMER_ID uniqueidentifier = (select ID from CUSTOMERS where COMPANY_NAME = @COMPANY_NAME),
			@ORDER_ID uniqueidentifier = NEWID();

	insert into ORDERS (ID, BOOK_ID, CUSTOMER_ID, ORDER_DATE, QTY, AMOUNT)
	values (@ORDER_ID, @BOOK_ID, @CUSTOMER_ID, @DATE, @QTY, @AMOUNT);


	select * 
	from   ORDER_COMPANY_BOOKS 
	where  ORDER_ID = @ORDER_ID;
	
	print '[OK] PLACE_ORDER: Order succesfully placed.';
	return 1;
end try
begin catch
	declare @ERROR_MESSAGE nvarchar(max), @ERROR_SEVERITY int, @ERROR_STATE int;
        select @ERROR_MESSAGE = ERROR_MESSAGE(), 
			   @ERROR_SEVERITY = ERROR_SEVERITY(),
			   @ERROR_STATE = ERROR_STATE();
		raiserror (@ERROR_MESSAGE, @ERROR_SEVERITY, @ERROR_STATE);
        return -1;
end catch
end;
go


declare @RESULT int;
exec @RESULT = PLACE_ORDER
					@COMPANY_NAME = 'OZ',
					@BOOK_TITLE = N'Бойцовский клуб',
					@DATE = '10-10-2023',
					@QTY = 10,
					@AMOUNT = 170;
print '[INFO] PLACE_ORDER returned: ' + cast(@RESULT as varchar);
go





go
create or alter proc ADD_BOOK_WITH_GENRE_TO_AUTHOR
	@AUTHOR_NAME	nvarchar(max),
	@AUTHOR_SURNAME nvarchar(max),
	@BOOK_TITLE		nvarchar(max),
	@BOOK_PAGES		int,
	@GENRE_NAME		nvarchar(max)
as
begin
set nocount on;
begin try
	if (NULLIF(@AUTHOR_SURNAME, '') IS NULL or 
		NULLIF(@AUTHOR_NAME, '') IS NULL or 
		NULLIF(@BOOK_TITLE, '') IS NULL or 
		NULLIF(@GENRE_NAME, '') IS NULL or
		NULLIF(@BOOK_PAGES, '') IS NULL)
			raiserror('[ERROR] ADD_BOOK_WITH_GENRE_TO_AUTHOR: Parameters cannot be null.', 17, 1);

	if NOT EXISTS
	(
		select *
		from   AUTHORS
		where  NAME = @AUTHOR_NAME
		and	   SURNAME = @AUTHOR_SURNAME
	)
		raiserror ('[ERROR] ADD_BOOK_WITH_GENRE_TO_AUTHOR: There is no author with such Name and Surname.', 17, 1);	

	if NOT EXISTS
	(
		select *
		from   GENRES
		where  NAME = @GENRE_NAME
	)
		raiserror ('[ERROR] ADD_BOOK_WITH_GENRE_TO_AUTHOR: There is no genre with such name.', 17, 1);

	if (@BOOK_PAGES <= 0)
		raiserror ('[ERROR] ADD_BOOK_WITH_GENRE_TO_AUTHOR: PAGES must be a positive number.', 17, 1);


	declare @BOOK_ID uniqueidentifier = NEWID(),
			@AUTHOR_ID uniqueidentifier = (select ID from AUTHORS where NAME = @AUTHOR_NAME and SURNAME = @AUTHOR_SURNAME),
			@GENRE_ID uniqueidentifier = (select ID from GENRES where NAME = @GENRE_NAME);

	begin tran;
		insert into BOOKS (ID, TITLE, PAGES, AUTHOR_ID)
		values (@BOOK_ID, @BOOK_TITLE, @BOOK_PAGES, @AUTHOR_ID);

		insert into BOOKS_GENRES (BOOK_ID, GENRE_ID) 
		values (@BOOK_ID, @GENRE_ID);
	commit;

	select * 
	from   BOOKS_GENRES_AUTHORS
	where  BOOK_TITLE = @BOOK_TITLE
	and	   AUTHOR_SURNAME = @AUTHOR_SURNAME
	
	print '[OK] ADD_BOOK_WITH_GENRE_TO_AUTHOR: Book and genre successfully added to author.';
	return 1;
end try
begin catch
	declare @ERROR_MESSAGE nvarchar(max), @ERROR_SEVERITY int, @ERROR_STATE int;
        select @ERROR_MESSAGE = ERROR_MESSAGE(), 
			   @ERROR_SEVERITY = ERROR_SEVERITY(),
			   @ERROR_STATE = ERROR_STATE();
		rollback;
		raiserror (@ERROR_MESSAGE, @ERROR_SEVERITY, @ERROR_STATE);
        return -1;
end catch
end;
go

--	delete BOOKS where TITLE like N'%Смелов%';
declare @RESULT int;
exec @RESULT = ADD_BOOK_WITH_GENRE_TO_AUTHOR
					@AUTHOR_NAME = N'Джоан',
					@AUTHOR_SURNAME = N'Роулинг',
					@BOOK_TITLE = N'Вова Смелов и Студент-Полурослик',
					@BOOK_PAGES	= 396,
					@GENRE_NAME	= N'Фэнтези'
print '[INFO] ADD_BOOK_WITH_GENRE_TO_AUTHOR returned: ' + cast(@RESULT as varchar);
go





go
create or alter proc ADD_BOOK_WITH_NEW_GENRE
	@BOOK_TITLE		nvarchar(max),
	@BOOK_PAGES		int,
	@GENRE_NAME		nvarchar(max),
	@GENRE_DESCR	nvarchar(max),
	@AUTHOR_ID		nvarchar(max)
as
begin
set nocount on;
begin try
	if (NULLIF(@GENRE_DESCR, '') IS NULL or 
		NULLIF(@BOOK_TITLE, '') IS NULL or 
		NULLIF(@GENRE_NAME, '') IS NULL or
		NULLIF(@GENRE_DESCR, '') IS NULL or
		NULLIF(@AUTHOR_ID, '') IS NULL)
			raiserror('[ERROR] ADD_BOOK_WITH_NEW_GENRE: Parameters cannot be null.', 17, 1);

	if NOT EXISTS
	(
		select *
		from   AUTHORS
		where  ID = @AUTHOR_ID
	)
		raiserror ('[ERROR] ADD_BOOK_WITH_NEW_GENRE: There is no author with such ID.', 17, 1);	
			
	if EXISTS
	(
		select *
		from   BOOKS
		where  TITLE = @BOOK_TITLE
		and	   AUTHOR_ID = @AUTHOR_ID
	)
		raiserror ('[ERROR] ADD_BOOK_WITH_NEW_GENRE: There is already a book with such Title by this Author.', 17, 1);

	if EXISTS
	(
		select *
		from   GENRES
		where  NAME = @GENRE_NAME
	)
		raiserror ('[ERROR] ADD_BOOK_WITH_NEW_GENRE: There is already a genre with such name.', 17, 1);	

	if (@BOOK_PAGES <= 0)
		raiserror ('[ERROR] ADD_BOOK_WITH_NEW_GENRE: PAGES must be a positive number.', 17, 1);


	declare @BOOK_ID uniqueidentifier = NEWID(),
			@GENRE_ID uniqueidentifier = NEWID();

	begin tran;
		insert into BOOKS (ID, TITLE, PAGES, AUTHOR_ID)
		values (@BOOK_ID, @BOOK_TITLE, @BOOK_PAGES, @AUTHOR_ID);

		insert into GENRES (ID, NAME, DESCRIPTION)
		values (@GENRE_ID, @GENRE_NAME, @GENRE_DESCR);

		insert into BOOKS_GENRES (BOOK_ID, GENRE_ID) 
		values (@BOOK_ID, @GENRE_ID);
	commit;

	select * 
	from   BOOKS_GENRES_AUTHORS
	where  BOOK_TITLE = @BOOK_TITLE
	and	   GENRE = @GENRE_NAME;
	
	print '[OK] ADD_BOOK_WITH_NEW_GENRE: Book and genre successfully created.';
	return 1;
end try
begin catch
	declare @ERROR_MESSAGE nvarchar(max), @ERROR_SEVERITY int, @ERROR_STATE int;
        select @ERROR_MESSAGE = ERROR_MESSAGE(), 
			   @ERROR_SEVERITY = ERROR_SEVERITY(),
			   @ERROR_STATE = ERROR_STATE();
		rollback;
		raiserror (@ERROR_MESSAGE, @ERROR_SEVERITY, @ERROR_STATE);
        return -1;
end catch
end;
go


--	delete from BOOKS_GENRES where BOOK_ID = 'E27D18AE-02DA-4284-A7B9-927C77B0C80F';
--	delete from GENRES where NAME = N'Дарк фэнтези';
--	delete from BOOKS where TITLE = N'Ведьмак. Сезон Гроз';
declare @RESULT int;
exec @RESULT = ADD_BOOK_WITH_NEW_GENRE
					@AUTHOR_ID = 'E76E81F1-5B41-476C-BBBC-49F5E6D87D90',
					@BOOK_TITLE = N'Ведьмак. Сезон Гроз',
					@BOOK_PAGES	= 351,
					@GENRE_NAME	= N'Дарк фэнтези',
					@GENRE_DESCR = N'Тёмная версия обычного фэнтези'
print '[INFO] ADD_BOOK_WITH_NEW_GENRE returned: ' + cast(@RESULT as varchar);
go






go
create or alter proc GET_THICKEST_BOOK
as
begin
set nocount on;
begin try
	declare @MAX_PAGES int = (select MAX(PAGES) from BOOKS);
	
	select 
		   B.TITLE, 
		   A.NAME,
		   A.SURNAME,
		   B.PAGES
	from   BOOKS B
	join AUTHORS A
		on A.ID = B.AUTHOR_ID
	where  PAGES = @MAX_PAGES;

	return 1;
end try
begin catch
	declare @ERROR_MESSAGE nvarchar(max), @ERROR_SEVERITY int, @ERROR_STATE int;
        select @ERROR_MESSAGE = ERROR_MESSAGE(), 
			   @ERROR_SEVERITY = ERROR_SEVERITY(),
			   @ERROR_STATE = ERROR_STATE();
		raiserror (@ERROR_MESSAGE, @ERROR_SEVERITY, @ERROR_STATE);
        return -1;
end catch
end;
go 


declare @RESULT int;
exec @RESULT = GET_THICKEST_BOOK
print '[INFO] GET_THICKEST_BOOK returned: ' + cast(@RESULT as varchar);
go
