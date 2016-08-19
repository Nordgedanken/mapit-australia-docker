FROM nordgedanken/mapit-docker
MAINTAINER Marcel Radzio <info@nordgedanken.de>


ADD http://biogeo.ucdavis.edu/data/gadm2.8/shp/DEU_adm_shp.zip data/DEU_adm_shp.zip
# The first way is great during development as the step will get cached.
# The second way is great for building on Docker Hub
ENV PYTHONPATH=/usr/local/lib/python2.7/site-packages

RUN ls -la /var/www/mapit
RUN service postgresql restart && sleep 20; echo "INSERT INTO mapit_country (code, name) VALUES ('DEU', 'Germany');" | su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate && psql mapit" mapit
RUN service postgresql restart && sleep 20; su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate && /var/www/mapit/mapit/manage.py mapit_generation_create --desc='Initial import' --commit" mapit
RUN service postgresql restart && sleep 20; su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate && /var/www/mapit/mapit/manage.py mapit_generation_activate --commit" mapit

ADD import.sh /import.sh
RUN chmod +x /import.sh

ADD import2.sh /import2.sh
RUN chmod +x /import2.sh

# All following area id's should start at 10000
RUN service postgresql restart && sleep 20; echo "ALTER SEQUENCE mapit_area_id_seq RESTART WITH 10000;" | su -l -c ". /var/www/mapit/virtualenv-mapit/bin/activate &&  psql mapit" mapit

RUN /import.sh DEU_adm_shp LGA 'Local Government Area' NAME_ENGLI DEU_adm0
RUN /import.sh DEU_adm_shp LGA 'Local Government Area' NAME_0 DEU_adm1
RUN /import.sh DEU_adm_shp LGA 'Local Government Area' NAME_0 DEU_adm2
RUN /import.sh DEU_adm_shp LGA 'Local Government Area' NAME_0 DEU_adm3
RUN /import.sh DEU_adm_shp LGA 'Local Government Area' NAME_0 DEU_adm4

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
