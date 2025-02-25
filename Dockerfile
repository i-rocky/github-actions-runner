FROM ubuntu:24.04

ARG RUNNER_VERSION=2.322.0
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt upgrade -y && \
    useradd -ms /bin/bash docker && \
    usermod -aG sudo docker && \
    apt install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip libicu74 sudo git wget

RUN if [ "$DOCKER_DEFAULT_PLATFORM" == "linux/amd64" ]; then \
        RUNNER_ARCH=x64; \
    else if [ "$DOCKER_DEFAULT_PLATFORM" == "linux/arm64" ]; then \
        RUNNER_ARCH=arm64; \
    fi &&  \
    cd /home/docker && \
    mkdir -p actions-runner && cd actions-runner && \
    curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz && \
    rm ./actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz

RUN chown -R docker ~docker

WORKDIR /home/docker/actions-runner

RUN ./bin/installdependencies.sh

COPY start.sh /start.sh

ENTRYPOINT ["/start.sh"]
