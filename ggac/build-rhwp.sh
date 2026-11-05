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
# ggac 패치(원본 무수정 원칙의 유일한 예외, GGAC.md "rhwp-studio" 절): 내장(embed) 모드가 숨기는 파일 명령 중 인쇄·PDF 로
# 인쇄는 되살린다. 둘 다 문서를 바꾸지 않는 출력 명령이라 호스트가 모르는 문서 교체가 아니다. 호스트(ggac)는 이 편집기
# iframe 에 allow-popups 를 줘서 인쇄 미리보기 창이 열리게 한다. 빌드 때 사본에만 적용하고, 원본 목록이 바뀌어 패치가
# 맞지 않으면 빌드를 멈춘다(조용히 지나가지 않게).
CHROME_MODE=src/ui/chrome-mode.ts
grep -q "'file:print'," "$CHROME_MODE" || { echo "rhwp 패치 대상이 바뀌었다: file:print 없음" >&2; exit 1; }
grep -q "'file:print-to-pdf'," "$CHROME_MODE" || { echo "rhwp 패치 대상이 바뀌었다: file:print-to-pdf 없음" >&2; exit 1; }
cp "$CHROME_MODE" "$CHROME_MODE.ggac-orig"
trap 'mv -f "$CHROME_MODE.ggac-orig" "$CHROME_MODE"' EXIT
sed -e "/^  'file:print',$/d" -e "/^  'file:print-to-pdf',$/d" "$CHROME_MODE.ggac-orig" > "$CHROME_MODE"
if grep -q "'file:print'," "$CHROME_MODE"; then echo "rhwp 인쇄 패치 실패" >&2; exit 1; fi
npm ci --ignore-scripts --no-audit --no-fund
RHWP_DISABLE_EXTERNAL_WEBFONTS=1 RHWP_WITHOUT_HWPCTRL=1 npx tsc
RHWP_DISABLE_EXTERNAL_WEBFONTS=1 RHWP_WITHOUT_HWPCTRL=1 npx vite build --base=/rhwp/ --outDir "$ROOT/dist/rhwp" --emptyOutDir
echo "rhwp-studio ${RHWP_VERSION} -> dist/rhwp"
