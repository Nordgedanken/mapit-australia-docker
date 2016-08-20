#!/bin/bash

NAME=$1
CODE=$2
DESCRIPTION=$3
NAME_FIELD=$4
FILE_NAME=$5
NAME_CODE=$6
NAME_CODE_DESC=$7

service postgresql restart && sleep 20
echo "INSERT INTO mapit_type (code, description) VALUES ('$CODE', '$DESCRIPTION'); INSERT INTO mapit_nametype (code, description) VALUES ('$CODE', '$DESCRIPTION');" | su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; psql mapit" mapit
echo "INSERT INTO mapit_type (code, description) VALUES ('$NAME_CODE', '$NAME_CODE_DESC'); INSERT INTO mapit_nametype (code, description) VALUES ('$NAME_CODE', '$NAME_CODE_DESC');" | su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; psql mapit" mapit

echo "unzip"
cd /data; unzip $NAME.zip; rm $NAME.zip
# TODO do proper projection conversion using -s_srs "EPSG:28350" -t_srs "EPSG:4326"
#echo "convert"
#ogr2ogr -f "KML" -dsco NameField=$NAME_FIELD /data/$FILE_NAME.kml /data/$FILE_NAME.shp
#echo "insert"
#file -bi /data/$FILE_NAME.shp
#file -bi /data/$FILE_NAME.kml
#su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; /var/www/mapit/mapit/manage.py mapit_import --country_code DEU --area_type_code $CODE --name_type_code $NAME_CODE --generation_id 1 --commit /data/$FILE_NAME.kml" mapit
su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; manage.py mapit_import --generation_id 1 --area_type_code $CODE --name_type_code $NAME_CODE --country_code DEU --name_field $NAME_FIELD /data/$FILE_NAME.shp --commit" mapit
