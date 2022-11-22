
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive



ENV USER="anselmo"
ENV JAVA_VERSION="8"
ENV ANDROID_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip"
ENV ANDROID_VERSION="29"
ENV ANDROID_BUILD_TOOLS_VERSION="29.0.3"
ENV ANDROID_ARCHITECTURE="x86_64"
ENV ANDROID_SDK_ROOT="/home/$USER/android"
ENV FLUTTER_CHANNEL="stable"
ENV FLUTTER_VERSION="3.3.7"
ENV FLUTTER_URL="https://storage.googleapis.com/flutter_infra/releases/$FLUTTER_CHANNEL/linux/flutter_linux_$FLUTTER_VERSION-$FLUTTER_CHANNEL.tar.xz"
ENV FLUTTER_HOME="/home/$USER/flutter"
ENV FLUTTER_WEB_PORT="8090"
ENV FLUTTER_DEBUG_PORT="42000"
ENV FLUTTER_EMULATOR_NAME="flutter_emulator"
ENV PATH="$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/platforms:$FLUTTER_HOME/bin:$PATH"



RUN apt-get update 


RUN  apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget



RUN useradd -ms /bin/bash anselmo

USER anselmo

WORKDIR /home/anselmo



# set up android sdk 

RUN mkdir -p $ANDROID_SDK_ROOT \
  && mkdir -p /home/$USER/.android \
  && touch /home/$USER/.android/repositories.cfg \
  && curl -o android_tools.zip $ANDROID_TOOLS_URL \
  && unzip -qq -d "$ANDROID_SDK_ROOT" android_tools.zip \
  && rm android_tools.zip \
  && mkdir -p $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && mv $ANDROID_SDK_ROOT/cmdline-tools/bin $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && mv $ANDROID_SDK_ROOT/cmdline-tools/lib $ANDROID_SDK_ROOT/cmdline-tools/tools \
  && yes "y" | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
  && yes "y" | sdkmanager "platforms;android-$ANDROID_VERSION" \
  && yes "y" | sdkmanager "platform-tools" 
  #&& yes "y" | sdkmanager "emulator" \
  #&& yes "y" | sdkmanager "system-images;android-$ANDROID_VERSION;google_apis_playstore;$ANDROID_ARCHITECTURE"
#set up flutter sdk 
RUN curl -o flutter.tar.xz $FLUTTER_URL \
  && mkdir -p $FLUTTER_HOME \
  && tar xf flutter.tar.xz -C /home/$USER \
  && rm flutter.tar.xz \
  && flutter config --no-analytics --enable-web \
  && flutter precache \
  && yes "y" | flutter doctor --android-licenses \
  && flutter doctor \
  #&& flutter emulators --create \
  && flutter update-packages

  