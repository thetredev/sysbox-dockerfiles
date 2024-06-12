FROM ghcr.io/thetredev/sysbox-dockerfiles/debian:latest

# Install and configure systemd
ARG BUILD_CONTEXT_PATH=/tmp/build-context-files

RUN --mount=source=./files,target=${BUILD_CONTEXT_PATH},ro \
    ${BUILD_CONTEXT_PATH}/scripts/install-packages.sh \
        systemd \
        systemd-sysv \
        libsystemd0 \
        dbus \
        software-properties-common \
        iptables \
        iproute2 \
        kmod \
        udev \
    && systemctl mask \
        systemd-udevd.service \
        systemd-udevd-kernel.socket \
        systemd-udevd-control.socket \
        systemd-modules-load.service \
        sys-kernel-debug.mount \
        sys-kernel-tracing.mount \
        sys-kernel-config.mount \
    && ln -sf /usr/lib/systemd/system/multi-user.target /etc/systemd/system/default.target

# Optimize journald for container environment
COPY --link=true files/configs/systemd/journald.conf /etc/systemd/journald.conf

# Configure autologin for root
COPY --link=true files/configs/systemd/console-getty.service.d/override.conf /etc/systemd/system/console-getty.service.d/override.conf

# Make use of stopsignal (instead of sigterm) to stop systemd containers.
STOPSIGNAL SIGRTMIN+3

# Set systemd as entrypoint.
ENTRYPOINT [ "/sbin/init", "--log-level=err" ]
CMD []
