# TODO

## 포트폴리오 방명록(Supabase) 기능 추가  ⏳ 코드 완료 / 왕복 테스트 대기 (2026-09-03)

- [x] 1. `portfolio/supabase/messages.sql` — messages 테이블 + RLS
- [x] 2. `.env.local`(repo 루트) — SUPABASE_URL / SUPABASE_ANON_KEY (git 제외)
- [x] 3. `portfolio/config.example.js` + 생성되는 `config.js`
- [x] 4. `scripts/gen-config.mjs` — .env.local → config.js
- [x] 5. `.gitignore` 에 `portfolio/config.js` 추가
- [x] 6. `portfolio/index.html` — 방명록 섹션(폼+목록) + nav 링크 + 스타일 + fetch 스크립트
- [x] 7. `portfolio/README.md` 방명록 세팅/로컬 테스트 안내
- [x] 8. 로컬 검증(Chrome): 렌더·설정로드·REST 도달·검증 OK / 커밋·푸시
- [ ] 9. **사용자**: Supabase SQL Editor 에서 `portfolio/supabase/messages.sql` 실행
- [ ] 10. 테이블 생성 후 글 작성 왕복 테스트 (Claude 가 로컬에서 확인)

### 로컬 테스트 방법
```
node scripts/gen-config.mjs
cd portfolio && python -m http.server 8000
# http://localhost:8000  (file:// 직접 열기는 fetch 막혀서 안 됨)
```

## 포트폴리오 Vercel 배포 세팅  ✅ 완료 (2026-09-03)

- [x] 1. `portfolio/index.html` 백업 → `index.html.bak`
- [x] 2. `index.html` 보강 — `<!DOCTYPE html>` + `<html lang="ko">` / `<head>`(charset·viewport·
       description·Open Graph·favicon) / `<body>` 래퍼 추가. 본문·디자인은 그대로.
- [x] 3. `portfolio/favicon.svg` 생성 (안전녹색 방패+체크)
- [x] 4. `portfolio/vercel.json` (cleanUrls + 보안 헤더) · `portfolio/robots.txt` 생성
- [x] 5. `portfolio/README.md` 생성 — Vercel 웹 배포 단계별 안내 (핵심: Root Directory = `portfolio`)
- [x] 6. `.gitignore` 에 `.vercel/` 추가
- [x] 7. 커밋 + `git push origin main`
- [x] 8. `tasks/progress.md` 기록

### 결과
- 정적 사이트라 빌드 없음. 사용자가 Vercel 에서 저장소 Import → Root Directory `portfolio` 지정 → Deploy.
- 배포 자체는 사용자가 직접 진행.
- 남은 일(코드 아님): index.html 안의 연락처·성과지표·경력 3건이 아직 예시값 → 실제 정보로 교체 필요.

## 포트폴리오 기본 배경을 다크모드로  ✅ 완료 (2026-09-02)

- [x] 1. 새 브랜치 `portfolio-dark-mode` 생성 + 체크아웃
- [x] 2. `portfolio/index.html` 수정 — `:root` 기본을 다크 팔레트로, 라이트는 조건부
       (`prefers-color-scheme: light` / `data-theme="light"`). 토글 폴백 로직도 수정.
- [x] 3. 브라우저로 열어 확인 — 사용자 승인 ("좋아 머지해")
- [x] 4. `main` 체크아웃 → `git merge --no-ff` → `git push origin main`
- [x] 5. `tasks/progress.md` 에 기록

### 결과
- main 최신: e3899ab (merge commit)
- GitHub 반영됨: db40111..e3899ab
- 로컬 브랜치 `portfolio-dark-mode` 는 남겨둠 (필요시 `git branch -d portfolio-dark-mode` 로 삭제)
