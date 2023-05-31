use Sublish;


-- 1. ����� ������� � ����������� ��������
SELECT DISTINCT
    CUSTOMERS.COMPANY_NAME,
    SUM(ORDERS.AMOUNT) OVER (PARTITION BY CUSTOMERS.ID) AS TOTAL_AMOUNT
FROM
    CUSTOMERS
JOIN
    ORDERS ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID
ORDER BY
	TOTAL_AMOUNT DESC;




-- 2. ��������� (� ���������) � ����� ������� �������
WITH Aggregates AS (
    SELECT
        CUSTOMERS.ID,
        SUM(ORDERS.AMOUNT) AS TOTAL_AMOUNT
    FROM
        CUSTOMERS
    JOIN
        ORDERS ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID
    GROUP BY
        CUSTOMERS.ID
)
SELECT
    CUSTOMERS.COMPANY_NAME,
    Aggregates.TOTAL_AMOUNT,
    CAST(100. * Aggregates.TOTAL_AMOUNT / SUM(Aggregates.TOTAL_AMOUNT) OVER () AS DECIMAL(5,2)) AS PERCENTAGE
FROM
    CUSTOMERS
JOIN
    Aggregates ON CUSTOMERS.ID = Aggregates.ID;




-- 3. ��������� � ���������� ������� �������
SELECT
    CUSTOMERS.COMPANY_NAME,
    ORDERS.AMOUNT,
    MAX(ORDERS.AMOUNT) OVER (PARTITION BY CUSTOMERS.ID) AS MAX_AMOUNT,
    CAST(100. * ORDERS.AMOUNT / MAX(ORDERS.AMOUNT) OVER (PARTITION BY CUSTOMERS.ID) AS DECIMAL(5,2)) AS PERCENTAGE
FROM
    CUSTOMERS
JOIN
    ORDERS ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID;




-- 4. ������� ���������� ������� �� ��������
DECLARE @PageNumber INT = 2;
SELECT *
FROM
(
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY ID) AS rn
    FROM ORDERS
) AS Subquery
WHERE rn BETWEEN ((@PageNumber - 1) * 20) + 1 AND @PageNumber * 20;




-- 5. ������� ���������, ��������� ROW_NUMBER()
DELETE AUTHORS WHERE SURNAME = N'�����';
INSERT INTO AUTHORS(ID, NAME, SURNAME, COUNTRY, DATE_OF_BIRTH) VALUES 
(NEWID(), N'�����', N'�����', N'��������', '12-20-2015'),
(NEWID(), N'�����', N'�����', N'��������', '12-20-2015'),
(NEWID(), N'�����', N'�����', N'��������', '12-20-2015');

DELETE x FROM
(
	SELECT 
		*, 
		rn = ROW_NUMBER() OVER (PARTITION BY NAME, SURNAME, COUNTRY, DATE_OF_BIRTH ORDER BY NAME)
	FROM 
		AUTHORS
) x
WHERE 
	rn > 1;




-- 6. �������� ����� ������� ��������� ��� ������ �������� (�� 6 �������)
SELECT
    COMPANY_NAME,
    MONTH([ORDER_DATE]) AS ORDER_MONTH,
    SUM(AMOUNT) OVER (PARTITION BY COMPANY_NAME, MONTH([ORDER_DATE]) ORDER BY [ORDER_DATE]) AS MONTLY_AMOUNT
FROM
    ORDERS O
JOIN 
	CUSTOMERS C ON O.CUSTOMER_ID = C.ID
WHERE
    [ORDER_DATE] >= DATEADD(MONTH, -6, GETDATE())
ORDER BY
    COMPANY_NAME, ORDER_MONTH, MONTLY_AMOUNT;




-- 7. ����� ����, � ������� �������� ������ ����� ���� � ������� ������
WITH CTE_AuthorGenre AS 
(
	SELECT
		AUTHORS.NAME AS AuthorName,
		AUTHORS.SURNAME AS AuthorSurname,
		GENRES.NAME AS GenreName,
		ROW_NUMBER() OVER (PARTITION BY AUTHORS.ID ORDER BY COUNT(*) DESC) AS Rank
	FROM
		AUTHORS
	JOIN
		BOOKS ON AUTHORS.ID = BOOKS.AUTHOR_ID
	JOIN
		BOOKS_GENRES ON BOOKS.ID = BOOKS_GENRES.BOOK_ID
	JOIN
		GENRES ON BOOKS_GENRES.GENRE_ID = GENRES.ID
	GROUP BY
		AUTHORS.ID, AUTHORS.NAME, AUTHORS.SURNAME, GENRES.NAME
)
SELECT
	AuthorName,
	AuthorSurname,
	GenreName
FROM
	CTE_AuthorGenre
WHERE
	Rank = 1;
