#!/usr/bin/env bash
set -euo pipefail

WIKI_VERSION="${1:-v2.5.314}"
WIKI_COMMIT="${WIKI_COMMIT:-6f042e97cc2d3acda6b6ff611de8e0faacce91c1}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DESTINATION="${2:-${REPO_ROOT}/.build/wikijs}"
PATCH_PATH="${REPO_ROOT}/patches/wikijs-2.5.x-navigation.patch"

test -f "${PATCH_PATH}"

if [[ ! -d "${DESTINATION}/.git" ]]; then
  mkdir -p "$(dirname "${DESTINATION}")"
  git clone --depth 1 --branch "${WIKI_VERSION}" https://github.com/Requarks/wiki.git "${DESTINATION}"
fi

git -C "${DESTINATION}" apply --check "${PATCH_PATH}"
git -C "${DESTINATION}" apply "${PATCH_PATH}"
ACTUAL_COMMIT="$(git -C "${DESTINATION}" rev-parse HEAD)"
if [[ -n "${WIKI_COMMIT}" && "${ACTUAL_COMMIT}" != "${WIKI_COMMIT}" ]]; then
  echo "Wiki.js ${WIKI_VERSION} resolved to ${ACTUAL_COMMIT}, expected pinned commit ${WIKI_COMMIT}." >&2
  exit 1
fi
echo "Prepared Wiki.js ${WIKI_VERSION} (${ACTUAL_COMMIT}) at ${DESTINATION}"
