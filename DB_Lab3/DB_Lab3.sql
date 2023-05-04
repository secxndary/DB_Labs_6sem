use Sublish;

exec sp_configure 'clr enabled', 1;
reconfigure;
exec sp_configure 'show advanced options', 1
reconfigure;
exec sp_configure 'clr strict security', 0;
reconfigure;

alter database Sublish set trustworthy on;


create assembly DB_Lab3
from 'C:\Users\valda\source\repos\semester#6\DB\DB_Lab3\DB_Lab3\bin\Debug\DB_Lab3.dll'
with permission_set = UNSAFE;
go


create type Address external name DB_Lab3.Address;
--  drop type Address;


declare @address as Address;
set @address = 'Tomina, 14, 25';
print @address.ToString();


create procedure SendEmail
@receiver nvarchar(200)
as
external name DB_Lab3.StoredProcedures.SendEmailUsingCLR
--  drop procedure SendEmail


exec SendEmail 'valdaitsevv@mail.ru';
