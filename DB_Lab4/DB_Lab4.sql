use Sublish;


-- Создать новую таблицу: Склады
create table WAREHOUSES
(
	ID uniqueidentifier constraint PK_dbo_WAREHOUSES primary key,
	CUSTOMER_ID uniqueidentifier constraint FK_dbo_WAREHOUSES_dbo_CUSTOMERS foreign key references CUSTOMERS(ID),
	NAME nvarchar(200) NULL,
	CAPACITY int NOT NULL,
	CITY nvarchar(10) NOT NULL
);

delete WAREHOUSES;
insert into WAREHOUSES values
(NEWID(), '13314115-D1B4-499E-A679-12A380C0B354', N'OZ Гродно', 290, 'BY.HR.HR'),
(NEWID(), 'AD241EF8-4C55-4212-A8E9-45BD9EFDD62A', N'Букваешка Жлобин', 180, 'BY.HO.ZB'),
(NEWID(), '13314115-D1B4-499E-A679-12A380C0B354', N'OZ Ганцевичи', 100, 'BY.BR.GA'),
(NEWID(), '59E1DBF0-4479-4A01-98D9-8C7649AF19CE', N'Комикс Крама Полоцк', 280, 'BY.VI.PL'),
(NEWID(), '5FDECADC-82F3-4B60-9939-FC33DAFE95FF', N'СуперЛама Столбцы', 380, 'BY.MI.SB'),
(NEWID(), '5B76B8DF-DDBE-4102-8BA6-5720B3B312D5', N'Белкнига Новогрудок', 350, 'BY.HR.NO');




-- Пересечение, исключение и объединение данных
DECLARE @polygon1 geometry;
SET @polygon1 = geometry::STPolyFromText('POLYGON((0 0, 0 3, 3 3, 3 0, 0 0))', 0);

DECLARE @polygon2 geometry;
SET @polygon2 = geometry::STPolyFromText('POLYGON((1 1, 1 4, 4 4, 4 1, 1 1))', 0);

DECLARE @intersection geometry;
SET @intersection = @polygon1.STIntersection(@polygon2);
SELECT @intersection.STAsText() [Пересечение];	-- общая зона, в которой пересекаются две фигуры

DECLARE @difference geometry;
SET @difference = @polygon1.STDifference(@polygon2);
SELECT @difference.STAsText() [Исключение];		-- всё, кроме общей зоны пересечения фигур

DECLARE @union geometry;
SET @union = @polygon1.STUnion(@polygon2);
SELECT @union.STAsText() [Объединение];			-- вообще всё на графике: и отдельные, и общие части фигур




-- Расстояние между двумя городами
DECLARE @city1 geometry;
DECLARE @city2 geometry;
DECLARE @city1_name nvarchar(max) = 'Bobruysk';
DECLARE @city2_name nvarchar(max) = 'Vileyka';
DECLARE @distance float;

SELECT @city1 = ogr_geometry.STAsText() FROM gadm36_blr_2 WHERE varname_2 = @city1_name;
SELECT @city2 = ogr_geometry.STAsText() FROM gadm36_blr_2 WHERE varname_2 = @city2_name; 
SELECT @distance = @city1.STDistance(@city2);
SELECT @city1_name [City #1], @city2_name [City #2], @distance [Distance];




-- Найти N ближайших складов к текущему местоположению (данному городу)
DECLARE @source_geometry geometry;
DECLARE @source_name nvarchar(max) = 'BY.VI.PL';
DECLARE @n int = 5;
SELECT @source_geometry = ogr_geometry.STAsText() FROM gadm36_blr_2 WHERE hasc_2 = @source_name;

SELECT TOP (@n) 
	NAME, 
	CAPACITY, 
	CITY, 
	@source_geometry.STDistance(
	(
		SELECT ogr_geometry.STAsText() 
		FROM gadm36_blr_2 
		WHERE hasc_2 = CITY)
	) AS DISTANCE
FROM 
	WAREHOUSES
CROSS APPLY 
	(
		SELECT ogr_geometry 
		FROM gadm36_blr_2 
		WHERE hasc_2 = WAREHOUSES.CITY
	) AS t(ogr_geometry)
WHERE 
	CITY != @source_name
ORDER BY 
	DISTANCE ASC;




-- Площадь города склада
DECLARE @id uniqueidentifier = '5B1E6B82-8C0C-432D-9BE5-DC16CCE0BA5F';

SELECT	
	ID,
	NAME, 
	CITY,
	ogr_geometry.STArea() AS AREA
FROM
	WAREHOUSES
JOIN
	gadm36_blr_2 MAP
ON 
	CITY = MAP.hasc_2
WHERE 
	ID = @id;




-- Карта города по ID склада
DECLARE @id uniqueidentifier = '63550580-C93B-4E1A-A221-DEA5B6EAE95A';
DECLARE @geogr nvarchar(max);

SELECT	@geogr = ogr_geometry.STAsText() 
FROM gadm36_blr_2 
WHERE hasc_2 = 
(
	SELECT CITY 
	FROM WAREHOUSES 
	WHERE ID = @id
);

DECLARE @p as GEOMETRY;
SELECT @p = geometry::STGeomFromText(@geogr, 0)

SELECT 
	@p as my_geometry, 
	NAME, 
	CITY 
FROM 
	WAREHOUSES 
WHERE 
	ID = @id;
