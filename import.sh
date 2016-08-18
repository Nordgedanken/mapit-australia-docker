#!/bin/bash

NAME=$1
CODE=$2
DESCRIPTION=$3
NAME_FIELD=$4
FILE_NAME=$5

service postgresql start
echo "INSERT INTO mapit_type (code, description) VALUES ('$CODE', '$DESCRIPTION'); INSERT INTO mapit_nametype (code, description) VALUES ('$CODE', '$DESCRIPTION');" | su -l -c "psql mapit" mapit

cd /data; unzip $NAME.zip; rm $NAME.zip
# TODO do proper projection conversion using -s_srs "EPSG:28350" -t_srs "EPSG:4326"
ogr2ogr -f "KML" -dsco NameField=$NAME_FIELD /data/$FILE_NAME.kml /data/$FILE_NAME.shp
su -l -c "/var/www/mapit/mapit/manage.py mapit_import --country_code DE --area_type_code $FILE_NAME --name_type_code $FILE_NAME --generation_id 1 --commit /data/$FILE_NAME.kml" mapit
