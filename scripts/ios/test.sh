#!/usr/bin/env bash

set -e
set -o pipefail
set -u

xctool \
    -project ./test/ios/ios-tests.xcodeproj \
    -scheme 'Mapbox GL Tests' \
    -sdk iphonesimulator8.3 \
    -destination 'platform=iOS Simulator,name=iPhone 5s (7.1 Simulator)'
    test
