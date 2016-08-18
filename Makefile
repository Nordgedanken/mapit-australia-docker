default:
	docker build -t Nordgedanken/mapit-germany .
run:
	docker run -p 8020:80 -i -t Nordgedanken/mapit-germany /bin/bash
server:
	docker run -p 8020:80 -i -t Nordgedanken/mapit-germany
download:
	mkdir -p data
	wget "http://biogeo.ucdavis.edu/data/gadm2.8/shp/DEU_adm_shp.zip" -O data/DEU_adm_shp.zip
