## Как запустить лабу:

1. Установить GDAL ([Подробный гайд](https://medium.com/@FMatz/installation-of-gdal-3-6-3-incl-oracle-spatial-oci-extension-and-python-3-9-under-windows-10-7c42d3250cd3))

2. Прописать в коммандной строке команду: 
```
ogr2ogr -update -f MSSQLSpatial -lco "GEOM_TYPE=geography" -a_srs "EPSG:4326" "MSSQL:server=YOUR_SERVER;database=YOUR_DATABASE;Trusted_connection=Yes;Driver=ODBC Driver 17 for SQL Server" "..\DB\DB_Lab4\World_Countries"
```
