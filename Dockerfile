FROM python:3.9.13

LABEL maintainer="Vladimir Puzakov <vppuzakov.rambler.ru>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Configure environments
ENV DEBIAN_FRONTEND noninteractive \
    SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=on \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=120

# install build dependencies
RUN apt-get update --yes \
 && apt-get upgrade --yes \
 && apt-get install --yes --no-install-recommends \
        build-essential \
        sudo \
        tini \
        wget \
        locales \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen

# Install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - \
 && sudo apt-get install -y nodejs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install jupyterlab
RUN pip install notebook jupyterhub jupyterlab \
 && npm cache clean --force \
 && jupyter notebook --generate-config \
 && jupyter lab clean
