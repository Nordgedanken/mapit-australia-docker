#!/bin/bash

NAME=$1
CODE=$2
DESCRIPTION=$3
NAME_FIELD=$4
FILE_NAME=$5
NAME_CODE=$6

service postgresql restart && sleep 20
echo "INSERT INTO mapit_type (code, description) VALUES ('$CODE', '$DESCRIPTION'); INSERT INTO mapit_nametype (code, description) VALUES ('$CODE', '$DESCRIPTION');" | su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; psql mapit" mapit

echo "unzip"
cd /data; unzip $NAME.zip; rm $NAME.zip
# TODO do proper projection conversion using -s_srs "EPSG:28350" -t_srs "EPSG:4326"
echo "convert"
ogr2ogr -f "KML" -dsco NameField=$NAME_FIELD /data/$FILE_NAME.kml /data/$FILE_NAME.shp
echo "insert"
su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; /var/www/mapit/mapit/manage.py mapit_import --country_code DEU --area_type_code $CODE --name_type_code $NAME_CODE --generation_id 1 --commit /data/$FILE_NAME.kml" mapit
