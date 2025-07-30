FROM alpine

RUN apk add openscad 

RUN apk add unzip curl xvfb-run jq

WORKDIR /tmp

RUN curl -L -o BOSL2.zip https://github.com/BelfrySCAD/BOSL2/archive/refs/heads/master.zip
RUN unzip *.zip

RUN mv BOSL2-master /usr/share/openscad/libraries/BOSL2

ENV OPENSCAD="xvfb-run -a openscad"

WORKDIR /src
