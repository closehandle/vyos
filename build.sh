#!/usr/bin/env bash
[[ "${1}" == '' ]] && exec docker container run \
    --env TZ=Asia/Shanghai \
    --env DEBIAN_FRONTEND=noninteractive \
    --pull always \
    --volume ./build.sh:/usr/bin/build.sh \
    --volume .:/release \
    --network host \
    --privileged \
    --interactive \
    vyos/vyos-build:current \
    build.sh build

git clone https://github.com/vyos/vyos-build --depth 1 --single-branch vyos || exit $?
pushd vyos
make clean || exit $?
./build-vyos-image \
    --architecture amd64 \
    --build-by admin@maxcdn.moe \
    --custom-package qemu-guest-agent \
    generic || exit $?
cp -f build/live-image-amd64.hybrid.iso ../../release
popd

exit 0
