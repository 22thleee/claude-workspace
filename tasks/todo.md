# TODO

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
