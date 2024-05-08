# github.com/tiredofit/temp

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-esphome?style=flat-square)](https://github.com/tiredofit/docker-esphome/releases)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-esphome/build?style=flat-square)](https://github.com/tiredofit/docker-esphome/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/temp.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/temp/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/temp.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/temp/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

## About

This will build a Docker Image for [ESPHome](https://esphome.io), A system to control your microcontrollers by simple yet powerful configuration files.

## Maintainer

- [Dave Conroy](https://github.com/tiredofit/)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Container Options](#container-options)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)


## Installation
### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/esphome).

```
docker pull tiredofit/esphome:(imagetag)
```

Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/esphome/pkgs/container/esphome)

```
docker pull ghcr.io/tiredofit/docker-esphome:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory  | Description          |
| ---------- | -------------------- |
| `/config/` | Configuration folder |
| `/data/`   | Data                 |
| `/logs`    | Logs                 |

* * *
### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |
| [Nginx](https://github.com/tiredofit/docker-nginx/)    | Nginx webserver                        |



#### Container Options
| Variable        | Value                                                                       | Default       | _FILE |
| --------------- | --------------------------------------------------------------------------- | ------------- | ----- |
| `ADMIN_USER`    | Admin User                                                                  | ``            | x     |
| `ADMIN_PASS`    | Admin Pass                                                                  | ``            | x     |
| `CACHE_PATH`    | Data Directory                                                              | `/cache/`     |       |
| `CONFIG_PATH`   | Configuration directory                                                     | `/config/`    |       |
| `ENABLE_NGINX`  | Enable Nginx Frontend webserver                                             | `TRUE`        |       |
| `ESPHOME_USER`  | ESPHome User                                                                | `esphome`     |       |
| `ESPHOME_GROUP` | ESPHome Group                                                               | `esphome`     |       |
| `LISTEN_IP`     | Bind IP                                                                     | `0.0.0.0`     |       |
| `LISTEN_PORT`   | Listening Port                                                              | `6052`        |       |
| `LOG_PATH`      | Log Path                                                                    | `/logs/`      |       |
| `LOG_FILE`      | Log File                                                                    | `esphome.log` |       |
| `LOG_TYPE`      | `console` `file` `both` `none`                                              | `FILE`        |       |
| `PROXY_PORT`    | When using `ENABLE_NGINX` it may be required to set your origin port        | `443`         |       |
|                 | aka what PORT your system is connecting to the proxy, usually `80` or `443` |               |       |

### Networking

| Port   | Protocol | Description          |
| ------ | -------- | -------------------- |
| `80`   | `tcp`    | Nginx                |
| `6052` | `tcp`    | ESPHome Web Interace |

## Maintenance
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is) bash
```
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- [Sponsor me](https://github.com/sponsors/tiredofit) for personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- [Sponsor me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- [SponsorS me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* <https://esphome.io>