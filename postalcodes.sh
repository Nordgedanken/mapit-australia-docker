#!/bin/bash

FILE_NAME=$1
CODES=$2
LONG=$3
LAT=$4

service postgresql restart && sleep 20

su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate; /var/www/mapit/mapit/manage.py mapit_import_postal_codes --code-field $CODES --coord-field-lon $LONG --coord-field-lat $LAT /tmp/$FILE_NAME.csv --commit" mapit
