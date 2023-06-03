use Sublish;

--2. ������� �����, ����, ������������, ����������
	create login Lab10_Login with password = '1111';		--�����
	create user Lab10_User for login Lab10_Login;			--����, ����������� � ������
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

--7. ������� ������� ������ ���� ������ � ������������
	create database audit specification MySpecSublish
		for server audit MyAudit
		add (insert on Sublish.dbo.AUTHORS by dbo)
		with (state = on);

	select * from Sublish.dbo.AUTHORS;

	insert into Sublish.dbo.AUTHORS(ID, NAME, SURNAME, COUNTRY, DATE_OF_BIRTH) 
	values (NEWID(), N'���', N'������', N'���', '12-20-1999');

	delete from Sublish.dbo.AUTHORS
	where SURNAME = N'������';

	select statement 
	from fn_get_audit_file('C:\Users\valda\source\repos\semester#6\DB\DB_Lab10\MyAudit\*', null, null);	


--10. ���������� ����� �� � �������
	use master;
	alter server audit MyAudit with (state = off);
	alter server audit PAudit  with (state = off);
	alter server audit AAudit  with (state = off);


---- � � � � � � � � � � ----

--11. ������� ������������� ����
	use Sublish;
	create asymmetric key MyAsymmetricKey
		with algorithm = rsa_2048
		encryption by password = '1111';

--12. ������������ � ������������� ��� ������ �����
	declare @plaintext nvarchar(21);
	declare @ciphertext nvarchar (256);

	set @plaintext = 'hello everyone!';
	print N'�������� �����:        ' + @plaintext;

	set @ciphertext = EncryptByAsymKey(AsymKey_ID('MyAsymmetricKey'), @plaintext);
	print N'������������� �����:   ' + @ciphertext;

	set @plaintext = DecryptByAsymKey(AsymKey_ID('MyAsymmetricKey'), @ciphertext, N'1111');
	print N'�������������� �����:  ' + @plaintext;


--13. ������� ����������
	create certificate MyCertificate
		encryption by password = N'1111'
		with subject = N'My Certificate',
		expiry_date = N'10-10-2024';


--14. ������������ � ������������� ��� ������ �����������
	declare @plain_text nvarchar(58);
	set @plain_text = 'hello pacani';
	print N'�������� �����:        ' + @plain_text;

	declare @cipher_text nvarchar(256);
	set @cipher_text = EncryptByCert(Cert_ID('MyCertificate'), @plain_text);
	print N'������������� �����:   ' + @cipher_text;

	set @plain_text = CAST(DecryptByCert(Cert_ID('MyCertificate'), @cipher_text, N'1111') as nvarchar(58));
	print N'�������������� �����:  ' + @plain_text;
	

--15. ������� ������������ ���� 
	create symmetric key MySymmetricKey
	with algorithm = AES_256
	encryption by password = N'1111';

	create symmetric key MyData
	with algorithm = AES_256
	encryption by symmetric key MySymmetricKey;


--16. ������������ � ������������� ��� ������ �����
	open symmetric key MySymmetricKey
	decryption by password = N'1111';

	open symmetric key MyData
	decryption by symmetric key MySymmetricKey;
	declare @plain_text nvarchar(512);
	set @plain_text = 'hello everyone again';
	print N'�������� �����:        ' + @plain_text;

	declare @cipher_tex nvarchar(1024);
	set @cipher_tex = EncryptByKey(Key_GUID('MyData'), @plain_text);
	print N'������������� �����:   ' + @cipher_tex;

	set @plain_text = CAST(DecryptByKey(@cipher_tex) as nvarchar(512));
	print N'�������������� �����:  ' + @plain_text;

	close symmetric key MyData;
	close symmetric key MySymmetricKey;


--17. ���������� ���������� ��
	use master;
	create master key encryption by password = '1111';
	
	create certificate MyCertificateTDE
		with subject = 'TDE Certificate', 
		expiry_date = '10-10-2024';

	
	use Sublish;
	create database encryption key
	with algorithm = AES_256
	encryption by server certificate MyCertificateTDE;
	go

	alter database Sublish
	set encryption on;
	go

	-- ������� ���������� �� ��
	alter database Sublish 
	set encryption off;
	go


--18. ����������� (MD2, MD4, MD5, SHA1, SHA2)
	use Sublish
	select HashBytes('SHA1', 'hello i need to be hashed') SHA1;
	select HashBytes('MD5', 'and my son need to be hashed too') MD5;


--19. ��� ��� ������ �����������

	--����������� ����� ������������ � ���������� �������
	select * from sys.certificates;
	select SIGNBYCERT(256, N'Sublish', N'1111') as ���;	--����������	
	--0 - ��������, 1 - �� ��������
	select VERIFYSIGNEDBYCERT(256, 'Sublish', 0x0106000000000009010000004D228C4307CD964BC78E7566920B92C179801A42) Verified;
	
	select * from sys.asymmetric_keys;
	select SIGNBYASYMKEY(256, N'Sublish', N'1111') as ���;	--������������� ����
	select VERIFYSIGNEDBYASYMKEY(256, N'Sublish', 0x0100050204000000293841455AFFD0103407CAE23C72BFA10FF5568F794E60D94115642DF6E1086BB5F63835A43E603ADE2B2D774F24AB0B0618FDED34983447DE49D99382DF633781166942BA18CAF0ED4A3E875724E84E844093E4A439C0486C349FCA3506BED3C74BBFC25E5E199C75C96990513E5A295B00BE39A33DB5108C1E69CDF545EE3E73C1B71099CB214B98929FFAB32E2839BAC05B3E4AE585C62D0C19773069B5E797B06F5D21BDF5BFB5747F636F80E79AE954CFB20F2F7DA433A8BCBDFB9F7F60951C298890DE909E30452984FE974696BBB7B0C8B86F8D0FB6414F473A322C7FC84C0F9E8924256D0D1FC1A8E4749068BF6622D9C0AABC497AE88FADFDA684C1) Verified;


--20. ������� ��������� ����� ������ � ������������
	backup certificate MyCertificate
	to file = N'C:\Users\valda\source\repos\semester#6\DB\DB_Lab10\Backup\certificateBackup.cer'
		with private key(
			file = N'C:\Users\valda\source\repos\semester#6\DB\DB_Lab10\Backup\certificateBackup.pvk',
			encryption by password = N'1111',
			decryption by password = N'1111');

	use master;
	BACKUP MASTER KEY TO FILE = 'C:\Users\valda\source\repos\semester#6\DB\DB_Lab10\Backup\masterKeyBackup.key' 
			ENCRYPTION BY PASSWORD = '1111';

		