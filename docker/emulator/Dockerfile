FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    PATH=/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/opt/android-sdk/emulator:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates wget unzip git curl gnupg2 python3 python3-pip openjdk-11-jdk-headless \
    apt-transport-https lsb-release pkg-config libglu1-mesa socat net-tools supervisor \
    qemu-kvm qemu-system-x86 qemu-utils nodejs npm scrcpy || true \
 && rm -rf /var/lib/apt/lists/*

# Install websockify and python helpers
RUN python3 -m pip install --no-cache-dir websockify || true

# Ensure wget/unzip are available before downloading commandline tools
RUN apt-get update && apt-get install -y --no-install-recommends wget unzip || true && rm -rf /var/lib/apt/lists/*

# Create Android SDK layout and install commandline tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    cd /tmp && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline.zip && \
    unzip cmdline.zip -d /tmp/cmdline && \
    mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    mv /tmp/cmdline/cmdline-tools/* ${ANDROID_SDK_ROOT}/cmdline-tools/latest/ && \
    rm -rf /tmp/cmdline /tmp/cmdline.zip

# Accept licenses and install platform-tools + emulator
RUN yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses || true
RUN sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "emulator" || true

# Create non-root developer user
RUN useradd -m developer || true && mkdir -p /home/developer/.android && chown -R developer:developer /home/developer

WORKDIR /home/developer

# Optional ws-scrcpy helper (web scrcpy bridge)
RUN git clone https://github.com/Shmayro/ws-scrcpy-docker.git /opt/ws-scrcpy || true
WORKDIR /opt/ws-scrcpy
RUN if [ -f package.json ]; then npm install --production --unsafe-perm; fi || true

# Supervisor config and helper scripts
COPY docker/emulator/supervisord.conf /etc/supervisor/supervisord.conf
COPY docker/emulator/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY docker/emulator/first-boot.sh /usr/local/bin/first-boot.sh
COPY docker/emulator/emulator-runner.sh /usr/local/bin/emulator-runner.sh
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/first-boot.sh /usr/local/bin/emulator-runner.sh

VOLUME ["/home/developer/.android", "/opt/android-sdk"]

EXPOSE 5555 8080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
