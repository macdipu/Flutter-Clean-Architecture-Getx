FROM cirrusci/flutter:stable

# Install general dependencies and Android SDK command line tools
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget unzip zip git openssh-client curl ca-certificates procps \
    openjdk-11-jdk-headless libglu1-mesa libgl1-mesa-glx libpulse0 \
 && rm -rf /var/lib/apt/lists/*

ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator

RUN mkdir -p ${ANDROID_SDK_ROOT}

# Command line tools (pin a recent stable archive)
RUN wget -qO /tmp/cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip \
 && unzip /tmp/cmdline-tools.zip -d /tmp/cmdline-tools \
 && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
 && mv /tmp/cmdline-tools/cmdline-tools/* ${ANDROID_SDK_ROOT}/cmdline-tools/latest/ \
 && rm -rf /tmp/cmdline-tools /tmp/cmdline-tools.zip

# Accept licenses and install core sdk components needed for build
RUN yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses || true
RUN sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "platforms;android-33" "build-tools;33.0.2" "emulator" "extras;google;market_apk_downloader" || true

# Create a developer user and set up workspace
RUN useradd -m -s /bin/bash developer || true
WORKDIR /home/developer/app
RUN chown -R developer:developer /home/developer /opt/android-sdk

# Ensure entrypoint
COPY docker/flutter/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER developer
ENV HOME=/home/developer

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# Pre-create pub & gradle cache dirs to be used as volumes for caching
RUN mkdir -p /home/developer/.gradle /home/developer/.pub-cache

# Keep container alive by default so users can exec into it for flutter commands
CMD ["/bin/bash"]
