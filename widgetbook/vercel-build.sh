#!/usr/bin/env bash
# Installs a pinned Flutter SDK on the Vercel build image and builds the
# web release. Run with the Vercel "Root Directory" set to `widgetbook` so
# this script's relative paths (../packages/design_system) resolve correctly.
set -euo pipefail

FLUTTER_VERSION="3.44.6"
FLUTTER_CHANNEL="stable"
FLUTTER_HOME="${HOME}/flutter-sdk"
FLUTTER_ARCHIVE="flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/${FLUTTER_ARCHIVE}"

if [ ! -x "${FLUTTER_HOME}/flutter/bin/flutter" ]; then
  echo "Downloading Flutter ${FLUTTER_VERSION} (${FLUTTER_CHANNEL})..."
  mkdir -p "${FLUTTER_HOME}"
  curl -sSL "${FLUTTER_URL}" -o "/tmp/${FLUTTER_ARCHIVE}"
  tar -xf "/tmp/${FLUTTER_ARCHIVE}" -C "${FLUTTER_HOME}"
  rm "/tmp/${FLUTTER_ARCHIVE}"
else
  echo "Using cached Flutter SDK at ${FLUTTER_HOME}/flutter"
fi

# Vercel's build image runs as a different user than the one that owns
# this checkout, so git refuses to operate on the extracted SDK ("detected
# dubious ownership") until it's explicitly marked safe.
git config --global --add safe.directory "${FLUTTER_HOME}/flutter"

export PATH="${FLUTTER_HOME}/flutter/bin:${PATH}"
export CI=true

flutter config --enable-web --no-analytics
flutter pub get
flutter build web --release
