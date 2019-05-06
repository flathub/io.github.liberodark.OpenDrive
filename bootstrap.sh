#!/usr/bin/env sh

TAG=0.2.2

set -xe

rm -rf flatpak-builder-tools/ open-drive/
git clone https://github.com/flatpak/flatpak-builder-tools.git ./flatpak-builder-tools/
git clone https://github.com/liberodark/ODrive.git ./open-drive/

cd open-drive/
git checkout "${TAG}"

cp ../flatpak-builder-tools/yarn/flatpak-yarn-generator.py ./
sed -i '/"x64": "x86_64"/a \    \"arm64": "arm64",' flatpak-yarn-generator.py
sed -i 's/"arm": "arm"/"armv7l": "armv7l"/g' flatpak-yarn-generator.py
rm -f package-lock.json   # ...because yarn complains about different packaging tools and what not
yarn install
yarn check --integrity
yarn check --verify-tree
cp yarn.lock ../
python3 flatpak-yarn-generator.py yarn.lock -o ../generated-sources.json

unset TAG
