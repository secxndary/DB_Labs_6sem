use Sublish;

--2. ������� �����, ����, ������������, ����������
	create login Lab10_Login with password = '1111';		--�����
	create user Lab10_User for login Lab10_Login;			--����, ������. � ������
	create user DefaultUser without login;					--����
	create role DefaultRole;								--����

-- ����������:
	exec as user = 'DefaultUser'
	select * from AUTHORS;		-- ���������� �� DefaultUser, ���� ��� ���
	
	revert;		-- ��������� � ��������� �����
	grant select, insert, update, delete on AUTHORS to DefaultUser;

	revoke select on AUTHORS from DefaultUser;
	EXEC sp_addrolemember @rolename = 'DefaultRole', @membername = 'DefaultUser';


--3. ������������� ���� ��� ���������
	create login Alice with password = 'alice';
	create login Bob with password = 'bob';
	create user Alice for login Alice;
	create user Bob for login Bob;

	exec sp_addrolemember 'db_datareader', 'Alice';
	exec sp_addrolemember 'db_ddladmin', 'Alice';
	deny select on AUTHORS to Bob;
	
	go 
	create or alter proc GET_AUTHORS_AS_ALICE 
	with execute as 'Alice'
	as 
		select * 
		from AUTHORS;
	go

	alter authorization on GET_AUTHORS_AS_ALICE to Alice;
	grant execute on GET_AUTHORS_AS_ALICE to Bob;
	
	setuser 'Bob';
	exec GET_AUTHORS_AS_ALICE;
	select * from AUTHORS;
	setuser;


---- � � � � � � � � �     � � � � � ----

--4. ������� ��������� �����
	use master;
	create server audit MyAudit 
	to file(
		filepath = 'C:\Users\valda\source\repos\semester#6\DB\DB_Lab10\MyAudit',
		maxsize = 0 mb,
		max_rollover_files = 0,
		reserve_disk_space = off
	) with ( queue_delay = 1000, on_failure = continue);

	create server audit PAudit to application_log;
	create server audit AAudit to security_log;

	select * from sys.server_audits;


--5. ������ ��� ���������� ������ ������������
	create server audit specification MySpecs
		for server audit MyAudit
		add (database_change_group)
		with (state = on)

--6. ��������� ��������� �����, �������� ������ ������
	alter server audit MyAudit with (state = on);

	create database example;
	drop   database example;
	
	alter server audit MyAudit with (state = off);



---- � � � � �    � � � �    � � � � � � ----

--7. ������� ������� ������ �� + ���� + ������ + ������
	create database audit specification DatabaseAuditSpecification1
		for server audit MyAudit
		add (insert on [Sklad].dbo.Products by dbo)
		with (state=on);

	select * from [Sklad].dbo.Products;
	delete from [Sklad].dbo.Products where name_product='�����';
	insert into [Sklad].dbo.Products(name_product, kol) values ('�����', 28);

	select statement from fn_get_audit_file('D:\3\��\10\*', null, null);	


--10. ���������� ����� �� � �������
	alter server audit MyAudit with (state=off);
	alter server audit PAudit with (state=off);
	alter server audit AAudit with (state=off);


---- � � � � � � � � � � ----

--11. ������� �����. ���� ����������
	use Sklad;
	create asymmetric key SampleAKey
		with algorithm = rsa_2048
		encryption by password = 'Pas45!!~~';

--12. ������ � ����- ������ ��� ��� �����
	declare @plaintext nvarchar(21);
	declare @ciphertext nvarchar (256);

	set @plaintext = 'this is a sample text';
	print @plaintext;

	set @ciphertext = EncryptByAsymKey(AsymKey_ID('SampleAKey'), @plaintext);
	print @ciphertext;

	set @plaintext = DecryptByAsymKey(AsymKey_ID('SampleAKey'), @ciphertext, N'Pas45!!~~');
	print @plaintext;


--13. ������� ����������
	create certificate SampleCert
		encryption by password = N'pa$$W0RD'
		with subject = N'Sample Certificate',
		expiry_date = N'31/10/2022';


--14. ������ � ������ ������ ��� ���. �����������.
	declare @plain_text nvarchar(58);
	set @plain_text = 'this is certificate encryption text';
	print @plain_text;

	declare @cipher_text nvarchar(256);
	set @cipher_text = EncryptByCert(Cert_ID('SampleCert'), @plain_text);
	print @cipher_text;

	set @plain_text = CAST(DecryptByCert(Cert_ID('SampleCert'), @cipher_text, N'pa$$W0RD') as nvarchar(58));
	print @plain_text;
	

--15. ������� ����. ���� ����������
	create symmetric key SKey
	with algorithm = AES_256
	encryption by password = N'PA$$W0RD';

	open symmetric key SKey
	decryption by password = N'PA$$W0RD';

	create symmetric key SData
	with algorithm = AES_256
	encryption by symmetric key SKey;

	open symmetric key SData
	decryption by symmetric key SKey;


--16. ������ � ������� ������ ��� ���. �����
	declare @plain_tex nvarchar(512);
	set @plain_tex = 'open the symmetric key with which to encrypt the data';
	print @plain_tex;

	declare @cipher_tex nvarchar(1024);
	set @cipher_tex = EncryptByKey(Key_GUID('SData'), @plain_tex);
	print @cipher_tex;

	set @plain_tex = CAST(DecryptByKey(@cipher_tex) as nvarchar(512));
	print @plain_tex;

	close symmetric key SData;
	close symmetric key SKey;

--17. ������. ���������� ���������� ��
	use master;
	create master key encryption by password = 'p@$$wOrd';
	
	create certificate LabCert
		with subject = 'certificate to encrypt Lab10 DB ', 
		expiry_date = '31/10/2020';

	
	use Sklad;
	create database encryption key
	with algorithm = AES_256
	encryption by server certificate LabCert;
	go

	alter database Sklad
	set encryption on;
	go

	--������� ���������� �� ��
	alter database Sklad 
	set encryption off;
	go


--18. ������. ����������� (MD2, MD4, MD5, SHA1, SHA2)
	use Sklad
	--
	select HashBytes('SHA1', 'open the symmetric key with which to encrypt the data');
	select HashBytes('MD4', 'open the symmetric key with which to encrypt the data');


--19. ������ ���������� ��� ��� ������ �����������.

	--����������� ����� ������������ � ���������� �������
	select * from sys. certificates;
	select SIGNBYCERT(258, N'univer', N'pa$$W0RD') as ���;	--����������	
	--0 - ��������, 1 - �� ��������
	select VERIFYSIGNEDBYCERT(258, 'univer', 0x0106000000000009010000004D228C4307CD964BC78E7566920B92C179801A42);
	
	select * from sys. asymmetric_keys;
	select SIGNBYASymKey(256, N'univer', N'Pas45!!~~') as ���;	--��.����
	select VERIFYSIGNEDBYASYMKEY(256, N'univer', 0x0602000000240000525341310004000001000100272736AD6E5F9586BAC2D531EABC3ACC666C2F8EC879FA94F8F7B0327D2FF2ED523448F83C3D5C5DD2DFC7BC99C5286B2C125117BF5CBE242B9D41750732B2BDFFE649C6EFB8E5526D526FDD130095ECDB7BF210809C6CDAD8824FAA9AC0310AC3CBA2AA0523567B2DFA7FE250B30FACBD62D4EC99B94AC47C7D3B28F1F6E4C8);


--20. ������� ��������� ����� ����������� ������ � ������������.
	backup certificate SampleCert
	to file = N'D:\3\��\10\backup\BackupSampleCert.cer'
		with private key(
			file = N'D:\3\��\10\backup\BackupSampleCert.pvk',
			encryption by password = N'pa$$W0RD',
			decryption by password = N'pa$$W0RD');

	use master;
	BACKUP MASTER KEY TO FILE = 'D:\3\��\10\backup\BackupMasterKey.key' 
			ENCRYPTION BY PASSWORD = 'p@$$wOrd';

		