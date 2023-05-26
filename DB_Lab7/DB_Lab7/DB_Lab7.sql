use Sublish;
create table REPORT
(
	id int constraint PK_dbo_REPORT primary key identity(1,1),
	xml_column XML
);
go



-- ��������� XML
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




-- ������� ���������������� XML � ������� REPORT
create or alter proc INSERT_XML_IN_REPORT
as
declare  @s XML  
SET @s = (Select	name_client [��� �������], 
					name_product [��� ��������], 
					GETDATE() [����]
		from orders ord 
					join products prd on ord.id_product = prd.id_product
					join clients clnt on clnt.id_client = ord.id_client
for xml raw);
--FOR XML AUTO, TYPE);
insert into REPORT values(@s);
go
  
  exec InsertInREPORT
  select * from REPORT;




--TASK4
-- ����. ������ ��� XML-�������� � REPORT
create primary xml index My_XML_Index on REPORT(xml_column)

create xml index Second_XML_Index on REPORT(xml_column)
using xml index My_XML_Index for path




--TASK5
-- ���� ��������� ���� ���� �� XML-������� � REPORT (�������� - ���� ��������/��)

select * from REPORT

create procedure SelectData
as
select xml_column.query('/row')
	as[xml_column]
	from REPORT
	for xml auto, type;
go
exec SelectData



select xml_column.value('(/row/@����)[1]', 'nvarchar(max)')
	as[xml_column]
	from REPORT
	for xml auto, type;


select r.Id,
	m.c.value('@����', 'nvarchar(max)') as [date]
	from REPORT as r
	outer apply r.xml_column.nodes('/row') as m(c)



--���������� �/oracle