use TravelCompany;
go


drop table Report;
go
create table Report
(
    id INTEGER primary key identity(1,1),
    xml_column XML
);

go
create or alter procedure insertInReport 
as
begin
declare @s XML
set @s = (
	select
		*,
		GETDATE() as date
	from route rt
	join country cF
		on cF.Id = rt.FromCountryId
	join country cT
		on cT.Id = rt.ToCountryId
	for xml auto);
	insert into Report(xml_column) values(@s)
end

exec insertInReport
select * from Report
	
create primary xml index xml_idx on Report(xml_column)

create or alter procedure selectXmlData
as
select xml_column.query('/rt/cF') as [xml data] from Report for xml auto, type;

create or alter procedure selectXmlData1
as
select xml_column.query('/rt[1]/cF') as [xml_data] from Report for xml auto, type;

create or alter procedure selectXmlData2
as
select  xml_column.value('(/rt[1]/cF/@Name)[1]', 'nvarchar(max)') as [xml_data] from Report for xml auto, type;

SELECT
   col.NameAttr.value('@Id', 'nvarchar(max)') AS [xml_data]
FROM
   Report
CROSS APPLY
   xml_column.nodes('/rt/cF') AS col(NameAttr)
FOR XML AUTO, TYPE;

exec selectXmlData
go
exec selectXmlData1
go
exec selectXmlData2