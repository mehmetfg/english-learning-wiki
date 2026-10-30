#!/bin/bash
# Mac'te bir kez çalıştır: motoru ve dfki sesini indirir, Xcode projesini üretir.
set -euo pipefail
cd "$(dirname "$0")"

SHERPA_VERSION=1.12.40
RELEASES=https://github.com/k2-fsa/sherpa-onnx/releases/download
TMP=$(mktemp -d)

command -v xcodegen >/dev/null || brew install xcodegen
mkdir -p Frameworks Resources

if [ ! -d Frameworks/sherpa-onnx.xcframework ]; then
  echo "→ sherpa-onnx iOS motoru indiriliyor"
  curl -fL -o "$TMP/ios.tar.bz2" "$RELEASES/v$SHERPA_VERSION/sherpa-onnx-v$SHERPA_VERSION-ios.tar.bz2"
  tar xjf "$TMP/ios.tar.bz2" -C "$TMP"
  cp -R "$TMP/build-ios/sherpa-onnx.xcframework" Frameworks/
  cp -RL "$TMP/build-ios/ios-onnxruntime/onnxruntime.xcframework" Frameworks/
fi

if [ ! -f Resources/tr_TR-dfki-medium.onnx ]; then
  echo "→ dfki Türkçe erkek sesi indiriliyor (~60 MB)"
  curl -fL -o "$TMP/dfki.tar.bz2" "$RELEASES/tts-models/vits-piper-tr_TR-dfki-medium.tar.bz2"
  tar xjf "$TMP/dfki.tar.bz2" -C "$TMP"
  cp "$TMP/vits-piper-tr_TR-dfki-medium/tr_TR-dfki-medium.onnx" "$TMP/vits-piper-tr_TR-dfki-medium/tokens.txt" Resources/
  cp -R "$TMP/vits-piper-tr_TR-dfki-medium/espeak-ng-data" Resources/
fi

curl -fL -o Extension/SherpaOnnx.swift \
  "https://raw.githubusercontent.com/k2-fsa/sherpa-onnx/v$SHERPA_VERSION/swift-api-examples/SherpaOnnx.swift"

rm -rf "$TMP"
xcodegen generate
echo "✓ Hazır. StabilSes.xcodeproj açılıyor."
open StabilSes.xcodeproj
