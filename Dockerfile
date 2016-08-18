FROM openaustralia/mapit
MAINTAINER Marcel Radzio <info@nordgedanken.de>


ADD http://biogeo.ucdavis.edu/data/gadm2.8/shp/DEU_adm_shp.zip data/DEU_adm_shp.zip
# The first way is great during development as the step will get cached.
# The second way is great for building on Docker Hub

RUN service postgresql start; echo "INSERT INTO mapit_country (code, name) VALUES ('DE', 'Germany');" | su -l -c "psql mapit" mapit

RUN service postgresql start; su -l -c "/var/www/mapit/mapit/manage.py mapit_generation_create --desc='Initial import' --commit" mapit
RUN service postgresql start; su -l -c "/var/www/mapit/mapit/manage.py mapit_generation_activate --commit" mapit

ADD import.sh /import.sh
RUN chmod +x /import.sh

ADD import2.sh /import2.sh
RUN chmod +x /import2.sh

RUN /import2.sh POA_2011_AUST POA 'Postal Area' POA_CODE

# All following area id's should start at 10000
RUN service postgresql start; echo "ALTER SEQUENCE mapit_area_id_seq RESTART WITH 10000;" | su -l -c "psql mapit" mapit

RUN /import.sh LGA_2011_AUST LGA 'Local Government Area' LGA_NAME11
RUN /import.sh SED_2011_AUST SED 'State Electoral Division' SED_NAME
RUN /import.sh COM20111216_ELB_region CED 'Commonwealth Electoral Division' ELECT_DIV
#RUN /import.sh CED_2011_AUST CED 'Commonwealth Electoral Division' CED_NAME
RUN /import.sh STE11aAust STE 'State and Territories' STATE_NAME
RUN /import.sh SSC_2011_AUST SSC 'Suburb' SSC_NAME

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
