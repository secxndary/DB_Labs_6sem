use Sublish;

go
create or alter function GET_BOOK_PRICES ()
returns table
as
return
	select
		TOP(10000)
		B.TITLE, 
		C.COMPANY_NAME, 
		O.AMOUNT/ O.QTY as PRICE
	from ORDERS O
	join BOOKS B
		on B.ID = O.BOOK_ID
	join CUSTOMERS C
		on C.ID = O.CUSTOMER_ID
	order by B.TITLE
go 


select * 
from GET_BOOK_PRICES()
go





go
create or alter function GET_AUTHOR_ID_BY_NAME_AND_SURNAME 
(
	@NAME nvarchar(max),
	@SURNAME nvarchar(max)
)
returns table
as
return
	select ID
	from   AUTHORS
	where  NAME = @NAME 
	and    SURNAME = @SURNAME
go 


select * 
from GET_AUTHOR_ID_BY_NAME_AND_SURNAME(N'Анджей', N'Сапковский')
go





go
create or alter function GET_GENRE_ID_BY_NAME
(
	@NAME nvarchar(max)
)
returns table
as
return
	select ID
	from   GENRES
	where  NAME = @NAME 
go 


select * 
from GET_GENRE_ID_BY_NAME(N'Детектив')
go





go
create or alter function GET_BOOKS_QTY_IN_COMPANY 
(
	@COMPANY_NAME nvarchar(max)
)
returns int
as
begin
	declare @QTY int = 
	(
		select SUM(QTY)
		from   ORDER_COMPANY_BOOKS
		where  COMPANY_NAME = @COMPANY_NAME
	);
	return @QTY;
end;
go 


select dbo.GET_BOOKS_QTY_IN_COMPANY('OZ') as TOTAL_QTY;