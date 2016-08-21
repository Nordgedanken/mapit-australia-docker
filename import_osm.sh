#!/bin/bash

NAME=$1
CODE=$2
NAME_FIELD=$3
CODE_FIELD=$4

service postgresql restart && sleep 20
#echo "INSERT INTO mapit_type (code, description) VALUES ('$CODE', '$DESCRIPTION'); INSERT INTO mapit_nametype (code, description) VALUES ('$CODE', '$DESCRIPTION');" | su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; psql mapit" mapit
#echo "INSERT INTO mapit_type (code, description) VALUES ('$NAME_CODE', '$NAME_CODE_DESC'); INSERT INTO mapit_nametype (code, description) VALUES ('$NAME_CODE', '$NAME_CODE_DESC');" | su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; psql mapit" mapit

su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; /var/www/mapit/mapit/manage.py mapit_import --generation_id 1 --area_type_code $CODE --name_type_code binfo --country_code DE --name_field $NAME_FIELD --code_field $CODE_FIELD /data/$NAME.shp --commit" mapit
