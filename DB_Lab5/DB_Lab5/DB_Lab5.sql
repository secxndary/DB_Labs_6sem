use Sublish;
alter table CUSTOMERS add NODE hierarchyid;
update CUSTOMERS 
set NODE = hierarchyid::GetRoot() 
where COMPANY_NAME = N'OZ';
go



-- Процедура, отображающая все подчинённые узлы с указанием уровня иерархии
-- Параметр - значение узла
create or alter proc GET_DESCENDANTS_BY_HID 
	@HID hierarchyid
as
begin
	select
		NODE,
		NODE.ToString() as NODE_STRING,
		NODE.GetLevel() as NODE_LEVEL,
		ID,
		COMPANY_NAME,
		ADDRESS,
		PHONE
	from 
		CUSTOMERS
	where 
		NODE.IsDescendantOf(@HID) = 1
end;
go


exec GET_DESCENDANTS_BY_HID @HID = '/';
go




-- Процедура, добавляющая подчинённый узел
-- Параметр - значение узла
create or alter proc ADD_DESCENDANT_NODE
	@COMPANY_NAME	nvarchar(max),
	@ADDRESS		nvarchar(max),
	@PHONE			nvarchar(20),
	@HID			hierarchyid
as
begin
	declare @LCV hierarchyid;
	begin transaction
		
		select @LCV = max(NODE)
		from CUSTOMERS
		where NODE.GetAncestor(1) = @HID;

		insert into CUSTOMERS (ID, COMPANY_NAME, ADDRESS, PHONE, NODE) 
		values (NEWID(), @COMPANY_NAME, @ADDRESS, @PHONE, @HID.GetDescendant(@LCV, NULL));

	commit;
end;
go


declare @NODE hierarchyid = '/'
exec ADD_DESCENDANT_NODE
	@COMPANY_NAME = 'New Sheriff in the Town',
	@ADDRESS = N'Не важно',
	@PHONE = '+375297449123',
	@HID = @NODE;
exec GET_DESCENDANTS_BY_HID 
	@HID = @NODE;
go




-- Процедура, перемещающаявсю подчинённую ветку
-- Параметр №1 - родительский узел ветки
-- Параметр №2 - новый родительский узел (в который идет перемещение)
create or alter proc MOVE_NODE_BRANCH
	@ANCESTOR_OLD hierarchyid, 
	@ANCESTOR_NEW hierarchyid  
as
begin

declare @HID_DESCENDANT hierarchyid;
declare CURSOR_DESCENDANT cursor for
	select	NODE
	from	CUSTOMERS  
	where	NODE.GetAncestor(1) = @ANCESTOR_OLD;
open CURSOR_DESCENDANT;
fetch next from CURSOR_DESCENDANT into @HID_DESCENDANT;  

while (@@FETCH_STATUS = 0)
	begin  
	START:
		declare @HID_NEW hierarchyid;  
		select	@HID_NEW = @ANCESTOR_NEW.GetDescendant(MAX(NODE), NULL)  
		from	CUSTOMERS 
		where	NODE.GetAncestor(1) = @ANCESTOR_NEW;  

		update	CUSTOMERS 
		set		NODE = NODE.GetReparentedValue(@HID_DESCENDANT, @HID_NEW)  
		where	NODE.IsDescendantOf(@HID_DESCENDANT) = 1;

		if (@@error <> 0)
			goto START
		fetch next from CURSOR_DESCENDANT into @HID_DESCENDANT;  
	end
close CURSOR_DESCENDANT;  
deallocate CURSOR_DESCENDANT;  
end;
go 


exec MOVE_NODE_BRANCH 
	@ANCESTOR_OLD = '/2/', 
	@ANCESTOR_NEW = '/1/';
exec MOVE_NODE_BRANCH 
	@ANCESTOR_OLD = '/1/', 
	@ANCESTOR_NEW = '/2/';
exec GET_DESCENDANTS_BY_HID 
	@HID = '/1/';