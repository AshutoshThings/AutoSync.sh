FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    wget \
    vim \
    nano \
    bash\
    rclone \
    unzip \
    rclone \           
    inotify-tools \

    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
CMD ["tail", "-f", "/dev/null"]

