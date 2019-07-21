#!/usr/bin/env sh

CWD=$(pwd)
TAG=0.2.2

set -xe

#--------------------------------------------------------------------------------------------------
#
#--------------------------------------------------------------------------------------------------

before_all () {
  cd "${CWD}"/
  rm -rf flatpak-builder-tools/ open-drive/ generated-sources.json yarn.lock
  git clone https://github.com/flatpak/flatpak-builder-tools.git ./flatpak-builder-tools/
  git clone https://github.com/liberodark/ODrive.git ./open-drive/
}

#--------------------------------------------------------------------------------------------------
#
#--------------------------------------------------------------------------------------------------

open_drive () {
  cd "${CWD}"/open-drive/
  cp "${CWD}"/flatpak-builder-tools/yarn/flatpak-yarn-generator.py ./
  git checkout "${TAG}"
  rm -f package-lock.json # ...because Yarn complains about different packaging tools and what not
  yarn install
  yarn check --integrity
  yarn check --verify-tree
  python3 flatpak-yarn-generator.py yarn.lock -o "${CWD}"/generated-sources.json --recursive
  cp yarn.lock "${CWD}"/
}

#--------------------------------------------------------------------------------------------------
#
#--------------------------------------------------------------------------------------------------

before_all
open_drive

unset PWD TAG
