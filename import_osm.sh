#!/bin/bash

NAME=$1
CODE=$2
NAME_FIELD=$3
CODE_FIELD=$4
CODE_DESC=$5

service postgresql restart && sleep 20
echo "INSERT INTO mapit_type (code, description) VALUES ('binfo', 'BoundaryInfo'); INSERT INTO mapit_nametype (code, description) VALUES ('binfo', 'BoundaryInfo');" | su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; psql mapit" mapit
echo "INSERT INTO mapit_type (code, description) VALUES ('OSM', 'Open Street Map'); INSERT INTO mapit_nametype (code, description) VALUES ('OSM', 'Open Street Map');" | su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; psql mapit" mapit

su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; /var/www/mapit/mapit/manage.py mapit_import --generation_id 1 --area_type_code $CODE --name_type_code binfo --country_code DE --name_field $NAME_FIELD --code_field $CODE_FIELD --code_type OSM /data/$NAME.shp --commit" mapit
