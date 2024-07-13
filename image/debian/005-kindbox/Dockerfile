FROM ghcr.io/thetredev/sysbox-dockerfiles/debian/systemd/docker:latest

ARG KUBERNETES_VERSION=v1.29

# Install and configure Kindbox
ARG BUILD_CONTEXT_PATH=/tmp/build-context-files

RUN --mount=source=./files,target=${BUILD_CONTEXT_PATH},ro \
    curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBERNETES_VERSION}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && mkdir -p /etc/apt/sources.list.d \
    && cp ${BUILD_CONTEXT_PATH}/configs/apt/kubernetes.list /etc/apt/sources.list.d/kubernetes.list \
    && ${BUILD_CONTEXT_PATH}/scripts/install-packages.sh \
        kubelet \
        kubeadm \
        kubectl \
    && apt-mark hold kubelet kubeadm kubectl \
    && echo "source <(kubectl completion bash)" >> /root/.bashrc \
    && systemctl enable kubelet \
    && sed -i 's/disabled_plugins/# disabled_plugins/' /etc/containerd/config.toml \
    && cp ${BUILD_CONTEXT_PATH}/configs/docker/daemon.json /etc/docker/daemon.json \
    && cp ${BUILD_CONTEXT_PATH}/scripts/prepare-kindbox.sh /usr/local/bin/prepare-kindbox.sh \
    && mkdir -p /root/.kube \
    && curl -L https://raw.githubusercontent.com/nestybox/kindbox/master/scr/kindbox -o /usr/local/bin/kindbox \
    && chmod +x /usr/local/bin/kindbox
