FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install dependencies needed for Flutter
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter SDK
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH=$PATH:$FLUTTER_HOME/bin

RUN git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME \
    && git config --global --add safe.directory $FLUTTER_HOME \
    && chown -R vscode:vscode $FLUTTER_HOME

USER vscode

# Pre-cache web binaries
RUN flutter precache --web
