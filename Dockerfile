FROM nordgedanken/mapit-docker
MAINTAINER Marcel Radzio <info@nordgedanken.de>

ADD http://media.nordgedanken.de/OSM/Germany.shp data/Germany.shp
ADD http://media.nordgedanken.de/OSM/Germany.shx data/Germany.shx
ADD http://media.nordgedanken.de/OSM/Germany.dbf data/Germany.dbf
ADD http://media.nordgedanken.de/OSM/Germany.prj data/Germany.prj
ADD http://download.geonames.org/export/zip/DE.zip data/DE.zip
RUN cd /data; unzip DE.zip; DE.zip; cd ..

RUN service postgresql restart && sleep 20; su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate && /var/www/mapit/mapit/manage.py mapit_generation_create --desc='Initial import' --commit" mapit
RUN service postgresql restart && sleep 20; su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate && /var/www/mapit/mapit/manage.py loaddata /var/www/mapit/mapit/mapit_de/fixtures/de.json" mapit

ADD import_osm.sh /import_osm.sh
RUN chmod +x /import_osm.sh

RUN chmod 755 data/DE.txt
RUN chmod 755 data/Germany.shp
RUN chmod 755 data/Germany.shx
RUN chmod 755 data/Germany.dbf
RUN chmod 755 data/Germany.prj
RUN chown -R mapit:mapit data
RUN ls -la data

ADD postalcodes.sh /postalcodes.sh
RUN chmod +x /postalcodes.sh

RUN /postalcodes.sh DE 2 11 10

RUN /import_osm.sh Germany O02 "NAME" "ADMIN_LEVE"

RUN service postgresql restart && sleep 20; su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate && /var/www/mapit/mapit/manage.py mapit_generation_activate --commit" mapit

RUN rm -rf /data
