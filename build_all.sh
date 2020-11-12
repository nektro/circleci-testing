#!/bin/sh

set -e

apk add jq grep

for item in $(zig targets | jq --raw-output '.libc[]' | grep gnu$ | grep x86_64)
do
    echo $item
    zig build -Dtarget=$item -Drelease-safe
done
