#!/bin/bash
set -e
if [ ! -d flutter ]; then
  git clone https://github.com/flutter/flutter.git --depth 1
  cd flutter
  git fetch --tags
  git checkout 3.35.4
  cd ..
fi
flutter/bin/flutter --version
flutter/bin/flutter config --enable-web
flutter/bin/flutter pub get
flutter/bin/flutter build web --release
