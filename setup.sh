#!/bin/sh

apk update

docker ps > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    apk add docker
    rc-service docker start
fi

if [[ ! -d build ]]; then mkdir build; fi

cat > build-script.sh << EOF
ln -s /makeself/makeself.sh /usr/local/bin/makeself
ln -s /makeself/makeself-header.sh /usr/local/bin/makeself-header.sh

if [[ ! -d wxbuild ]]; then make NOGUI=1 WXSTATIC=1 WX_ROOT=/wxWidgets wxbuild; fi
make NOGUI=1 WXSTATIC=1 WX_ROOT=/wxWidgets
make NOGUI=1 WXSTATIC=1 WX_ROOT=/wxWidgets package

cp /VeraCrypt/src/Setup/Linux/veracrypt-*-setup-console-x64 /build
EOF

cat > Dockerfile << EOF
FROM alpine as builder

WORKDIR /
RUN apk update && apk add grep tar git fuse-dev build-base yasm pkgconf pcsc-lite-dev gtk+3.0-dev

FROM builder as wx
RUN git clone --depth 1 --branch v3.2.2.1 https://github.com/wxWidgets/wxWidgets.git
RUN cd /wxWidgets && git submodule update --init 3rdparty/catch

FROM builder as vera
RUN git clone --depth 1 --single-branch https://github.com/veracrypt/VeraCrypt.git

FROM builder as makeself
RUN git clone --depth 1 --single-branch https://github.com/megastep/makeself.git
RUN cd makeself && git submodule update --init --recursive && ./make-release.sh

FROM builder
COPY --from=wx /wxWidgets /wxWidgets
COPY --from=vera /VeraCrypt /VeraCrypt
COPY --from=makeself /makeself /makeself

WORKDIR /VeraCrypt/src

CMD sh /build-script.sh
EOF
docker build -t vera-builder .
docker run --rm -v `pwd`/build:/build -v `pwd`/build-script.sh:/build-script.sh vera-builder
docker rmi vera-builder
rm ./build-vera.sh
rm ./Dockerfile
