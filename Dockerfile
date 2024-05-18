ARG DISTRO=debian
ARG DISTRO_VARIANT=bookworm

FROM docker.io/tiredofit/nginx:${DISTRO}-${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG ESPHOME_VERSION

ENV ESPHOME_VERSION=${ESPHOME_VERSION:-"2024.5.0"} \
    ESPHOME_REPO_URL=https://github.com/esphome/esphome \
    NGINX_SITE_ENABLED=esphome \
    NGINX_WEBROOT=/var/lib/nginx/wwwroot \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_LOG_ACCESS_LOCATION=/logs/nginx \
    NGINX_LOG_ERROR_LOCATION=/logs/nginx \
    NGINX_PROXY_BUFFERS="12 256k" \
    NGINX_WORKER_PROCESSES=1 \
    IMAGE_NAME="tiredofit/esphome" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-esphome"

RUN source /assets/functions/00-container && \
    set -x && \
    addgroup --gid 6052 esphome && \
    adduser --uid 6052 \
            --gid 6052 \
            --gecos "ESPHome" \
            --home /var/lib/esphome \
            --shell /sbin/nologin \
            --disabled-login \
            --disabled-password \
            esphome \
            && \
    package update && \
    package upgrade && \
    package install \
                    git \
                    python3 \
                    python3-dev \
                    python3-magic \
                    python3-pip \
                    python3-setuptools \
                    python3-venv \
                    && \
    clone_git_repo "${ESPHOME_REPO_URL}" "${ESPHOME_VERSION}" /usr/src/esphome && \
    cd /usr/src/esphome && \
    pip install --break-system-packages -r requirements.txt && \
    pip install --break-system-packages -r requirements_optional.txt && \
    /usr/src/esphome/setup.py install && \
    package cleanup && \
    rm -rf \
            /root/.cache \
            /usr/src/esphome \
            /var/lib/esphome

ADD install/ /
