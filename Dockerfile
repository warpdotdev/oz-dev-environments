FROM ubuntu:latest

# =============================================================================
# VERSION CONFIGURATION
# =============================================================================
ARG NODE_VERSION=22.0.0
ARG GO_VERSION=1.23.4
ARG RUST_VERSION=1.83.0
ARG JAVA_VERSION=21
ARG DOTNET_VERSION=8.0
ARG RUBY_VERSION=3.3

# =============================================================================
# INSTALL FLAGS
# =============================================================================
ARG INSTALL_RUST=false
ARG INSTALL_GO=false
ARG INSTALL_JAVA=false
ARG INSTALL_DOTNET=false
ARG INSTALL_RUBY=false
ARG INSTALL_BROWSERS=false
ARG LANGUAGES=""

# Base dependencies
RUN apt-get update && apt-get install -y \
    curl ca-certificates build-essential git \
 && rm -rf /var/lib/apt/lists/*

# Node.js (always installed)
RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
      amd64) ARCH='x64';; \
      arm64) ARCH='arm64';; \
    esac; \
    curl --proto '=https' --tlsv1.2 -fsSLO --compressed "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-$ARCH.tar.xz" && \
    tar -xJf node-v${NODE_VERSION}-linux-$ARCH.tar.xz -C /usr/local --strip-components=1 --no-same-owner && \
    rm node-v${NODE_VERSION}-linux-$ARCH.tar.xz && \
    ln -s /usr/local/bin/node /usr/local/bin/nodejs && \
    npm install -g corepack && \
    corepack enable && \
    node --version && \
    npm --version

# Python (always installed)
RUN apt-get update && apt-get install -y \
      python3 python3-pip python3-venv && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/* && \
    python --version

# Rust
RUN if [ "$INSTALL_RUST" = "true" ]; then \
      echo 'export RUSTUP_HOME=/usr/local/rustup' >> /etc/profile.d/rust.sh && \
      echo 'export CARGO_HOME=/usr/local/cargo' >> /etc/profile.d/rust.sh && \
      echo 'export PATH=/usr/local/cargo/bin:$PATH' >> /etc/profile.d/rust.sh && \
      . /etc/profile.d/rust.sh && \
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION && \
      chmod -R a+w $RUSTUP_HOME $CARGO_HOME && \
      rustc --version && \
      cargo --version ; \
    fi

# Go
RUN if [ "$INSTALL_GO" = "true" ]; then \
      set -eux; \
      dpkgArch="$(dpkg --print-architecture)"; ARCH="${dpkgArch##*-}"; \
      curl --proto '=https' --tlsv1.2 -fsSLO https://go.dev/dl/go${GO_VERSION}.linux-$ARCH.tar.gz && \
      tar -C /usr/local -xzf go${GO_VERSION}.linux-$ARCH.tar.gz && \
      rm go${GO_VERSION}.linux-$ARCH.tar.gz && \
      echo 'export PATH=/usr/local/go/bin:$PATH' >> /etc/profile.d/go.sh && \
      . /etc/profile.d/go.sh && \
      go version ; \
    fi

# Java (Eclipse Temurin) + Maven + Gradle
RUN if [ "$INSTALL_JAVA" = "true" ]; then \
      apt-get update && apt-get install -y wget apt-transport-https gnupg && \
      wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor -o /usr/share/keyrings/adoptium.gpg && \
      echo "deb [signed-by=/usr/share/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb $(. /etc/os-release && echo $VERSION_CODENAME) main" > /etc/apt/sources.list.d/adoptium.list && \
      apt-get update && apt-get install -y temurin-${JAVA_VERSION}-jdk maven gradle && \
      rm -rf /var/lib/apt/lists/* && \
      java --version && \
      mvn --version && \
      gradle --version ; \
    fi

# .NET SDK
RUN if [ "$INSTALL_DOTNET" = "true" ]; then \
      apt-get update && apt-get install -y wget libicu-dev && \
      dpkgArch="$(dpkg --print-architecture)"; \
      case "${dpkgArch}" in \
        amd64) DOTNET_ARCH='x64';; \
        arm64) DOTNET_ARCH='arm64';; \
      esac; \
      wget https://dot.net/v1/dotnet-install.sh -O /tmp/dotnet-install.sh && \
      chmod +x /tmp/dotnet-install.sh && \
      /tmp/dotnet-install.sh --channel ${DOTNET_VERSION} --install-dir /usr/share/dotnet --architecture $DOTNET_ARCH && \
      ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet && \
      rm /tmp/dotnet-install.sh && \
      rm -rf /var/lib/apt/lists/* && \
      dotnet --version ; \
    fi

# Ruby + Bundler
RUN if [ "$INSTALL_RUBY" = "true" ]; then \
      apt-get update && apt-get install -y ruby-full && \
      gem install bundler && \
      rm -rf /var/lib/apt/lists/* && \
      ruby --version && \
      bundler --version ; \
    fi

# Browsers (Google Chrome + Firefox)
RUN if [ "$INSTALL_BROWSERS" = "true" ]; then \
      apt-get update && apt-get install -y \
        wget \
        libdbus-glib-1-2 && \
      # Install Google Chrome from upstream
      wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
      apt-get install -y ./google-chrome-stable_current_amd64.deb && \
      rm google-chrome-stable_current_amd64.deb && \
      # Install Firefox from Mozilla
      wget -q -O firefox.tar.xz "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" && \
      tar -xf firefox.tar.xz -C /opt && \
      ln -s /opt/firefox/firefox /usr/local/bin/firefox && \
      rm firefox.tar.xz && \
      rm -rf /var/lib/apt/lists/* && \
      echo "Chrome version:" && google-chrome --version && \
      echo "Firefox version:" && firefox --version ; \
    fi

LABEL languages="${LANGUAGES}"
