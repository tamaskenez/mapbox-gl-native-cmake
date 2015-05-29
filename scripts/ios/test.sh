#!/usr/bin/env bash

set -e
set -o pipefail
set -u

xcodebuild \
    -project ./test/ios/ios-tests.xcodeproj \
    -scheme 'Mapbox GL Tests' \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 5s,OS=7.1' \
    test
