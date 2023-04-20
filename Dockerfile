FROM debian:11 AS builder

MAINTAINER zocker-160

ENV DEBIAN_FRONTEND noninteractive

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


##########################################################################################

## Pull base image
FROM jlesage/baseimage-gui:debian-11

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
ENV DEBIAN_FRONTEND noninteractive

ENV AUTOMATED_CONVERSION_PRESET="Very Fast 1080p30"
ENV AUTOMATED_CONVERSION_FORMAT="mp4"

## URLs
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
