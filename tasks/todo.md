# TODO

## claude-workspace 를 GitHub private 레포로 올리기

- [ ] 1. `.gitignore` 업데이트 — 기존 키 패턴 유지 + 아래 추가
       - `weather.txt` (스크립트 자동 생성 결과물)
       - `docs/resume.pdf` (이력서 — 사용자 결정: 제외)
       - `docs/sales.csv` (매출 데이터 — 사용자 결정: 제외)
- [ ] 2. `README.md` 새로 작성 — 전체 폴더 구조(docs/ scripts/ portfolio/ 포함) 반영
- [ ] 3. `git init` (기본 브랜치 main) + git 사용자 정보 확인
- [ ] 4. `git add -A` 후 `git status` 로 제외 파일(.env 계열, resume.pdf, sales.csv, weather.txt)이
       실제로 빠졌는지 눈으로 확인
- [ ] 5. `git commit -m "Initial setup"`
- [ ] 6. `gh repo create claude-workspace --private --source=. --push` 로 레포 생성 + 푸시
- [ ] 7. 레포 URL 확인, `tasks/progress.md` 에 기록

### 메모
- 실제 `.env` / `*.key` 파일은 폴더에 없음 (확인함)
- GitHub 계정: 22thleee / 프로토콜 HTTPS
- 제외 파일들은 로컬에는 그대로 남음 (git 추적만 안 함)
