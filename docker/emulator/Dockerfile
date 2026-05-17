FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    PATH=/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/opt/android-sdk/emulator:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates wget unzip git curl gnupg2 software-properties-common python3 python3-pip openjdk-11-jdk-headless \
    apt-transport-https lsb-release pkg-config libglu1-mesa socat net-tools \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (needed for ws-scrcpy server) and scrcpy
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get update \
 && apt-get install -y nodejs \
 && apt-get install -y scrcpy || true \
 && rm -rf /var/lib/apt/lists/*

# Install websockify (fallback) and other python tools
RUN python3 -m pip install --no-cache-dir websockify

# Create Android SDK layout and install commandline tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    cd /tmp && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline.zip && \
    unzip cmdline.zip -d /tmp/cmdline && \
    mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    mv /tmp/cmdline/cmdline-tools/* ${ANDROID_SDK_ROOT}/cmdline-tools/latest/ && \
    rm -rf /tmp/cmdline /tmp/cmdline.zip

# Accept licenses and install platform-tools + emulator (no system images by default)
RUN yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses || true
RUN sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "emulator" || true

# Create non-root developer user
RUN useradd -m developer && mkdir -p /home/developer/.android && chown -R developer:developer /home/developer

WORKDIR /home/developer

# Clone ws-scrcpy server as an optional helper (the repo provides a websocket bridge for scrcpy)
RUN git clone https://github.com/Shmayro/ws-scrcpy-docker.git /opt/ws-scrcpy || true
WORKDIR /opt/ws-scrcpy
RUN if [ -f package.json ]; then npm install --production --unsafe-perm; fi || true

COPY docker/emulator/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME ["/home/developer/.android", "/opt/android-sdk"]

EXPOSE 5555 8080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
