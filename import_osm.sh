#!/bin/bash

NAME=$1
CODE=$2
NAME_FIELD=$3
CODE_FIELD=$4
CODE_DESC=$5
NAME_CODE_DESC=$6

service postgresql restart && sleep 20
echo "INSERT INTO mapit_type (code, description) VALUES ('$CODE', '$CODE_DESC'); INSERT INTO mapit_nametype (code, description) VALUES ('$CODE', '$DESCRIPTION');" | su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; psql mapit" mapit

su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; /var/www/mapit/mapit/manage.py mapit_import --generation_id 1 --area_type_code $CODE --name_type_code binfo --country_code DE --name_field $NAME_FIELD --code_field $CODE_FIELD --code_type OSM /data/$NAME.shp --commit" mapit
