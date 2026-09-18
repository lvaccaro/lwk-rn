#!/bin/sh
set -eu

# Fetch lwk_bindings from Blockstream/lwk.
#
# Git tags can be moved, so the pinned commit is the source of truth.
# bindings_0.18.0 is an annotated tag that currently peels to this commit;
# if the tag is retargeted, this script fails instead of building unknown code.
REPO=https://github.com/Blockstream/lwk.git
TAG=bindings_0.18.0
COMMIT=d3965875154c190ed7a0fb6e741f508c752da894

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$ROOT"

command -v git >/dev/null 2>&1 || {
  echo "error: git is required" >&2
  exit 1
}

rm -rf rust_modules
mkdir -p rust_modules
cd rust_modules

GIT_TERMINAL_PROMPT=0
export GIT_TERMINAL_PROMPT

git init lwk
cd lwk
# Do not run hooks from the fetched repository.
git config core.hooksPath /dev/null
git remote add origin "$REPO"
# Fetch the annotated tag object (needed to resolve TAG -> commit).
git fetch --depth 1 origin "refs/tags/${TAG}:refs/tags/${TAG}"

tag_commit=$(git rev-list -n 1 "$TAG")
if [ "$tag_commit" != "$COMMIT" ]; then
  echo "error: tag ${TAG} points to ${tag_commit}, expected ${COMMIT}" >&2
  echo "error: refusing to build from a moved or unexpected upstream tag" >&2
  exit 1
fi

git checkout --force --detach "$COMMIT"

head_commit=$(git rev-parse HEAD)
if [ "$head_commit" != "$COMMIT" ]; then
  echo "error: checked out ${head_commit}, expected ${COMMIT}" >&2
  exit 1
fi

cd ..
mv -f lwk/lwk_bindings .

case "$(uname -s)" in
  Darwin)
    sed -i '' 's/name = "lwk_bindings"/name = "lwk"/g' lwk_bindings/Cargo.toml
    ;;
  *)
    sed -i 's/name = "lwk_bindings"/name = "lwk"/g' lwk_bindings/Cargo.toml
    ;;
esac

cat << EOF >> lwk_bindings/Cargo.toml
[profile.release-smaller]
inherits = "release"
opt-level = 'z'      # Optimize for size.
lto = true           # Enable Link Time Optimization
codegen-units = 1    # Reduce number of codegen units to increase optimizations.
panic = "abort"      # Abort on panic
strip = true         # Partially strip symbols from binary
EOF
