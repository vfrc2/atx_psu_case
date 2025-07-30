FROM debian:bookworm-slim 

LABEL org.opencontainers.image.source=https://github.com/vfrc2/atx_psu_case
LABEL org.opencontainers.image.description="Openscad Build container"
LABEL org.opencontainers.image.licenses=MIT

RUN apt-get update

RUN apt-get -y full-upgrade

RUN apt-get install -y --no-install-recommends \
	libcairo2 libdouble-conversion3 libxml2 lib3mf1 libzip4 libharfbuzz0b \
	libboost-thread1.74.0 libboost-program-options1.74.0 libboost-filesystem1.74.0 \
	libboost-regex1.74.0 libmpfr6 libqscintilla2-qt5-15 \
	libqt5multimedia5 libqt5concurrent5 libtbb12 libglu1-mesa \
	libglew2.2 xvfb xauth

RUN apt-get install -y --no-install-recommends make curl unzip jq ca-certificates

RUN apt-get install -y --no-install-recommends openscad

RUN apt-get clean

WORKDIR /tmp

RUN curl -L -o BOSL2.zip https://github.com/BelfrySCAD/BOSL2/archive/refs/heads/master.zip
RUN unzip *.zip

RUN mkdir -p /usr/share/openscad/libraries/
RUN mv BOSL2-master /usr/share/openscad/libraries/BOSL2

ENV OPENSCAD="xvfb-run -a openscad"
WORKDIR /src
