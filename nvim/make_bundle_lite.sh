#!/bin/bash
cp -r bundle bundle_lite
pushd bundle_lite
find . -regex '.*\.so[.0-9]*' -type f -delete
find . -name '*.pyc' -type f -delete
find . -name '*.pyo' -type f -delete
find . -name '.git' -type d -exec rm -rf '{}' \;
find . -name 'build' -type d -exec rm -rf '{}' \;
find . -name 'target' -type d -exec rm -rf '{}' \;
du -h -d 1 .
popd
tar -cJf bundle.tar.xz bundle_lite
rm -rf bundle_lite
