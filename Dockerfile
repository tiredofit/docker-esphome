ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.19

FROM docker.io/tiredofit/nginx:${DISTRO}-${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG ESPHOME_VERSION

ENV ESPHOME_VERSION=${ESPHOME_VERSION:-"2024.4.2"} \
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
    addgroup -g 6052 esphome && \
    adduser -S -D -G esphome -u 6052 -h /var/lib/esphome/ -H esphome && \
    package update && \
    package upgrade && \
    package install .esphome-build-deps \
                    python3-dev \
                    py3-pip \
                    && \
    package install .esphome-run-deps \
                    gcompat \
                    python3 \
                    py3-setuptools \
                    && \
    clone_git_repo "${ESPHOME_REPO_URL}" "${ESPHOME_VERSION}" /usr/src/esphome && \
    cd /usr/src/esphome && \
    pip install --break-system-packages -r requirements.txt && \
    /usr/src/esphome/setup.py install && \
    \
    package remove \
                    .esphome-build-deps \
                    && \
    package cleanup && \
    rm -rf \
            /root/.cache \
            /usr/src/esphome \
            /var/lib/esphome

ADD install/ /
