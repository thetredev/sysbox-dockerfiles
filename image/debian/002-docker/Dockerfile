FROM ghcr.io/thetredev/sysbox-dockerfiles/debian:latest

# Install and configure Docker
ARG BUILD_CONTEXT_PATH=/tmp/build-context-files

RUN --mount=source=./files,target=${BUILD_CONTEXT_PATH},ro \
    ${BUILD_CONTEXT_PATH}/scripts/install-docker.sh \
    && sed -i 's/disabled_plugins/# disabled_plugins/' /etc/containerd/config.toml
