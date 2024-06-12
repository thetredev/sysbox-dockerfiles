FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    TERM=xterm-256color \
    EDITOR=vim \
    GIT_EDITOR=vim

# Install and configure base OS
ARG BUILD_CONTEXT_PATH=/tmp/build-context-files

RUN --mount=source=./files,target=${BUILD_CONTEXT_PATH},ro \
    ${BUILD_CONTEXT_PATH}/scripts/install-file.sh \
    ${BUILD_CONTEXT_PATH}/ca.crt /usr/local/share/ca-certificates/ca.crt \
    && ${BUILD_CONTEXT_PATH}/scripts/install-packages.sh \
        bash-completion \
        ca-certificates \
        curl \
        wget \
        locales \
        gnupg2 \
        vim \
        git \
        coreutils \
        binutils \
        less \
        iputils-ping \
        procps \
    && find /etc/skel -name "*.*" | xargs -I {} cp {} /root \
    && rm -rf /etc/bash.bashrc \
    && cp ${BUILD_CONTEXT_PATH}/configs/bash.bashrc /etc/bash.bashrc \
    && touch /etc/gitconfig

# Set bash as entry command
CMD [ "/bin/bash", "-l" ]

# Set workdir
WORKDIR /root
