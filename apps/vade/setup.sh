#!/bin/bash
# Kullanım:
#   ./setup.sh            → ücretsiz Apple hesabı (iCloud senkronu yok, veriler cihazda)
#   ./setup.sh --icloud   → ücretli Apple Developer hesabı (iPhone ↔ Mac iCloud senkronu)
set -euo pipefail
cd "$(dirname "$0")"

if ! command -v xcodegen >/dev/null; then
    if ! command -v brew >/dev/null; then
        echo "Homebrew bulunamadı. Önce https://brew.sh adresindeki komutla kur, sonra tekrar çalıştır."
        exit 1
    fi
    echo "XcodeGen kuruluyor…"
    brew install xcodegen
fi

if [[ "${1:-}" == "--icloud" ]]; then
    spec=project.yml
    echo "iCloud senkronlu proje oluşturuluyor."
else
    spec=project-local.yml
    echo "Yerel (iCloud'suz) proje oluşturuluyor. Senkron için: ./setup.sh --icloud"
fi

xcodegen generate --spec "$spec"
open Vade.xcodeproj
