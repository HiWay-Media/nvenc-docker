FROM debian:11 AS builder

MAINTAINER zocker-160

ENV HANDBRAKE_VERSION_TAG 1.6.1
#ENV HANDBRAKE_VERSION_TAG master
ENV HANDBRAKE_VERSION_BRANCH 1.6.x
ENV HANDBRAKE_VERSION_BRANCH master
ENV HANDBRAKE_DEBUG_MODE none

ENV HANDBRAKE_URL https://api.github.com/repos/HandBrake/HandBrake/releases/tags/$HANDBRAKE_VERSION

ENV HANDBRAKE_URL_GIT https://github.com/HandBrake/HandBrake.git
#ENV HANDBRAKE_URL_GIT https://github.com/HiWay-Media/Handbrake.git
ENV DEBIAN_FRONTEND noninteractive


WORKDIR /HB

## Prepare
RUN apt-get update
RUN apt-get install -y \
    curl diffutils file coreutils m4 xz-utils nasm python3 python3-pip appstream

## Build dependencies
RUN apt-get install -y \
    appstream autoconf automake autopoint build-essential cmake git libass-dev libbz2-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev libjansson-dev liblzma-dev libmp3lame-dev libnuma-dev libogg-dev libopus-dev libsamplerate-dev libspeex-dev libtheora-dev libtool libtool-bin libturbojpeg0-dev libvorbis-dev libx264-dev libxml2-dev libvpx-dev m4 make meson nasm ninja-build patch pkg-config python tar zlib1g-dev clang

## Intel CSV dependencies
RUN apt-get install -y libva-dev libdrm-dev

## GTK GUI dependencies
RUN apt-get install -y \ 
    intltool libdbus-glib-1-dev libglib2.0-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgtk-3-dev libgudev-1.0-dev libnotify-dev libwebkit2gtk-4.0-dev

RUN apt-get install -y \ 
    libsrt-openssl-dev



## Install meson from pip
RUN pip3 install -U meson

## Download HandBrake sources
RUN echo "Downloading HandBrake sources..."
RUN git clone $HANDBRAKE_URL_GIT

## Compile HandBrake
WORKDIR /HB/HandBrake

RUN git checkout $HANDBRAKE_VERSION_TAG
RUN cat /HB/HandBrake/contrib/ffmpeg/module.defs 
ADD module.defs /HB/HandBrake/contrib/ffmpeg/module.defs
RUN find / -xdev  -name module.defs -ls
RUN ./scripts/repo-info.sh > version.txt

RUN echo "Compiling HandBrake..."
RUN ./configure --prefix=/usr/local \
                --debug=$HANDBRAKE_DEBUG_MODE \
                --disable-gtk-update-checks \
                --enable-fdk-aac \
                --enable-x265 \
                --enable-numa \
                --enable-qsv \
                --enable-nvenc \
                --enable-nvdec \
                --launch-jobs=$(nproc) \
                --launch

RUN make -j$(nproc) --directory=build install


##########################################################################################

## Pull base image
FROM jlesage/baseimage-gui:debian-11

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
ENV DEBIAN_FRONTEND noninteractive

ENV APP_NAME="HandBrake"
ENV AUTOMATED_CONVERSION_PRESET="Very Fast 1080p30"
ENV AUTOMATED_CONVERSION_FORMAT="mp4"

## URLs
ENV APP_ICON_URL https://raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/handbrake-icon.png

ENV DVDCSS_NAME libdvd-pkg_1.4.3-1-1_all.deb
ENV DVDCSS_URL http://ftp.br.debian.org/debian/pool/contrib/libd/libdvd-pkg/$DVDCSS_NAME

WORKDIR /tmp

## Runtime dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    # For optical drive listing:
    lsscsi \
    # For watchfolder
    bash \
    coreutils \
    yad \
    findutils \
    expect \
    tcl8.6 \
    wget \
    git

## Handbrake dependencies
RUN apt-get install -y \
    libass9 \
    libavcodec-extra58 \
    libavfilter-extra7 \
    libavformat58 \
    libavutil56 \
    libbluray2 \
    libc6 \
    libcairo2 \
    libdvdnav4 \
    libdvdread8 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgstreamer-plugins-base1.0-0 \
    libgstreamer1.0-0 \
    libgtk-3-0 \
    libgudev-1.0-0 \
    libjansson4 \
    libpango-1.0-0 \
    libsamplerate0 \
    libswresample3 \
    libswscale5 \
    libtheora0 \
    libvorbis0a \
    libvorbisenc2 \
    libx264-160 \
    libx265-192 \
    libxml2 \
    libturbojpeg0

## To read encrypted DVDs install libdvdcss
RUN wget $DVDCSS_URL
RUN apt-get install -y ./$DVDCSS_NAME
RUN rm $DVDCSS_NAME

## install scripts and stuff from upstream Handbrake docker image
RUN git config --global http.sslVerify false
RUN git clone https://github.com/jlesage/docker-handbrake.git
RUN cp -r docker-handbrake/rootfs/* /

## Cleanup
RUN rm -rf docker-handbrake
RUN apt-get remove wget git -y && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    apt-get clean -y && \
    apt-get purge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Adjust the openbox config
RUN \
    # Maximize only the main/initial window.
    sed-patch 's/<application type="normal">/<application type="normal" title="HandBrake">/' \
        /etc/xdg/openbox/rc.xml && \
    # Make sure the main window is always in the background.
    sed-patch '/<application type="normal" title="HandBrake">/a \    <layer>below</layer>' \
        /etc/xdg/openbox/rc.xml

## Generate and install favicons
RUN apt-get update
RUN install_app_icon.sh "$APP_ICON_URL"
RUN \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    apt-get clean -y && \
    apt-get purge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy HandBrake from base build image
COPY --from=builder /usr/local /usr
COPY --from=builder /HB/HandBrake/build/contrib/bin/ffmpeg /usr/local/bin/ffmpeg
COPY --from=builder /HB/HandBrake/build/contrib/bin/ffprobe /usr/local/bin/ffprobe


# Define mountable directories
VOLUME ["/config"]
VOLUME ["/storage"]
VOLUME ["/output"]
VOLUME ["/watch"]
