use Sublish;
alter table CUSTOMERS add NODE hierarchyid;
update CUSTOMERS 
set NODE = hierarchyid::GetRoot() 
where COMPANY_NAME = N'OZ';



-- Процедура, отображающая все подчинённые узлы с указанием уровня иерархии
-- Параметр - значение узла
go
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




-- 4. проц, перемещ всю подчиненную ветку
-- парам - знач верхнего узла + знач узла, в кот. перемещ

create or alter proc MOVE_NODE_BRANCH
	@ANCESTOR_OLD hierarchyid, 
	@ANCESTOR_NEW hierarchyid  
as
begin
DECLARE children_cursor CURSOR FOR  
	SELECT Hid FROM clients  
	WHERE Hid.GetAncestor(1) = @OldParent;  
DECLARE @ChildId hierarchyid;  
OPEN children_cursor  
FETCH NEXT FROM children_cursor INTO @ChildId;  
WHILE @@FETCH_STATUS = 0  
BEGIN  
START:  
    DECLARE @NewId hierarchyid;  
    SELECT @NewId = @NewParent.GetDescendant(MAX(Hid), NULL)  
    FROM clients WHERE Hid.GetAncestor(1) = @NewParent;  

    UPDATE clients 
    SET Hid = Hid.GetReparentedValue(@ChildId, @NewId)  
    WHERE hid.IsDescendantOf(@ChildId) = 1;  
    IF @@error <> 0 GOTO START -- On error, retry  
        FETCH NEXT FROM children_cursor INTO @ChildId;  
END  
CLOSE children_cursor;  
DEALLOCATE children_cursor;  
end;
go 

exec moveHid '/2/','/1/3/';
exec moveHid '/1/3/', '/2/';
select Hid.ToString(), * from clients;