#!/bin/sh

# Manually fetch and edit lwk repository

REPO=https://github.com/Blockstream/lwk
TAG=bindings_0.9.0

rm -rf rust_modules
mkdir -p rust_modules
cd rust_modules

git clone $REPO
cd lwk
git checkout $TAG
cd ..

mv -f lwk/lwk_bindings .

if [[ "$OSTYPE" == "darwin"* ]]; then
   sed -i '' 's/name = "lwk_bindings"/name = "lwk"/g' lwk_bindings/Cargo.toml
else
   sed -i 's/name = "lwk_bindings"/name = "lwk"/g' lwk_bindings/Cargo.toml
fi

