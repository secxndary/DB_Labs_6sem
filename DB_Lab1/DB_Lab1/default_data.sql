use Sublish;

delete GENRES;
insert into GENRES(ID, NAME, DESCRIPTION) values 
(NEWID(), N'Фэнтези', N'шота ненастоящее типа средневековое эльфы гномы фродо вся хуйня'),
(NEWID(), N'Фантастика', N'че то нереалистичное но уже прям ваще ненастоящее не верится нихуя'),
(NEWID(), N'Детектив', N'кого то хлопнули и ты думаешь ебать а кто это был а хуй знает угадай'),
(NEWID(), N'Комедия', N'дохуя смешно что ли сука в украине детей убивают пока ты ржешь уебок'),
(NEWID(), N'Трагедия', N'продаются детские ботиночки неношенные. это хемингуей написал'),
(NEWID(), N'Драма', N'а в чем сука разница с трагедией я сам не ебу думайте сами'),
(NEWID(), N'Басня', N'коротко ясно и по делу и со смыслом вот это ахуенно лучший жанр эвер'),
(NEWID(), N'Былина', N'хуйня про богатырей а больше былин не было ибо нихуя не было на руси');


delete AUTHORS;
insert into AUTHORS(ID, NAME, SURNAME, COUNTRY, DATE_OF_BIRTH) values 
(NEWID(), N'Чак', N'Паланик', N'США', '12-23-1968'),
(NEWID(), N'Джоан', N'Роулинг', N'Великобритания', '10-25-1983'),
(NEWID(), N'Эрих Мария', N'Ремарк', N'Германия', '12-04-1946'),
(NEWID(), N'Анджей', N'Сапковский', N'Польша', '03-21-1969'),
(NEWID(), N'Васiль', N'Быкаў', N'Беларусь', '02-25-1935'),
(NEWID(), N'Михаил', N'Булкагов', N'Россия', '05-06-1905'),
(NEWID(), N'Фрэнк', N'Герберт', N'США', '07-19-1949');


delete BOOKS;
insert into BOOKS(ID, TITLE, PAGES, AUTHOR_ID) values
(NEWID(), N'Колыбельная', 315, '4EB71310-42DE-4783-8A49-AE8699C959F6'),
(NEWID(), N'Бойцовский клуб', 401, '4EB71310-42DE-4783-8A49-AE8699C959F6'),
(NEWID(), N'Удушье', 294, '4EB71310-42DE-4783-8A49-AE8699C959F6'),
(NEWID(), N'Дюна', 405, '1459D613-63FC-438D-97EE-159F108A4E72'),
(NEWID(), N'Мессия Дюны', 510, '1459D613-63FC-438D-97EE-159F108A4E72'),
(NEWID(), N'Дети Дюны', 572, '1459D613-63FC-438D-97EE-159F108A4E72'),
(NEWID(), N'Гарри Поттер и Узник Азкабана', 340, 'F73FFFE0-86B5-48C6-A9F6-A59682E4E65E'),
(NEWID(), N'Гарри Поттер и Философский Камень', 385, 'F73FFFE0-86B5-48C6-A9F6-A59682E4E65E'),
(NEWID(), N'Три товарища', 652, '04A2AA9F-BC5C-43D5-B8DE-CFFD59B7C6AB'),
(NEWID(), N'Триумфальная Арка', 510, '04A2AA9F-BC5C-43D5-B8DE-CFFD59B7C6AB'),
(NEWID(), N'Чёрный обелиск', 462, '04A2AA9F-BC5C-43D5-B8DE-CFFD59B7C6AB'),
(NEWID(), N'Мастер и Маргарита', 438, 'C8BF07E0-0BEF-4750-A662-D4F0AD72E2A7'),
(NEWID(), N'Людзi на балоце', 274, 'A1372BD9-5E14-4E1E-BF8F-42DA521FD788'),
(NEWID(), N'Альпiйская балада', 408, 'A1372BD9-5E14-4E1E-BF8F-42DA521FD788'),
(NEWID(), N'Ведьмак. Последнее желание', 204, 'E76E81F1-5B41-476C-BBBC-49F5E6D87D90'),
(NEWID(), N'Ведьмак. Меч предназначения', 251, 'E76E81F1-5B41-476C-BBBC-49F5E6D87D90'),
(NEWID(), N'Ведьмак. Цири', 703, 'E76E81F1-5B41-476C-BBBC-49F5E6D87D90');


delete BOOKS_GENRES;
insert into BOOKS_GENRES(BOOK_ID, GENRE_ID) values
('F884FD00-04B4-4924-BBCA-03A13C6F8C31', '033FE4CA-95E1-47EE-A6A3-01F80540930E'),
('AD7C305C-87C5-497F-BC9F-0A0641FC4236', '033FE4CA-95E1-47EE-A6A3-01F80540930E'),
('43C2B041-7D0B-40E8-A27D-2807280D23E4', '033FE4CA-95E1-47EE-A6A3-01F80540930E'),
('1F5A77C8-BCF9-4E64-82E4-4086A550531E', '033FE4CA-95E1-47EE-A6A3-01F80540930E'),
('2654042D-99E1-4AF9-A304-4DE67AE3C4C2', '35C4366F-F6BB-41F7-9F3C-1E9FB61D00AB'),
('43C2B041-7D0B-40E8-A27D-2807280D23E4', '35C4366F-F6BB-41F7-9F3C-1E9FB61D00AB'),
('9B3311F2-E68D-45DB-8708-14363521FC7A', '4A425839-C578-42DE-B56B-F8AC85CA90B8'),
('B0BCE5C3-B30E-4FB2-9ABA-5EFF6B3CCEE2', '4A425839-C578-42DE-B56B-F8AC85CA90B8'),
('92EC755C-F1E2-41BB-B07C-95DBAF70BFD5', '4A425839-C578-42DE-B56B-F8AC85CA90B8'),
('DA02B76F-8C7E-4CC9-9F09-A7708961D0F6', '4A425839-C578-42DE-B56B-F8AC85CA90B8'),
('D3BA19C4-4F9F-44B9-AC20-193F505E7368', 'A4E97B2B-8BFC-4A66-B088-D8F97112AD1F'),
('12D6FBCC-D79D-4DB3-B2A3-2CAD259DF4C0', 'A4E97B2B-8BFC-4A66-B088-D8F97112AD1F'),
('F5764D2E-9D84-4AF1-95E0-68C0DBFB1E01', 'A4E97B2B-8BFC-4A66-B088-D8F97112AD1F'),
('65CDDF29-FB59-4D39-ABE6-839801F835B6', 'A4E97B2B-8BFC-4A66-B088-D8F97112AD1F'),
('270B11E6-EDE9-4BFC-A567-C48BE0447770', 'A4E97B2B-8BFC-4A66-B088-D8F97112AD1F'),
('A91395B4-115F-4D96-A8D5-72FDC36A0B46', '796BEC29-63DF-4D39-98A2-DAE64E2757DD'),
('032E34C0-5BF7-4B60-80E7-C9C8C2AF8AF1', '796BEC29-63DF-4D39-98A2-DAE64E2757DD'),
('DA02B76F-8C7E-4CC9-9F09-A7708961D0F6', '4C2B8101-E5AB-47FA-86E5-8EA2B49FD6BF'),
('07F6AF5E-2090-4997-9C20-D75080D47647', '08365B30-0A43-41BC-8B33-6D6FE1B188C7');


delete CUSTOMERS;
insert into CUSTOMERS(ID, COMPANY_NAME, ADDRESS, PHONE) values
(NEWID(), N'OZ', NULL, '+375291847734'),
(NEWID(), N'Комикс Крама', N'г. Минск, ул. Немига, 3-105', '+375447295733'),
(NEWID(), N'Superlama.by', NULL, '+375333874924'),
(NEWID(), N'Книжный магазин на Пушкинской', N'г. Минск, ул. Пушкина, 105', NULL),
(NEWID(), N'Белкинга', N'г. Минск, пр. Независимости, 65-104', '+375448773954'),
(NEWID(), N'Букваешка', N'г. Минск, ул. Притыкого, 1', '+375257749385'),
(NEWID(), N'Mybooks.by', N'г. Минск, ул. Октрябрьская, 54', NULL);


delete ORDERS;
insert into ORDERS(ID, BOOK_ID, CUSTOMER_ID, ORDER_DATE, QTY, AMOUNT) values
(NEWID(), 'D3BA19C4-4F9F-44B9-AC20-193F505E7368', '5B76B8DF-DDBE-4102-8BA6-5720B3B312D5', '10-12-2023', 10, 280),
(NEWID(), 'DA02B76F-8C7E-4CC9-9F09-A7708961D0F6', '13314115-D1B4-499E-A679-12A380C0B354', '04-05-2023', 28, 360),
(NEWID(), '032E34C0-5BF7-4B60-80E7-C9C8C2AF8AF1', '59E1DBF0-4479-4A01-98D9-8C7649AF19CE', '12-02-2023', 5, 55),
(NEWID(), 'B0BCE5C3-B30E-4FB2-9ABA-5EFF6B3CCEE2', 'DEA93A12-566F-4B18-8D90-B3EC1DAF7E71', '08-20-2023', 12, 350),
(NEWID(), '270B11E6-EDE9-4BFC-A567-C48BE0447770', '13314115-D1B4-499E-A679-12A380C0B354', '01-02-2023', 11, 340),
(NEWID(), '12D6FBCC-D79D-4DB3-B2A3-2CAD259DF4C0', '13314115-D1B4-499E-A679-12A380C0B354', '02-02-2023', 15, 300),
(NEWID(), 'F5764D2E-9D84-4AF1-95E0-68C0DBFB1E01', '13314115-D1B4-499E-A679-12A380C0B354', '03-02-2023', 8, 256),
(NEWID(), '1F5A77C8-BCF9-4E64-82E4-4086A550531E', 'AD241EF8-4C55-4212-A8E9-45BD9EFDD62A', '03-05-2023', 15, 350),
(NEWID(), '2654042D-99E1-4AF9-A304-4DE67AE3C4C2', '5FDECADC-82F3-4B60-9939-FC33DAFE95FF', '10-19-2023', 18, 405),
(NEWID(), '2654042D-99E1-4AF9-A304-4DE67AE3C4C2', '667A9B08-5678-4A2D-9459-318E869FFACB', '05-25-2023', 10, 270);