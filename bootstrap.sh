#!/usr/bin/env sh

TAG=0.2.2

set -xe

rm -rf flatpak-builder-tools/ open-drive/
git clone https://github.com/flatpak/flatpak-builder-tools.git ./flatpak-builder-tools/
git clone https://github.com/liberodark/ODrive.git ./open-drive/

cd open-drive/
git checkout "${TAG}"

cp ../flatpak-builder-tools/yarn/flatpak-yarn-generator.py ./
# In the meantime, electron_arches must be modified to match:
#
#electron_arches = {
#    "ia32": "i386",
#    "x64": "x86_64",
#    "armv7l": "armv7l",
#    "arm64": "arm64"
#}
# ...since "arm": "arm" is not a thing anymore
rm -f package-lock.json   # ...because yarn complains about different packaging tools and what not
yarn install
yarn check --integrity
yarn check --verify-tree
cp yarn.lock ../
python3 flatpak-yarn-generator.py yarn.lock -o ../generated-sources.json

unset TAG
