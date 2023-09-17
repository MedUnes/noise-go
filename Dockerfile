ARG GO_VERSION
FROM "golang:${GO_VERSION}-bullseye"

ARG GOPATH
ARG GO111MODULE
ARG APP_NAME
ARG APP_PATH

ENV GOPATH="${GOPATH}"
ENV GO111MODULE="${GO111MODULE}"
ENV APP_NAME="${APP_NAME}"
ENV APP_PATH="${APP_PATH}"

ENV DEBIAN_FRONTEND=noninteractive

ENV TZ="Europe/Berlin"
ENV LC_ALL="C.UTF-8"
ENV LANG="C.UTF-8"

STOPSIGNAL SIGTERM

RUN apt update && \
    apt install -y \
        git \
        mariadb-client \
        software-properties-common \
        zip \
        pwgen \
        procps \
        zip \
        unzip \
        jq \
        net-tools \
        dnsutils \
        bash-completion \
        nano \
        wget \
        netcat \
        sudo \
        zstd \
        libicu-dev \
        libzip-dev \
        zlib1g-dev \
        libzstd-dev \
        libcurl4-openssl-dev \
        pkg-config \
        libssl-dev
RUN  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update && sudo apt install terraform

RUN set -ex; \
    echo "PS1='\h:\w\$ '" >> /etc/bash.bashrc; \
    echo "alias ls='ls --color=auto'" >> /etc/bash.bashrc; \
    echo "alias grep='grep --color=auto'" >> /etc/bash.bashrc;

RUN useradd --create-home --shell /bin/bash docker \
    && passwd docker -d \
    && adduser docker sudo

# Don't require a password for sudo
RUN echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER docker
WORKDIR  "${APP_PATH}"

RUN go install -v github.com/go-delve/delve/cmd/dlv@latest && \
    go install -v github.com/cweill/gotests/gotests@v1.6.0 && \
    go install -v github.com/fatih/gomodifytags@v1.16.0  && \
    go install -v github.com/josharian/impl@v1.1.0  && \
    go install -v github.com/haya14busa/goplay/cmd/goplay@v1.0.0 && \
    go install -v honnef.co/go/tools/cmd/staticcheck@latest && \
    go install -v golang.org/x/tools/gopls@latest 

CMD tail -f /dev/null
