1. Установить GDAL
Гайд по установке: https://medium.com/@FMatz/installation-of-gdal-3-6-3-incl-oracle-spatial-oci-extension-and-python-3-9-under-windows-10-7c42d3250cd3
2. Прописать в коммандной строке команду
ogr2ogr -update -f MSSQLSpatial -lco "GEOM_TYPE=geography" -a_srs "EPSG:4326" "MSSQL:server=(localdb)\MSSQLLocalDB;database=Sublish;trusted_connection=yes;Driver=ODBC Driver 17 for SQL Server" "C:\Users\valda\source\repos\semester#6\DB\DB_Lab4\World_Countries"