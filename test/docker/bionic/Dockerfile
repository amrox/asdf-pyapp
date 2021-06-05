FROM ubuntu:18.04

SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    && rm -rf /var/lib/apt

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    python3-wheel \
    && rm -rf /var/lib/apt

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    make \
    build-essential \
    groff \
    libbz2-dev \
    libreadline-dev \
    libssl-dev \
    xz-utils \
    zlib1g-dev \
    && rm -rf /var/lib/apt

ARG ASDF_BRANCH=v0.8.1
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch ${ASDF_BRANCH}

RUN echo ". $HOME/.asdf/asdf.sh" >> ~/.profile

ARG ASDF_PYTHON_VERSION=3.8.8
RUN source /root/.asdf/asdf.sh && asdf plugin add python && asdf install python ${ASDF_PYTHON_VERSION}

#STOPSIGNAL SIGKILL

WORKDIR /root
COPY . asdf-pyapp

ENTRYPOINT ["/bin/bash", "-l", "-c"]
CMD ["tail", "-f", "/dev/null"]

