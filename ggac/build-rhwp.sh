#!/bin/sh
# rhwp-studio(edwardkim/rhwp v0.8.7, MIT) 를 /rhwp/ 로 빌드한다 — ggac docs/board-work/01-설계.md §8-1.
# WASM 은 같은 버전의 @rhwp/core npm 패키지(wasm-pack 결과물)를 ../pkg 로 풀어 쓴다(Rust 빌드 불필요).
# 외부 웹폰트(함초롬 CDN, 비상업 조건)·HwpCtrl 호환 계층은 끈다.
set -e
RHWP_VERSION=0.8.7
ROOT=$(pwd)
cd vendor/rhwp
rm -rf pkg && mkdir -p pkg
curl -sSfL "https://registry.npmjs.org/@rhwp/core/-/core-${RHWP_VERSION}.tgz" | tar -xz -C pkg --strip-components=1
cd rhwp-studio
npm ci --ignore-scripts --no-audit --no-fund
RHWP_DISABLE_EXTERNAL_WEBFONTS=1 RHWP_WITHOUT_HWPCTRL=1 npx tsc
RHWP_DISABLE_EXTERNAL_WEBFONTS=1 RHWP_WITHOUT_HWPCTRL=1 npx vite build --base=/rhwp/ --outDir "$ROOT/dist/rhwp" --emptyOutDir
echo "rhwp-studio ${RHWP_VERSION} -> dist/rhwp"
