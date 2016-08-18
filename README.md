## Dockerized Mapit with German data pre-loaded
### This is hopefully working

### How to run this

You actually don't need this repository to try it out. The docker image built from this is
automatically available from the [Docker Hub](https://registry.hub.docker.com/u/nordgedanken/mapit-germany-docker/).

1. simple way: run script from this git: https://gist.github.com/MTRNord/824bc53f426a022b2e8e74684fc51837
2. Harder Way: 

First, you'll need to install [Docker](https://docs.docker.com/) if you don't already have it.

Then,
```
docker pull nordgedanken/mapit-germany-docker
docker run -p 8020:80 -d nordgedanken/mapit-germany-docker
```

Point your web browser to [http://localhost:8020](http://localhost:8020) and you should
MapIt Germany.

### Some example queries

#### [http://localhost:8020/point/4326/150.3,-33.7.html](http://localhost:8020/point/4326/150.3,-33.7.html)
Find areas over the point (150.3,-33.7) which is roughly Katoomba, NSW

#### [http://localhost:8020/area/1785.html](http://localhost:8020/area/1785.html)
The postcode 2780

#### [http://localhost:8020/area/1785/intersects.html](http://localhost:8020/area/1785/intersects.html)
All areas that intersect postcode 2780

#### [http://localhost:8020/area/1785/intersects.html?type=CED](http://localhost:8020/area/1785/intersects.html?type=CED)
All Commonwealth Electoral Divisions that intersect 2780.
