ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.19

FROM docker.io/tiredofit/${DISTRO}:${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG ESPHOME_VERSION

ENV ESPHOME_VERSION=${ESPHOME_VERSION:-"2024.4.0"} \
    ESPHOME_REPO_URL=https://github.com/esphome/esphome \
    IMAGE_NAME="tiredofit/esphome" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-esphome"

RUN source /assets/functions/00-container && \
    set -x && \
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
    rm -rf /usr/src/esphome

ADD install/ /
