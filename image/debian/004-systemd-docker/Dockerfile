FROM ghcr.io/thetredev/sysbox-dockerfiles/debian/systemd:latest

# Install and configure Docker
ARG BUILD_CONTEXT_PATH=/tmp/build-context-files

RUN --mount=source=./files,target=${BUILD_CONTEXT_PATH},ro \
    ${BUILD_CONTEXT_PATH}/scripts/install-docker.sh \
    && mkdir -p /etc/docker \
    && cp ${BUILD_CONTEXT_PATH}/configs/docker/daemon.json /etc/docker/daemon.json \
    && cat ${BUILD_CONTEXT_PATH}/configs/environment/docker >> /etc/environment \
    && sed -i 's/disabled_plugins/# disabled_plugins/' /etc/containerd/config.toml \
    && curl -fsSL https://downloads.nestybox.com/sysbox/releases/v0.6.4/sysbox-ce_0.6.4-0.linux_amd64.deb -o /tmp/sysbox-ce.deb \
    && ${BUILD_CONTEXT_PATH}/scripts/install-packages.sh /tmp/sysbox-ce.deb
