#!/bin/bash

NAME=$1
CODE=$2
NAME_FIELD=$3
CODE_FIELD=$4
CODE_DESC=$5

service postgresql restart && sleep 20
echo "INSERT INTO mapit_type (code, description) VALUES ('binfo', 'BoundaryInfo'); INSERT INTO mapit_nametype (code, description) VALUES ('binfo', 'BoundaryInfo');" | su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; psql mapit" mapit
#echo "OSM TYPE"
#echo "INSERT INTO mapit_type (code, description) VALUES ('osm_rel', 'OSM relation ID'); INSERT INTO mapit_nametype (code, description) VALUES ('osm_rel', 'OSM relation ID');" | su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; psql mapit" mapit

echo "Read Data"
if [ -f /data/$NAME.GeoJson ];
then
   echo "File GeoJson exists."
   cd /data
   su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; /var/www/mapit/mapit/manage.py mapit_import --generation_id 1 --area_type_code O02 --name_type_code binfo --country_code DE --name_field $NAME_FIELD --code_field $CODE_FIELD --code_type osm_rel /data/$NAME.GeoJson --preserve --commit" mapit
else
   echo "File Shapefile exists."
   cd /data
   su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; /var/www/mapit/mapit/manage.py mapit_import --generation_id 1 --area_type_code O02 --name_type_code binfo --country_code DE --name_field $NAME_FIELD --code_field $CODE_FIELD --code_type osm_rel /data/$NAME.shp --preserve --commit" mapit
fi
