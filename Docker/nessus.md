# Contenedor nessus

> **OJO**: Producto/Servicio CARÍIIISIMO -- NEVERFUCKINGMIND


## INTRODUCCIÓN

### Documentación

> - [Dockerhub: tenable/nessus](https://hub.docker.com/r/tenable/nessus)
> - [Nessus: Docker setup](https://docs.tenable.com/nessus/Content/DeployNessusDocker.htm)
> - [Nessus: Get Started](https://docs.tenable.com/nessus/Content/GetStarted.htm)
> - [Nessus: Getting Started](https://docs.tenable.com/nessus/Content/GettingStarted.htm)


### Software recomendado

```bash
sudo apt-get install \
    bat grc

# si bat es llamado batcat, renombrar el ejecutable (eg. mv /bin/batcat /bin/bat)
```

## SETUP

### Imagen: Dockerfile

1. Escribe el Dockerfile

```dockerfile
FROM tenable/nessus:10.6.4-ubuntu-20240116
EXPOSE 8834:8834

```

2. Build la imagen y tal

```bash
# Build la imagen en el directorio donde está el Dockerfile
docker build -t nessus_image:v1

# Mira las imágenes
docker image ls

# Mira moviditas
docker image history nessus_image:v1
```



### Runtime: red, volumen, contenedor!!

11. Crear red docker
- 'Avoid Using the Default Bridge Network: [it] is not recommended for production use due to its limitations'

```bash
# Listar redes existentes
docker nework ls

# Crear red
docker network create nessus_network

# # Define parámetros de red
# docker network create --subnet=192.168.100.0/24 --gatewy=192.168.100.1 --ip-range=192.168.100.100/24 nessus_network

# Mirar configuración
docker inspect nessus_network | bat -pl json
docker inspect nessus_network | grep -C 2 'Subnet'
```

12. Crear volumen (RUN)

```bash
docker run -d -p 8834:8834 --name nessus1 nessus_image:v1

```

13. CREAR CONTENEDOR
14. Revisar movidas

15. Revisa la red


```bash
# Mira los contenedores conectados
docker inspect nessus_network | grep -A 10 'Containers'


```


## : Dockerfile (custom image!)





## Opción 2: docker run

```bash
docker run -d --network=nessus_network --name=nessus1 nessus_image:v1


```
