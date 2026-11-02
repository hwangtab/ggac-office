# ggac-office — 경기아트콜렉티브 이사회 업무툴 문서 편집기

- 출처: 한국스마트협동조합 `hwangtab/kosmart-office` 브랜치 `kosmart`(커밋 `1b84cde`)를 가져와 브랜치 `ggac`로 갈랐다.
  그 안의 편집기 소스는 원본 https://github.com/ranuts/document 태그 `v0.0.8`(커밋 325ffd37, AGPL-3.0) 그대로다.
  **편집기 소스는 고치지 않았다.** 소스 제공(AGPL §13)은 원본 태그 링크로 한다.
- 더한 파일(운영 설정만):
  - `vercel.json` — Vercel 정적 빌드·보안 헤더. CSP `connect-src 'self'`로 편집 중 문서가 외부로 나가지 못하게 하고,
    `frame-ancestors`로 ggac(https://ggac.kr · https://www.ggac.kr)와 로컬 개발(3000)·E2E(3101)만(localhost·127.0.0.1 둘 다 — Playwright는 127.0.0.1로 연다) 이 편집기를 넣을 수 있게 한다.
    `'self'`는 ONLYOFFICE 내부 iframe 때문에 빠지면 안 된다(조상 전체를 검사한다).
  - `public/purge.html` — `Clear-Site-Data`로 업무툴 로그아웃 때 이 편집기의 브라우저 저장소를 지운다.
- 배포 주소: 별도 Vercel 프로젝트의 `*.vercel.app` 주소. **ggac.kr 하위 도메인으로 옮기지 않는다** —
  `vercel.app`은 공용 접미사 목록(PSL)에 있어 ggac 로그인 쿠키가 편집기 출처에 닿지 않는다.
- 업데이트(분기 1회 또는 ONLYOFFICE 보안 공지 시): 새 태그를 받아 이 운영 파일만 다시 얹고 배포, ggac `docs/board-work/01-설계.md` §8-1에 기록.
- 연동 정본: ggac `docs/board-work/01-설계.md` §8-1.

## rhwp-studio (HWP 편집, /rhwp/)

- 원본: https://github.com/edwardkim/rhwp 태그 `v0.8.7`, MIT — `vendor/rhwp/rhwp-studio`(e2e·tests·샘플 제외 무수정) + `vendor/rhwp/LICENSE`.
- WASM: 같은 버전 npm `@rhwp/core`를 빌드 때 `vendor/rhwp/pkg`로 풀어 쓴다(`ggac/build-rhwp.sh`).
- 빌드 스위치: `RHWP_DISABLE_EXTERNAL_WEBFONTS=1`(함초롬 CDN 비상업 조건), `RHWP_WITHOUT_HWPCTRL=1`.
