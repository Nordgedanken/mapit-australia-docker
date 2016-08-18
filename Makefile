default:
	docker build -t nordgedanken/mapit-germany-docker .
run:
	docker run -p 8020:80 -i -t nordgedanken/mapit-germany-docker /bin/bash
server:
	docker run -p 8020:80 -i -t nordgedanken/mapit-germany-docker
download:
	mkdir -p data
	wget "http://biogeo.ucdavis.edu/data/gadm2.8/shp/DEU_adm_shp.zip" -O data/DEU_adm_shp.zip
