use Sublish;


-- создать новую таблицу: Склады
create table WAREHOUSES
(
	ID uniqueidentifier constraint PK_dbo_WAREHOUSES primary key,
	NAME nvarchar(200) NULL,
	CAPACITY int NOT NULL,
	CITY nvarchar(10) NOT NULL
);

insert into WAREHOUSES values
(NEWID(), 'OZ Гродно', 290, 'BY.HR.HR'),
(NEWID(), 'Букваешка Жлобин', 180, 'BY.HO.ZB'),
(NEWID(), 'OZ Ганцевичи', 100, 'BY.BR.GA'),
(NEWID(), 'Комикс Крама Полоцк', 280, 'BY.VI.PL'),
(NEWID(), 'СуперЛама Столбцы', 380, 'BY.MI.SB'),
(NEWID(), 'Белкнига Новогрудок', 350, 'BY.HR.NO');



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



-- Расстояние между двумя объектами
DECLARE @city1 geometry;
DECLARE @city2 geometry;
DECLARE @city1_name nvarchar(max) = 'Bobruysk';
DECLARE @city2_name nvarchar(max) = 'Vileyka';
DECLARE @distance float;

SELECT @city1 = ogr_geometry.STAsText() FROM gadm36_blr_2 WHERE varname_2 = @city1_name;
SELECT @city2 = ogr_geometry.STAsText() FROM gadm36_blr_2 WHERE varname_2 = @city2_name; 
SELECT @distance = @city1.STDistance(@city2);
SELECT @city1_name [City #1], @city2_name [City #2], @distance [Distance];










-- Найти расстояние между двумя объектами.
	declare @g geometry;
	declare @h geometry;
	declare @dist float;
	select @g = ogr_geometry.STAsText() from gadm36_blr_1 where ogr_fid=4;
	select @h = ogr_geometry.STAsText() from gadm36_blr_1 where ogr_fid=3;
	select @dist = @g.STDistance(@h);
	select @dist as 'Расстояние', (select name_1 from gadm36_blr_1 where ogr_fid=3) as 'Город1', 
			name_1 as 'Город2' from gadm36_blr_1 where ogr_fid=4;


-- Найти ближайших клиентов текущему поставщику
	select	name_diler as 'Дилер', 
		name_1 as 'Город',
		name_client as 'Клиент'
		from dilers d
			join gadm36_blr_1 r on d.city_diler = r.ogr_fid
			join clients c on d.city_diler = c.city_client
		where d.id_diler=4;


-- Площадь, кот. охватывает поставщик
	select	name_diler as 'Дилер', 
		ogr_geometry.STArea() as 'Площадь'
		from dilers d
			join gadm36_blr_1 r on d.city_diler = r.ogr_fid
		where d.id_diler=3;


-- Дать карту покрытия для опр. клиента
	--declare @ogr int;
	--select @ogr = city_client from clients c
	--	join gadm36_blr_1 r on r.ogr_fid=c.city_client
	--	where c.id_client = @id_client;
	declare @id_client int = 3;
	declare @geogr nvarchar(max);
	select @geogr = ogr_geometry.STAsText() from gadm36_blr_1 where ogr_fid=5;
	
	DECLARE @p as GEOMETRY;
	select @p = geometry::STGeomFromText(@geogr, 0)
	SELECT	@p as geom	--, name_client, city_client from clients where id_client=@id_client;



