#!/bin/bash

NAME=$1
CODE=$2
NAME_FIELD=$3
CODE_FIELD=$4

service postgresql restart && sleep 20

su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; /var/www/mapit/mapit/manage.py mapit_import --generation_id 1 --area_type_code $CODE --name_type_code binfo --country_code DE --name_field $NAME_FIELD --code_field $CODE_FIELD --code_type OSM /data/$NAME.shp --commit" mapit
