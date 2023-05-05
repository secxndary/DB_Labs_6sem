use Sublish;

-- ����� �����������, ���������� ��� ����������� ������.
	declare @poly1 geometry = 'POLYGON ((1 1, 1 4, 4 4, 4 1, 1 1))';
	declare @poly2 geometry = 'POLYGON ((2 2, 2 6, 6 6, 6 2, 2 2))';
	declare @inters geometry = @poly1.STIntersection(@poly2);
	declare @iskl geometry = @poly1.STDifference(@poly2);
	select	@inters.STAsText() as '�����������', 
			@iskl.STAsText() as '����������';


-- ����� ���������� ����� ����� ���������.
	declare @g geometry;
	declare @h geometry;
	declare @dist float;
	select @g = ogr_geometry.STAsText() from gadm36_blr_1 where ogr_fid=4;
	select @h = ogr_geometry.STAsText() from gadm36_blr_1 where ogr_fid=3;
	select @dist = @g.STDistance(@h);
	select @dist as '����������', (select name_1 from gadm36_blr_1 where ogr_fid=3) as '�����1', 
			name_1 as '�����2' from gadm36_blr_1 where ogr_fid=4;


-- ����� ��������� �������� �������� ����������
	select	name_diler as '�����', 
		name_1 as '�����',
		name_client as '������'
		from dilers d
			join gadm36_blr_1 r on d.city_diler = r.ogr_fid
			join clients c on d.city_diler = c.city_client
		where d.id_diler=4;


-- �������, ���. ���������� ���������
	select	name_diler as '�����', 
		ogr_geometry.STArea() as '�������'
		from dilers d
			join gadm36_blr_1 r on d.city_diler = r.ogr_fid
		where d.id_diler=3;


-- ���� ����� �������� ��� ���. �������
	declare @id_client int = 3;
	declare @ogr int;
	select @ogr = city_client from clients c
		join gadm36_blr_1 r on r.ogr_fid=c.city_client
		where c.id_client = @id_client;
	declare @geogr nvarchar(max);
	select @geogr = ogr_geometry.STAsText() from gadm36_blr_1 where ogr_fid=@ogr;
	
	DECLARE @p as GEOMETRY;
	select @p = geometry::STGeomFromText(@geogr, 0)
	SELECT	@p as geom, name_client, city_client from clients where id_client=@id_client;


