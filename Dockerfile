FROM ubuntu:24.04

ARG RUNNER_VERSION=2.323.0
ARG GO_VERSION=1.24.2
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt upgrade -y && \
    useradd -ms /bin/bash docker && \
    usermod -aG sudo docker && \
    apt install -y --no-install-recommends \
    curl \
    jq \
    build-essential \
    libssl-dev \
    libffi-dev \
    libicu74 \
    sudo \
    git \
    wget \
    curl \
    axel \
    ffmpeg \
    make \
    cmake \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    git \
    zip \
    tar \
    unzip \
    vim \
    nano \
    ca-certificates

RUN RUNNER_ARCH=$(case $(uname -m) in \
        x86_64) echo "x64" ;; \
        aarch64|arm64) echo "arm64" ;; \
        *) echo "unsupported" ;; \
    esac) && \
    cd /home/docker && \
    mkdir -p actions-runner && cd actions-runner && \
    echo https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz && \
    curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz && \
    rm ./actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz


RUN curl -fsSL https://get.docker.com | sh
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN curl -fsSL https://pyenv.run | bash
RUN RUNNER_ARCH=$(case $(uname -m) in \
        x86_64) echo "amd64" ;; \
        aarch64|arm64) echo "arm64" ;; \
        *) echo "unsupported" ;; \
    esac) && \
    wget https://go.dev/dl/go${GO_VERSION}.linux-${RUNNER_ARCH}.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-${RUNNER_ARCH}.tar.gz && \
    rm go${GO_VERSION}.linux-${RUNNER_ARCH}.tar.gz
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

ENV PATH="/root/.pyenv/bin:/usr/local/go/bin:$PATH"
ENV GOPATH="/root/go"
ENV GOROOT="/usr/local/go"
ENV NVM_DIR="/root/.nvm"

RUN chown -R docker ~docker

WORKDIR /home/docker/actions-runner

RUN ./bin/installdependencies.sh

COPY start.sh /start.sh

ENTRYPOINT ["/start.sh"]
