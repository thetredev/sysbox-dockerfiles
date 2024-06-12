#!/bin/bash

apt-get update
apt-get install -y --no-install-recommends ${@}
apt-get clean -y

rm -rf \
    /var/cache/debconf/* \
    /var/lib/apt/lists/* \
    /var/log/* \
    /tmp/* || true \
    /var/tmp/* || true \
    /usr/share/doc/* \
    /usr/share/man/* \
    /usr/share/local/*
