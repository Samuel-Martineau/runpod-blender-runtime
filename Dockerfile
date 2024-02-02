FROM nytimes/blender:2.82-gpu-ubuntu18.04

COPY start.sh /
RUN chmod +x /start.sh

# MIT License

# Copyright (c) 2022 Run-Pod

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV SHELL=/bin/bash
ENV PYTHONUNBUFFERED=True
ENV DEBIAN_FRONTEND=noninteractive

# Shared python package cache
ENV VIRTUALENV_OVERRIDE_APP_DATA="/runpod-volume/.cache/virtualenv/"
ENV PIP_CACHE_DIR="/runpod-volume/.cache/pip/"

# Set Default Python Version
ENV PYTHON_VERSION="3.10"

WORKDIR /

# Update, upgrade, install packages and clean up
RUN apt-get update --yes && \
  apt-get upgrade --yes && \
  # Basic Utilities
  apt-get install --yes --no-install-recommends \
  bash \
  ca-certificates \
  curl \
  file \
  git \
  inotify-tools \
  libgl1 \
  vim \
  nano \
  tmux \
  nginx \
  # Required for SSH access
  openssh-server \
  procps \
  rsync \
  sudo \
  software-properties-common \
  unzip \
  wget \
  zip && \
  # Build Tools and Development
  apt-get install --yes --no-install-recommends \
  build-essential \
  make \
  cmake \
  gfortran \
  libblas-dev \
  liblapack-dev && \
  # Image and Video Processing
  apt-get install --yes --no-install-recommends \
  ffmpeg \
  libavcodec-dev \
  libavfilter-dev \
  libavformat-dev \
  libavutil-dev \
  libjpeg-dev \
  libpng-dev \
  libpostproc-dev \
  libswresample-dev \
  libswscale-dev \
  libtiff-dev \
  libv4l-dev \
  libx264-dev \
  libxext6 \
  libxrender-dev \
  libxvidcore-dev && \
  # Deep Learning Dependencies and Miscellaneous
  apt-get install --yes --no-install-recommends \
  libatlas-base-dev \
  libffi-dev \
  libhdf5-serial-dev \
  libsm6 \
  libssl-dev && \
  # File Systems and Storage
  apt-get install --yes --no-install-recommends \
  cifs-utils \
  nfs-common \
  zstd &&\
  # Cleanup
  apt-get autoremove -y && \
  apt-get clean && \
  rm -rf /var/lib/apt-get/lists/* && \
  # Set locale
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

RUN curl https://pyenv.run | bash

ENV PATH="/root/.pyenv/bin:$PATH"
RUN eval "$(pyenv init --path)"
RUN eval "$(pyenv virtualenv-init -)"

RUN printf 'export PATH="$HOME/.pyenv/bin:$PATH"\neval "$(pyenv init --path)"\neval "$(pyenv virtualenv-init -)"\n' >> /root/.bashrc

RUN pyenv install 3.10.13
RUN pyenv global 3.10.13

CMD ["/start.sh"]
