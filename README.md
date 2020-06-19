[![Project status](https://badgen.net/badge/project%20status/stable%20%26%20actively%20maintaned?color=green)](https://github.com/homecentr/docker-grafana/graphs/commit-activity) [![](https://badgen.net/github/label-issues/homecentr/docker-grafana/bug?label=open%20bugs&color=green)](https://github.com/homecentr/docker-grafana/labels/bug) [![](https://badgen.net/github/release/homecentr/docker-grafana)](https://hub.docker.com/repository/docker/homecentr/grafana)
[![](https://badgen.net/docker/pulls/homecentr/grafana)](https://hub.docker.com/repository/docker/homecentr/grafana) 
[![](https://badgen.net/docker/size/homecentr/grafana)](https://hub.docker.com/repository/docker/homecentr/grafana)

![CI/CD on master](https://github.com/homecentr/docker-grafana/workflows/CI/CD%20on%20master/badge.svg)
![Regular Docker image vulnerability scan](https://github.com/homecentr/docker-grafana/workflows/Regular%20Docker%20image%20vulnerability%20scan/badge.svg)


# HomeCentr - grafana

Repack of [Grafana](https://grafana.com/) with the usual Homecentr bells and whistles.

## Usage

```yml
version: "3.7"
services:
  grafana:
    build: .
    image: homecentr/grafana
    ports:
      - 3000:3000
    volumes:
      - ./example:/config
```

## Environment variables

| Name | Default value | Description |
|------|---------------|-------------|
| PUID | 7077 | UID of the user grafana should be running as. |
| PGID | 7077 | GID of the user grafana should be running as. |
| 

## Exposed ports

| Port | Protocol | Description |
|------|------|-------------|
| 3000 | TCP | Web UI and API. |

## Volumes

| Container path | Description |
|------------|---------------|
| /config | Grafana configuration. This should container the `grafana.ini` configuration file. If you want to use [provisioning](https://grafana.com/docs/grafana/latest/administration/provisioning/), put the related files to `/config/provisioning`. |
| /grafana | Grafana state. Make sure the volume is writable for PUID/PGID. |
| /logs | Log files produced by Grafana if configured to. Make sure the volume is writable for PUID/PGID. |

## Security
The container is regularly scanned for vulnerabilities and updated. Further info can be found in the [Security tab](https://github.com/homecentr/docker-grafana/security).

### Container user
The container supports privilege drop. Even though the container starts as root, it will use the permissions only to perform the initial set up. The grafana process runs as UID/GID provided in the PUID and PGID environment variables.

:warning: Do not change the container user directly using the `user` Docker compose property or using the `--user` argument. This would break the privilege drop logic.