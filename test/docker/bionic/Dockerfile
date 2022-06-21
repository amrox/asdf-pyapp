FROM ubuntu:18.04

SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND noninteractive

# Deps required for asdf
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  git \
  && rm -rf /var/lib/apt

# Install system python3
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  python3 \
  python3-dev \
  python3-pip \
  python3-venv \
  python3-wheel \
  && rm -rf /var/lib/apt

# Deps required to build python and common deps via asdf
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  make \
  build-essential \
  libbz2-dev \
  libffi-dev \
  libreadline-dev \
  libssl-dev \
  libsqlite3-dev \
  xz-utils \
  zlib1g-dev \
  && rm -rf /var/lib/apt

ARG ASDF_BRANCH=v0.8.1
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch ${ASDF_BRANCH}

RUN echo ". $HOME/.asdf/asdf.sh" >> ~/.profile

RUN source /root/.asdf/asdf.sh && asdf plugin add python
RUN source /root/.asdf/asdf.sh && asdf install python 3.5.10
RUN source /root/.asdf/asdf.sh && asdf install python 3.8.10

RUN source /root/.asdf/asdf.sh && asdf plugin add direnv
RUN source /root/.asdf/asdf.sh && asdf install direnv 2.28.0

# NOTE: direnv hook only works for interactive shells
RUN echo -e '#eval "$(asdf exec direnv hook bash)"\n\
  direnv() { asdf exec direnv "$@"; }\n'\
  >> ~/setup-direnv.bash

#RUN echo -e 'eval "$(asdf exec direnv export bash)"\n\
#  direnv() { asdf exec direnv "$@"; }\n'\
#  >> ~/setup-direnv.bash

## Hook direnv into your shell.
#RUN echo "eval \"\$(asdf exec direnv hook bash)\"" >> ~/.profile
## A shortcut for asdf managed direnv.
#RUN echo "eval direnv() { asdf exec direnv \"\$@\"; }" >> ~/.profile
## Make the 'use asdf' feature available:
RUN mkdir -p ~/.config/direnv && echo "source \"\$(asdf direnv hook asdf)\"" >> ~/.config/direnv/direnvrc

# Extras:
#  - groff is required for awscli
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  groff \
  && rm -rf /var/lib/apt

WORKDIR /root
COPY . asdf-pyapp

# app pipenv needs this, and probably generally a good thing
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENTRYPOINT ["/bin/bash", "-l", "-c"]
CMD ["tail", "-f", "/dev/null"]

