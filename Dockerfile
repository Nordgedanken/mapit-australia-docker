FROM nordgedanken/mapit-docker
MAINTAINER Marcel Radzio <info@nordgedanken.de>

ADD http://biogeo.ucdavis.edu/data/gadm2.8/shp/DEU_adm_shp.zip data/DEU_adm_shp.zip
ADD http://media.nordgedanken.de/OSM/Germany.shp data/Germany.shp
ADD http://media.nordgedanken.de/OSM/de_postal_codes.csv data/de_postal_codes.csv
ADD http://download.geonames.org/export/zip/DE.zip data/DE.zip
RUN cd /data; unzip DE.zip; DE.zip; cd ..
RUN ls -la data
RUN ls -la data/Germany.shp
ENV PYTHONPATH=/usr/local/lib/python2.7/site-packages

#RUN service postgresql restart && sleep 20; echo "INSERT INTO mapit_country (code, name) VALUES ('DE', 'Germany');" | su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate && psql mapit" mapit
RUN service postgresql restart && sleep 20; su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate && /var/www/mapit/mapit/manage.py mapit_generation_create --desc='Initial import' --commit" mapit
#RUN service postgresql restart && sleep 20; su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate && /var/www/mapit/mapit/manage.py mapit_generation_activate --commit" mapit

ADD fixture_de.json /var/www/mapit/mapit/fixtures/de.json
ADD mapit_de/countries.py /var/www/mapit/mapit/countries.py
RUN service postgresql restart && sleep 20; su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate && /var/www/mapit/mapit/manage.py loaddata /var/www/mapit/mapit/fixtures/de.json" mapit

ADD import.sh /import.sh
RUN chmod +x /import.sh

ADD import_osm.sh /import_osm.sh
RUN chmod +x /import_osm.sh

RUN chmod 755 data/de_postal_codes.csv
RUN chmod 755 data/DE.txt
RUN chmod 755 data/Germany.shp
RUN chown -R mapit:mapit data
RUN ls -la data

ADD postalcodes.sh /postalcodes.sh
RUN chmod +x /postalcodes.sh
ADD postalcodes2.sh /postalcodes2.sh
RUN chmod +x /postalcodes2.sh

RUN /postalcodes.sh de_postal_codes 1 7 6
RUN /postalcodes2.sh DE 2 11 10

# All following area id's should start at 10000
#RUN service postgresql restart && sleep 20; echo "ALTER SEQUENCE mapit_area_id_seq RESTART WITH 10000;" | su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate &&  psql mapit" mapit

RUN /import.sh DEU_adm_shp O02 'Country' NAME_ENGLI DEU_adm0 full 'English Name'
RUN /import.sh DEU_adm_shp O04 'Federal State' NAME_1 DEU_adm1 full 'English Name'
RUN /import.sh DEU_adm_shp O05 'County' NAME_2 DEU_adm2 full 'English Name'
RUN /import.sh DEU_adm_shp O08 'Municipality' NAME_3 DEU_adm3 full 'English Name'
RUN /import.sh DEU_adm_shp O08 'Town' NAME_4 DEU_adm4 full 'English Name'

#RUN /import_osm.sh Germany O07 "NAME,C,84" "ADMIN_LEVE,C,2"

RUN service postgresql restart && sleep 20; su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate && /var/www/mapit/mapit/manage.py mapit_generation_activate --commit" mapit

ADD copyright.html /var/www/mapit/mapit/mapit/templates/mapit/copyright.html
ADD country.html /var/www/mapit/mapit/mapit/templates/mapit/country.html

RUN rm -rf /data

# TODO: Make mapit handle areas with numeric names
# TODO: Look for more authoritive sources for state electoral boundaries
# TODO: Look for more authoritive sources for state electoral LGAs
# TODO: Include Aborginal Areas
# TODO: Include Suburbs
# TODO: Include Council Wards?
# TODO: Update LGAs with 2013 data
#
# Victorian Council Ward & State Electoral Division Boundaries: https://www.vec.vic.gov.au/publications/publications-maps.html
# South Australian LGAs: http://dpti.sa.gov.au/open_data_portal
