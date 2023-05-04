## Как создать сборку и CLR процедуру?
0. Проект – Библиотека классов (.NET Framework)
1. Если используется процедура отправки почты, то надо настроить пароли сторонних приложений в Gmail и указать свою почту и пароль в StoredProcedures.cs
2. Собрать проект
3. cd \DB\DB_Lab3\DB_Lab3       -- убедитесь, что в абсолютном пути нет русских символов
4. %SYSTEMROOT%\Microsoft.NET\Framework\v2.0.50727\csc.exe /target:library Address.cs
5. %SYSTEMROOT%\Microsoft.NET\Framework\v2.0.50727\csc.exe /target:library StoredProcedures.cs
6. Последовательно запустить SQL-скрипт
7. При обновлении данных в таблице отправляется e-mail