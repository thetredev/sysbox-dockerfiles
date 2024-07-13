#!/bin/bash

for image_dir in $(ls -d image/*); do
    docker compose -f ${image_dir}/manifest.yml build \
        --with-dependencies \
        --pull ${@}
done
