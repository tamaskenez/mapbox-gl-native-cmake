#!/usr/bin/env bash

set -e
set -o pipefail
set -u

xctool --version

xctool \
    -project ./test/ios/ios-tests.xcodeproj \
    -scheme 'Mapbox GL Tests' \
    -sdk iphonesimulator8.3 \
    -destination 'platform=iOS Simulator,name=iPhone 5s,OS=7.1' \
    test
