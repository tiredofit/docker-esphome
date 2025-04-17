ARG DISTRO=debian
ARG DISTRO_VARIANT=bookworm

FROM docker.io/tiredofit/nginx:${DISTRO}-${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG ESPHOME_VERSION

ENV ESPHOME_VERSION=${ESPHOME_VERSION:-"2025.4.0"} \
    ESPHOME_REPO_URL=https://github.com/esphome/esphome \
    ESPHOME_USER=${ESPHOME_USER:-"esphome"} \
    ESPHOME_GROUP=${ESPHOME_GROUP:-"esphome"} \
    PATH="/opt/esphome/bin:$PATH" \
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
            --shell /bin/bash \
            --disabled-login \
            --disabled-password \
            esphome \
            && \
    package update && \
    package upgrade && \
    package install \
                    build-essential \
                    git \
                    clang-format \
                    clang-tidy \
                    patch \
                    python3 \
                    python3-dev \
                    python3-magic \
                    python3-pip \
                    python3-setuptools \
                    python3-venv \
                    && \
    \
    python3 -m venv /opt/esphome && \
    clone_git_repo "${ESPHOME_REPO_URL}" "${ESPHOME_VERSION}" /opt/esphome/app && \
    chown -R "${ESPHOME_USER}":"${ESPHOME_GROUP}" /opt/esphome && \
    cd /opt/esphome/app && \
    sudo -u "${ESPHOME_USER}" /opt/esphome/bin/pip install \
                -r requirements.txt \
                -r requirements_optional.txt \
                -e /opt/esphome/app \
                && \
    package cleanup && \
    rm -rf \
            /root/.cache \
            /usr/src/* \
            /var/lib/esphome

ADD install/ /
