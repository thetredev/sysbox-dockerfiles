FROM ghcr.io/thetredev/sysbox-dockerfiles/debian/systemd/docker:latest

ARG KUBERNETES_VERSION=v1.30

ARG KUBERNETES_APT_REPO=https://pkgs.k8s.io/core:/stable:/${KUBERNETES_VERSION}/deb
ARG KUBERENTES_APT_REPO_PATH=/etc/apt/sources.list.d/kubernetes.list

ARG KUBERNETES_APT_REPO_KEYRING_URL=${KUBERNETES_APT_REPO}/Release.key
ARG KUBERNETES_APT_REPO_KEYRING_PATH=/etc/apt/keyrings/kubernetes-apt-keyring.gpg

ARG CRI_DOCKERD_URL=https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.15/cri-dockerd_0.3.15.3-0.debian-bookworm_amd64.deb


# Install and configure Kindbox
ARG BUILD_CONTEXT_PATH=/tmp/build-context-files

RUN --mount=source=./files,target=${BUILD_CONTEXT_PATH},ro \
    ${BUILD_CONTEXT_PATH}/scripts/install-docker-repository.sh \
    && curl -fsSL ${KUBERNETES_APT_REPO_KEYRING_URL} | gpg --dearmor -o ${KUBERNETES_APT_REPO_KEYRING_PATH} \
    && mkdir -p /etc/apt/sources.list.d \
    && echo "deb [signed-by=${KUBERNETES_APT_REPO_KEYRING_PATH}] ${KUBERNETES_APT_REPO}/ /" > ${KUBERENTES_APT_REPO_PATH} \
    && ${BUILD_CONTEXT_PATH}/scripts/install-packages.sh \
        kubelet \
        kubeadm \
        kubectl \
    && apt-mark hold kubelet kubeadm kubectl containerd.io \
    && echo "source <(kubectl completion bash)" >> /root/.bashrc \
    && systemctl enable kubelet containerd \
    && install -d -m 0600 /root/.kube \
    && cd /tmp \
    && curl -fsSL -O ${CRI_DOCKERD_URL} \
    && apt install -y ./cri-dockerd_*.deb \
    && rm -rf ./cri-dockerd_*.deb
