FROM ghcr.io/thetredev/sysbox-dockerfiles/debian/systemd:latest

# Install and configure Docker
ARG BUILD_CONTEXT_PATH=/tmp/build-context-files

RUN --mount=source=./files,target=${BUILD_CONTEXT_PATH},ro \
    ${BUILD_CONTEXT_PATH}/scripts/install-docker.sh \
    && cat ${BUILD_CONTEXT_PATH}/configs/environment/docker >> /etc/environment \
    && sed -i 's/disabled_plugins/# disabled_plugins/' /etc/containerd/config.toml
