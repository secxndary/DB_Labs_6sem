-- drop table REPORT;
-- delete from REPORT;
create table REPORT
(
  id number generated always as identity primary key,
  xml xmltype
);



-- Сгенерировать XML
create or replace function GENERATE_XML_DOC
return xmltype
as
  XML xmltype;
  B   nvarchar2(600);
begin
   b:= 'select *	from AUTHORS A';
--	join BOOKS BOOK
--		on AUTHOR.ID = BOOK.AUTHOR_ID
--	join ORDERSS [ORDER]
--		on [ORDER].BOOK_ID = BOOK.ID';
  select xmlelement(evalname('ROOT'),dbms_xmlgen.getxmltype(b)) into xml from dual;
  return XML;
end GENERATE_XML_DOC;

select (GENERATE_XML_DOC).GETSTRINGVAL() from dual;




-- Вставить сгенерированный XML в таблицу REPORT
create or replace procedure INSERT_XML(x in xmltype)
is
begin
  insert into REPORT (xml) values (x);
end INSERT_XML;

begin
    INSERT_XML(GENERATE_XML_DOC);
end;

-- select id, xml.XMLDATA from REPORT;
select * from REPORT;




-- Индекс на XML
-- drop index XML_INDEX;
create index xml_index on REPORT(extractvalue(xml,'/ROOT/ROWSET/ROW/ID[0]/text()'));




-- Извлечение значений элементов и/или атрибутов
create or replace procedure GET_XML_ATTRIBUTE_VALUE
is
  aa nvarchar2(2000);
begin
      select r.xml.GETSTRINGVAL() 
      into aa 
      from REPORT r;
      dbms_output.put_line(aa);
end GET_XML_ATTRIBUTE_VALUE;

begin
  GET_XML_ATTRIBUTE_VALUE();
end;

select r.xml.EXTRACT('/ROOT/ROWSET/ROW/ID[0]/text()') xml from REPORT r;
select r.xml.GETROOTELEMENT() from REPORT r;

select * from REPORT;
select r.xml.GETSTRINGVAL() from REPORT r