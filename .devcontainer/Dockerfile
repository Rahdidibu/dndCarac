FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG FLUTTER_VERSION=3.44.4
ARG SUPABASE_VERSION=2.121.0

COPY certificates/ /usr/local/share/ca-certificates/
RUN update-ca-certificates

# Install dependencies needed for Flutter and Supabase CLI
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Install the published CLI binary; the former install.sh URL no longer exists.
RUN ARCH="$(dpkg --print-architecture)" \
    && curl -fsSL --retry 3 \
        "https://github.com/supabase/cli/releases/download/v${SUPABASE_VERSION}/supabase_linux_${ARCH}.tar.gz" \
        -o /tmp/supabase.tar.gz \
    && tar -xzf /tmp/supabase.tar.gz -C /usr/local/bin supabase \
    && rm /tmp/supabase.tar.gz \
    && supabase --version

# Install Flutter SDK
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH=$FLUTTER_HOME/bin:$PATH

RUN git clone --depth 1 --branch "$FLUTTER_VERSION" \
        https://github.com/flutter/flutter.git "$FLUTTER_HOME" \
    && chown -R vscode:vscode $FLUTTER_HOME

USER vscode

# Pre-cache web binaries
RUN flutter config --enable-web \
    && flutter precache --web \
    && flutter --version
