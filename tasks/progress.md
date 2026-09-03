# 작업 기록 (progress)

> 이 파일은 **추가만** 합니다 (append-only). 이미 적은 내용은 지우거나 고치지 않습니다.
> 작업이 끝날 때마다 아래에 날짜와 함께 한 일을 요약해서 적습니다.
> 형식: 무엇을 / 왜 / 결과(확인됨 여부)

---

## 2026-09-02

### 작업 환경 구축
- **무엇을:** `tasks/` 폴더와 `todo.md`, `progress.md` 생성. `SECURITY.md`(키 노출 비상 매뉴얼),
  `README.md`(폴더 안내), `.env.example`(키 견본), `.gitignore`(키 파일 제외) 작성.
- **왜:** CLAUDE.md에서 정한 작업 환경 구조를 실제 파일로 갖추기 위해.
- **결과:** 확인됨. 6개 파일 생성 완료. 실제 `.env`는 사용자가 직접 만들 예정.

### 다운로드 폴더 정리
- **무엇을:** `C:\Users\Hoon's Desktop\Downloads` 의 최상위 파일 133개 + 폴더 7개를 유형별로 이동.
  - `images/` ← png 6
  - `docs/` ← pdf 68, hwp 25, xlsx 10, pptx 3, docx 2, hwpx 1 (계 109)
  - `misc/` ← zip 9, exe 5, html 4, 하위폴더 7 (계 25)
  - `desktop.ini` 는 윈도우 시스템 파일이라 이동하지 않음.
- **왜:** 사용자 요청. 다운로드 폴더가 141개 항목으로 뒤섞여 있었음.
- **결과:** 확인됨. `mv -n`(덮어쓰기 금지)으로 이동, 건너뛴 파일 0개, 유실 0개.
  최상위에는 `docs/ images/ misc/ desktop.ini` 만 남음. 되돌리려면 하위 폴더에서 파일을 다시 꺼내면 됨.

### 강남구 날씨·미세먼지 자동 수집 스크립트
- **무엇을:** `scripts/weather.ps1` (Open-Meteo 무료 API로 강남구 날씨+PM10/PM2.5 조회 → `weather.txt` 누적 저장),
  `scripts/register-weather-task.ps1` (작업 스케줄러 매일 09:00 등록), `scripts/unregister-weather-task.ps1` (해제) 작성.
  세 파일 모두 UTF-8 BOM으로 저장 (PowerShell 5.1 한글 파싱용).
- **왜:** 사용자 요청. API 키 없이 매일 아침 자동으로 날씨·미세먼지를 파일에 남기고 싶어 함.
- **결과:** weather.ps1 실행 확인됨 — weather.txt에 정상 기록됨. 스케줄러 등록(register 스크립트)은
  시스템 변경이라 사용자 승인 대기 중. 미세먼지 등급은 한국 환경부 기준(PM10 30/80/150, PM2.5 15/35/75).

### 포트폴리오 웹페이지
- **무엇을:** `portfolio/index.html` 1파일로 반응형 포트폴리오 제작. 내용은 docs/resume.pdf에서 추출
  (김수민 / Marketing Specialist / 경력 2건 + 예시 1건 / 성과 지표 4개 / 연락처). Artifact로 게시.
  게시 URL: https://claude.ai/code/artifact/d538bdd1-437b-4e8d-b844-13e992e14754
- **왜:** 사용자 요청. 브라우저에서 바로 볼 수 있는 포트폴리오 페이지 필요.
- **결과:** 게시 완료. 주의 - resume.pdf는 샘플 데이터로 보임(example.com 이메일, 인프런 워터마크).
  CLAUDE.md의 이름("기획자")·직업("안전관리자")과 resume.pdf 내용이 불일치 → 사용자 확인 필요.
  연락처와 3번째 경력은 샘플/임의값이라 페이지에 "예시" 표시하고 안내문 넣음.
- **수정(동일 URL 재게시):** 사용자 요청으로 정체성을 "이태훈 / 안전관리자"로 변경.
  마케팅 내용 전체를 산업안전보건 도메인으로 재작성(위험성평가·PTW·중대재해처벌법·KOSHA-MS 등),
  성과 지표 4개·경력 3건 모두 예시로 채우고 "예시 항목" 태그 + 안내문 명시. 액센트 색을 안전녹색(녹십자)으로 조정.
  실제 이력·연락처·수치는 사용자가 교체 필요.

### claude-workspace GitHub 업로드
- **무엇을:** 이 폴더를 GitHub private 레포(`22thleee/claude-workspace`)로 올림.
  `.gitignore` 에 `weather.txt`·`docs/resume.pdf`·`docs/sales.csv` 추가, `README.md` 를 전체 폴더 구조
  기준으로 새로 작성(기존본 `README.md.bak` 백업). `git init`(main) → 커밋 "Initial setup" → `gh repo create --private --push`.
  git 사용자 정보는 이 레포에만 로컬 설정(22thleee / 22thleee@gmail.com).
- **왜:** 사용자 요청. 작업 공간을 private 저장소로 백업/버전관리.
- **결과:** 확인됨. https://github.com/22thleee/claude-workspace (PRIVATE). 커밋 1개(11개 파일).
  원격 트리 재검증 — resume.pdf / sales.csv / weather.txt / *.bak / .env 계열 없음.
  제외한 파일들은 로컬에는 그대로 있음(git 추적만 제외).

### 포트폴리오 기본 테마를 다크모드로
- **무엇을:** 브랜치 `portfolio-dark-mode` 에서 `portfolio/index.html` 의 `:root` 기본 팔레트를
  라이트 → 다크로 교체. 라이트는 이제 `@media (prefers-color-scheme: light)` +
  `:root[data-theme="light"]` 일 때만 적용. 테마 토글 JS 폴백도 새 기본값(다크)에 맞게 수정
  (라이트 OS에서 첫 클릭 무반응 방지). 색값은 파일에 원래 있던 다크 팔레트 재사용.
- **왜:** 사용자 요청 — 포트폴리오 기본 배경을 어둡게.
- **결과:** 사용자가 브라우저로 확인 후 승인. `main` 에 `--no-ff` 머지(e3899ab) 후
  GitHub 푸시 완료(db40111..e3899ab). 로컬 브랜치는 남겨둠.

---

## 2026-09-03

### 포트폴리오 Vercel 배포 세팅
- **무엇을:** `portfolio/index.html` 을 배포 가능한 온전한 HTML 문서로 보강.
  수정 전 `index.html.bak` 백업. 앞부분에 `<!DOCTYPE html>` + `<html lang="ko">` /
  `<head>`(charset, viewport, description, author, color-scheme, favicon 링크,
  Open Graph 4종, twitter:card) / `<body>` 래퍼만 추가 — 기존 `<style>`·본문·`<script>` 는
  한 글자도 안 건드림. 새 파일 4개: `favicon.svg`(안전녹색 방패+체크),
  `vercel.json`(cleanUrls + X-Content-Type-Options·X-Frame-Options·Referrer-Policy·
  Permissions-Policy 헤더), `robots.txt`(전체 허용), `README.md`(Vercel 웹 배포
  단계별 안내 — 핵심은 Import 시 Root Directory 를 `portfolio` 로 지정). `.gitignore` 에 `.vercel/` 추가.
- **왜:** 사용자 요청. 포트폴리오를 Vercel 로 배포 가능한 상태로 세팅 (배포 실행은 사용자가 직접).
- **결과:** 확인됨 — HTML 태그 균형(html/head/body/style/script/header/main/footer 각 1:1),
  `vercel.json` JSON 파싱 OK, `favicon.svg` XML 파싱 OK. 정적 사이트라 빌드 과정 없음.
  커밋 후 `git push origin main` 완료. 배포는 vercel.com 에서 저장소 Import →
  Root Directory `portfolio` → Deploy (README 에 절차 명시).
- **남은 일(코드 아님):** `index.html` 의 연락처(example.com 이메일, 010-0000-0000),
  성과 지표 4개, 경력 3건이 아직 예시값. 실제 정보로 교체 필요 — README 에도 체크리스트로 적어둠.

### 포트폴리오 배경색 검정 → 보라색
- **무엇을:** `portfolio/index.html` 의 기본(다크) 팔레트에서 `--ground`(#10140f→#1a1030),
  `--surface`, `--line`, `--tag-bg`, `--ink` 계열을 보라색 톤으로 교체. 안전녹색 액센트
  (`--accent`/`--accent-2`)는 유지. 라이트 테마는 안 건드림.
- **왜:** 사용자 요청 — 배경을 검정에서 보라색으로.
- **결과:** 확인됨 — 로컬 http 서버(127.0.0.1:8765)로 띄워 Chrome 스크린샷으로 검증.
  다크 테마에서 딥 퍼플 배경 + 녹색 액센트 정상 렌더, 태그/구분선/본문 대비 양호.
  커밋 f5e018c → `git push origin main` (1bceaed..f5e018c).

### 포트폴리오 방명록(Supabase) 기능 추가
- **무엇을:** 정적 사이트에 Supabase `messages` 테이블 기반 방명록 추가.
  - `portfolio/supabase/messages.sql` — 테이블(id, name, content, created_at) + RLS
    (SELECT/INSERT 누구나, UPDATE/DELETE 정책 없음, 컬럼 권한으로 name·content 만 insert).
  - `.env.local`(repo 루트, git 제외) — `SUPABASE_URL`, `SUPABASE_ANON_KEY`.
  - `scripts/gen-config.mjs` — `.env.local`(또는 process.env) → `portfolio/config.js` 생성.
    스크립트 위치 기준 경로라 실행 위치 무관.
  - `portfolio/config.example.js`(git 포함) / `portfolio/config.js`(git 제외).
  - `.gitignore` 에 `portfolio/config.js` 추가 (`.env.local` 은 기존 `.env.*` 로 이미 제외).
  - `portfolio/index.html` — 연락처 다음에 `<section id="guestbook">`(폼 + 목록), 헤더에
    `<script src="config.js">`, nav 에 "방명록" 링크, `<style>` 에 `.gb-*` 규칙,
    맨 아래에 방명록 스크립트. Supabase REST 를 라이브러리 없이 `fetch` 로 호출
    (GET select order=created_at.desc limit 100 / POST Prefer:return=representation).
    사용자 입력은 `textContent` 로만 렌더 → XSS 방지. 설정 없음/테이블 없음/네트워크
    오류 각각 안내 문구.
  - `portfolio/README.md` — 방명록 세팅 + 로컬 테스트 순서, 배포 시 config.js 넣는 2가지 방법.
- **왜:** 사용자 요청 — 포트폴리오에 방명록(폼+리스트), 환경변수는 .env.local, 로컬 테스트 준비.
- **결과:** 부분 확인됨. 로컬(127.0.0.1:8766) + Chrome 으로 검증:
  방명록 섹션 렌더 OK, nav "방명록" 링크 OK, config.js 로드 OK, Supabase REST 호출 도달 OK
  (CORS/인증 통과), 빈 폼 클라이언트 검증 OK, 라이트/다크(퍼플) 양쪽 스타일 OK,
  콘솔에 문법오류 없음. **테이블 미생성 상태라 글 작성 왕복은 미검증** —
  사용자가 `portfolio/supabase/messages.sql` 을 Supabase SQL Editor 에서 실행해야 함
  (anon 키로는 DDL 불가). 실행 후 왕복 테스트 예정.
  커밋/푸시 완료. `.env.local`·`config.js` 는 커밋 안 됨(스테이징 검사로 확인).

### 방명록 — 로컬 왕복 테스트 + Vercel 배포 설정
- **무엇을(테스트):** 사용자가 `messages.sql` 실행 완료. 개발 서버(127.0.0.1:8000) 띄우고
  Chrome 으로 글 작성 → "남겼습니다" + 목록 즉시 표시 확인. REST 직접 조회로 DB 에 `id:1`
  행 저장 확인(UTC 저장→KST 표시). anon DELETE 는 `42501 permission denied`(정책대로 차단).
- **무엇을(배포 설정):**
  - `portfolio/vercel.json` 에 `"buildCommand": "node ../scripts/gen-config.mjs"`,
    `"outputDirectory": "."` 추가 → 배포 때마다 Vercel 환경변수로 `config.js` 자동 생성.
  - `scripts/gen-config.mjs` — 환경변수 없을 때: 로컬은 exit 1(기존), Vercel(`process.env.VERCEL`)
    은 경고만 하고 빈 config.js 로 exit 0 (배포 실패 방지, 방명록만 비활성).
  - `.env.example` 에 `SUPABASE_URL` / `SUPABASE_ANON_KEY` 항목 추가(견본).
  - `portfolio/README.md` 배포 절차 갱신 — 대시보드에서 Root Directory + 환경변수 2개만.
- **왜:** 사용자 요청 — 방명록 동작 확인 + 배포 설정 완료. 키는 git 에 안 올리는 방식 유지.
- **결과:** 확인됨. gen-config 3가지 경로(로컬 .env.local / Vercel+env / Vercel-env없음) 테스트 통과.
  vercel.json JSON 유효, 개발 서버 정상. git status 에 config.js·.env.local 없음.
  커밋/푸시 완료. **사용자 배포 시 할 일:** Vercel 프로젝트에 SUPABASE_URL·SUPABASE_ANON_KEY
  환경변수 등록 + Root Directory=portfolio. (테이블은 이미 생성됨)
  **남은 것:** DB `id:1` 테스트 행 — 사용자가 Supabase Table Editor 에서 삭제.

### 방명록 배포 — 404 재발 → vercel.json 되돌리고 config.js 커밋
- **무엇을:** 직전 커밋(924fe2e)의 `vercel.json` `buildCommand: node ../scripts/gen-config.mjs`
  + `outputDirectory: "."` 때문에 Vercel 배포가 404. 원인: `scripts/` 가 Root Directory
  (`portfolio`) 밖이라 빌드에 포함 안 됨 → 빌드 실패 → 빈 배포.
  → `vercel.json` 을 순수 정적(빌드 명령 없음)으로 되돌림(1e14d90).
  → 사용자 선택으로 `portfolio/config.js` 를 **커밋**하기로 결정.
     `.gitignore` 에서 `portfolio/config.js` 제거, `gen-config.mjs` 의 Vercel 분기 삭제
     (배너 문구도 "재생성 후 커밋" 으로), `.env.example`·`README.md` 를 커밋 방식으로 갱신.
- **왜:** 404 를 두 번 겪어 확실한 방법 필요. anon key 는 공개 키(RLS 로 보호) + private 레포라
  커밋해도 실질 위험 낮음. `.env.local`(원본)은 계속 git 제외, 생성물 config.js 만 커밋.
- **결과:** 확인됨 — `vercel.json`/`config.js` 유효, 개발 서버 정상, `.env.local` 미스테이징.
  커밋/푸시. **사용자 배포:** Vercel 에서 Root Directory=`portfolio` 만 지정하고 Deploy
  (Build/Output 은 비워둠). 이제 환경변수 설정 불필요.
