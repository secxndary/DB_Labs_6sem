use Sublish;


go
create or alter view ORDER_COMPANY_BOOKS
as
	select  O.ID ORDER_ID, 
			B.TITLE BOOK_TITLE, 
			C.COMPANY_NAME, 
			O.ORDER_DATE, 
			O.QTY, 
			O.AMOUNT
	from   
			ORDERS O
	join CUSTOMERS C
			on C.ID = O.CUSTOMER_ID
	join BOOKS B
			on B.ID = O.BOOK_ID;
go

select * from ORDER_COMPANY_BOOKS;
go



go
create or alter view BOOKS_AUTHORS
as
	select  B.TITLE BOOK_TITLE,
			B.PAGES,
			A.NAME AUTHOR_NAME,
			A.SURNAME AUTHOR_SURNAME,
			A.COUNTRY AUTHOR_COUNTRY,
			A.DATE_OF_BIRTH AUTHOR_BIRTHDAY
	from    
			BOOKS B
	join AUTHORS A
		on B.AUTHOR_ID = A.ID;	
go

select * from BOOKS_AUTHORS;
go




go
create or alter view BOOKS_GENRES_NAMES
as
	select  TOP(100000)
			B.TITLE BOOK_TITLE,
			B.PAGES,
			G.NAME GENRE
	from    
			BOOKS B
	join BOOKS_GENRES BG
			on BG.BOOK_ID = B.ID
	join GENRES G
			on BG.GENRE_ID = G.ID
	order by B.TITLE, G.NAME;
go

select * from BOOKS_GENRES_NAMES;
go




go
create or alter view BOOKS_GENRES_AUTHORS
as
	select  TOP(100000)
			B.TITLE BOOK_TITLE,
			A.NAME AUTHOR_NAME,
			A.SURNAME AUTHOR_SURNAME,
			B.PAGES,
			G.NAME GENRE
	from    
			BOOKS B
	join BOOKS_GENRES BG
			on BG.BOOK_ID = B.ID
	join GENRES G
			on BG.GENRE_ID = G.ID
	join AUTHORS A
			on B.AUTHOR_ID = A.ID
	order by B.TITLE, G.NAME;
go

select * from BOOKS_GENRES_AUTHORS;
go