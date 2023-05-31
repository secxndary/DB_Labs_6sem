use Sublish;
create table REPORT
(
	id int constraint PK_dbo_REPORT primary key identity(1,1),
	xml_column XML
);
go




-- Генерация XML
create or alter proc GENERATE_XML
as
declare @xml XML;
set @xml = 
(
	select	
		AUTHOR.NAME,
		AUTHOR.SURNAME,
		AUTHOR.COUNTRY,
		BOOK.TITLE,
		BOOK.PAGES,
		[ORDER].ORDER_DATE,
		[ORDER].QTY,
		[ORDER].AMOUNT
	from 
		AUTHORS AUTHOR
	join BOOKS BOOK
		on AUTHOR.ID = BOOK.AUTHOR_ID
	join ORDERS [ORDER]
		on [ORDER].BOOK_ID = BOOK.ID
	for xml auto
);
	select @xml as XML_RESULT;
go

exec GENERATE_XML;
go




-- Вставка сгенерированного XML в таблицу REPORT
create or alter proc INSERT_XML_IN_REPORT
as
declare @xml XML  
set @xml = 
(
	select	
		AUTHOR.NAME,
		AUTHOR.SURNAME,
		AUTHOR.COUNTRY,
		BOOK.TITLE,
		BOOK.PAGES,
		[ORDER].ORDER_DATE,
		[ORDER].QTY,
		[ORDER].AMOUNT
	from 
		AUTHORS AUTHOR
	join BOOKS BOOK
		on AUTHOR.ID = BOOK.AUTHOR_ID
	join ORDERS [ORDER]
		on [ORDER].BOOK_ID = BOOK.ID
	for xml raw
);
insert into REPORT values(@xml);
go

exec INSERT_XML_IN_REPORT
select * from REPORT;
go




-- Индекс для XML-столбца
create primary xml index XML_INDEX_PRIMARY on REPORT(xml_column);
create xml index XML_INDEX_SECONDARY on REPORT(xml_column)
using xml index XML_INDEX_PRIMARY for path;
go




-- Извлечение значений элементов и/или атрибутов
-- Параметр - значение атрибута или элемента
create or alter proc GET_XML_ATTRIBUTE_VALUE
	@NODE_NAME nvarchar(max)
as
	select
		R.Id,
		M.C.value('[sql:variable("@NODE_NAME")]', 'nvarchar(max)') as VALUE
	from
		REPORT R
	outer apply 
		R.xml_column.nodes('/row') as M(C)
go

exec GET_XML_ATTRIBUTE_VALUE
	 @NODE_NAME = '@NAME';