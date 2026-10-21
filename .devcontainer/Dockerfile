FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG FLUTTER_VERSION=3.44.4
ARG SUPABASE_VERSION=2.121.0
ARG ANDROID_COMMAND_LINE_TOOLS_VERSION=13114758

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
    openjdk-21-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

RUN mkdir -p "$ANDROID_HOME/cmdline-tools" \
    && curl -fsSL --retry 3 \
        "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_COMMAND_LINE_TOOLS_VERSION}_latest.zip" \
        -o /tmp/android-command-line-tools.zip \
    && echo "5fdcc763663eefb86a5b8879697aa6088b041e70  /tmp/android-command-line-tools.zip" | sha1sum -c - \
    && unzip -q /tmp/android-command-line-tools.zip -d "$ANDROID_HOME/cmdline-tools" \
    && mv "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest" \
    && rm /tmp/android-command-line-tools.zip \
    && yes | sdkmanager --licenses >/dev/null \
    && sdkmanager "platform-tools" "platforms;android-34" "platforms;android-35" \
        "platforms;android-36" "build-tools;35.0.0" \
        "build-tools;36.0.0" "ndk;28.2.13676358" "cmake;3.22.1" \
    && chown -R vscode:vscode "$ANDROID_HOME"

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

# Pre-cache web and Android binaries
RUN flutter config --enable-web --enable-android --android-sdk "$ANDROID_HOME" \
    && flutter precache --web --android \
    && flutter --version
