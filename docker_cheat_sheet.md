# Docker Cheat Sheet

## Docker CLI

### Management

|                            |                                       |
|----------------------------|---------------------------------------|
|`docker info`               |Display system information             |
|`docker version`            |Display the system's version           |
|`docker login`              |Log in to a Docker registry            |

### Running and stopping

|                                      |                             |
|--------------------------------------|-----------------------------|
|`docker pull [imageName]`             |Pull an image from a registry|
|`docker run [imageName]`              |Run containers               |
|`docker run -d [imageName]`           |Detached mode                |
|`docker start [containerName]`        |Start stopped containers     |
|`docker ps`                           |List running containers      |
|`docker ps -a`                        |List running and stopped containers|
|`docker stop [containerName]`         |Stop containers              |
|`docker kill [containerName]`         |Kill containers              |
|`docker image inspect [imageName]`    |Get image info               |

### Limits

|                                      |                             |
|--------------------------------------|-----------------------------|
|`docker run --memory="256m" nginx`    |Max memory                   |
|`docker run --cpus=".5" nginx`        |Max CPU                      |

### Attach Shell

|                                      |                             |
|--------------------------------------|-----------------------------|
|`docker run -it nginx /bin/bash`   |Attach shell                 |
|`docker run -it microsoft/powershell:nanoserver pwsh.exe`|Attach Powershell|
|`docker container exec -it [containerName] bash`|Attach to a running container|

### Cleaning up

|                                      |                             |
|--------------------------------------|-----------------------------|
|`docker rm [containerName]`           |Removes stopped containers   |
|`docker rm $(docker ps -a -q)`        |Removes all stopped containers|
|`docker images`                       |List images                  |
|`docker rmi [imageName]`              |Deletes the image            |
|`docker system prune -a`              |Removes all images not in use by any containers|

### Building

|                                      |                             |
|--------------------------------------|-----------------------------|
|`docker build -t [name:tag] .`        |Builds an image using a Dockerfile located in the same folder|
|`docker build -t [name:tag] -f [fileName]`|Builds an image using a Dockerfile located in a different folder|
|`docker tag [imageName] [name:tag]`   |Tag an existing image        |

### Volumes

|                                      |                             |
|--------------------------------------|-----------------------------|
|`docker create volume [volumeName]`   |Creates a new volume         |
|`docker volume ls`                    |Lists the volumes            |
|`docker volume inspect [volumeName]`  |Display the volume info      |
|`docker volume rm [volumeName]`       |Deletes a volume             |
|`docker volume prune`                 |Deletes all volumes not mounted|

### Docker Compose

|                                      |                             |
|--------------------------------------|-----------------------------|
|`docker compose build`                |Build the images             |
|`docker compose start`                |Start the containers         |
|`docker compose stop`                 |Stop the containers          |
|`docker compose up -d`                |Build and start              |
|`docker compose ps`                   |List what's running          |
|`docker compose rm`                   |Remove from memory           |
|`docker compose down`                 |Stop and remove              |
|`docker compose logs`                 |Get the logs                 |
|`docker compose exec [container] bash`|Run a command in a container |

#### Docker Compose V2 (New Commands)

|                                      |                             |
|--------------------------------------|-----------------------------|
|`docker compose --project-name test1 up -d`|Run an instance as a project|
|`docker compose -p test2 up -d`       |Shortcut                     |
|`docker compose ls`            `      |List running projects        |
|`docker compose cp [containerID]:[SRC_PATH] [DEST_PATH]`|Copy files from the container|
|`docker compose cp [SRC_PATH] [containerID]:[DEST_PATH]`|Copy files to the container|

---

### Running a container

```
# pull and run an nginx server
# `--publish 80:80` maps the host port to the container listening port
# `--name webserver` container local name
# `nginx` container image in the Docker registry
docker run --publish 80:80 --name webserver nginx

# list the running containers
docker ps

# stop the container
docker stop webserver

# remove the container
docker rm webserver
```

---

### Dockerfile Example - static HTML site

```Dockerfile
FROM nginx:alpine
COPY . /usr/share/nginx/html
```

```
# build
docker build -t webserver-image:v1 .

# run 
docker run -d -p 8080:80 webserver-image:v1

# display
curl localhost:8080
```

### Dockerfile Example - Node site

```Dockerfile
# Base image
FROM alpine
# Install Node and NPM using the package manager
RUN apk add -update nodejs nodejs-npm
# Copy the files from the build context
COPY . /src
WORKDIR /src
# Run a command
RUN npm install
# Adds metadata
EXPOSE 8080
# What to run
ENTRYPOINT ["node", "./app.js"]
```

---

### Mapping a Volume

```
# create a volume
docker volume create myvol

# inspect the volume
docker volume inspect myvol

# list the volumes
docker volume ls

# run a container with a volume
# `-v myvol:/app` mapping the volume to a logical folder
docker run -d --name devtest -v myvol:/app nginx:latest
```

#### Mapping to a local folder

```
# run a container with a volume
# `d:/test` specify a folder
docker run -d --name devtest -v d:/test:/app nginx:latest

# inspect the container
docker inspect devtest
```

---

## Docker Compose

- Plugin for docker
    - *define and run multi-container Docker applications with [YAML](./yaml_cheat_sheet.html)*
- `docker: 'compose' is not a docker command.`
    - **Solution:** On some systems (I think this pertains to Docker Compose V1), `docker compose` should be run as `docker-compose`

### Example Docker Compose file

The following example defines 3 containers:

```yaml
version: '3.9'

services:
  webapi1:
    image: academy.azurecr.io/webapi1
    ports:
      - '8081:80'
    restart: always

  webapi2:
    image: academy.azurecr.io/webapi2
    ports:
      - '8082:80'
    restart: always

  apigateway:
    image: academy.azurecr.io/apigateway
    ports:
      - '80:80'
    restart: always
```

### Docker Compose Example

```
# build the service
docker compose build

# builds, (re)creates, starts, attaches to containers for a service
docker compose up

# list the services
docker compose ps

# bring down what was created by UP
docker compose down
```

### Resource Limits example

```yaml
services:
  redis:
    image: redis:alpine
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 150M
        reservations:
          cpus: '0.25'
          memory: 20M
```

### Environment Variables example

```yaml
services:
  web:
    image: nginx:alpine
    environment:
      - DEBUG=1
      - FOO=BAR
```

Environment variables can be overwritten at the command line:
- `docker compose up -d -e DEBUG=0`

#### Referencing an environment variable

```
# set an environment variable
export POSTGRES_VERSION=14.3

# powershell
$env:POSTGRES_VERSION="14.3"
```

```yaml
services:
  db:
    images: "postgres:${POSTGRES_VERSION}"
```

You can also create a `.env` file containing environment variable definitions

### Dependence example

```yaml
services:
  app:
    image: myapp
    depends_on:
      - db
  db:
    image: postgres
    networks:
      - back-tier
```

The example Docker Compose file has the `db` service start before the `app` service can start

### Volumes example

```yaml
services:
  app:
    image: myapp
    depends_on:
      - db
  db:
    image: postgres
    volumes:
      - db-data:/etc/data
    networks:
      - back-tier

volumes:
  db-data:
```

### Restart Policy example

```yaml
services:
  app:
    image: myapp
    restart: always
    depends_on:
      - db
  db:
    image: postgres
    restart: always
```

- By default, containers will not be restarted upon reboot
- Possible options include:

|                  |                                                 |
|------------------|-------------------------------------------------|
|`no`              |Does not restart a container under any circumstances (default)|
|`always`          |Always restarts the container until its removal  |
|`on-failure`      |Restarts a container if the exit code indicates an error|
|`unless-stopped`  |Restarts a container irrespective of the exit code but will stop restarting when the service is stopped or removed|
