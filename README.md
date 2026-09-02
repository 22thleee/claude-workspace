# claude-workspace

기획자 / 안전관리자의 **Claude Code 작업 공간**입니다.
Claude Code는 이 폴더에서 작업하며, `CLAUDE.md`의 규칙을 따릅니다.

---

## 📁 폴더 구조

```
claude-workspace/
│
├── CLAUDE.md            Claude Code 행동 지침 (보안 규칙 · 소통 방식 · 작업 원칙)
├── README.md            이 파일 — 폴더 안내
├── SECURITY.md          🚨 키 노출 의심 시 비상 매뉴얼 (폐기→재발급→교체→확인)
│
├── .env.example         환경변수 견본 (형식만, 실제 키 없음)
├── .env                 실제 키 파일 ⚠️ 직접 생성 · 공유 금지 · git 추적 안 됨
├── .gitignore           git 에 올리지 않을 파일 목록 (.env · *.key · 개인자료 등)
│
├── tasks/               작업 기록
│   ├── todo.md          오늘 할 일 체크리스트 (작업 시작 시 확인)
│   └── progress.md      한 일 요약 (append-only, 작업 끝날 때 추가)
│
├── scripts/             자동화 스크립트 (PowerShell)
│   ├── weather.ps1                  강남구 날씨·미세먼지 조회 → weather.txt 누적 저장
│   ├── register-weather-task.ps1    위 스크립트를 매일 09:00 작업 스케줄러에 등록
│   └── unregister-weather-task.ps1  자동 실행 해제
│
├── portfolio/           포트폴리오 웹페이지
│   └── index.html       반응형 1파일 포트폴리오 (라이트/다크 테마)
│
└── docs/                개인·업무 자료  ※ git 추적 제외 (로컬에만 보관)
    ├── resume.pdf        이력서
    └── sales.csv         매출 데이터
```

> `weather.txt`, `docs/resume.pdf`, `docs/sales.csv` 는 `.gitignore` 에 등록되어
> **저장소에는 올라가지 않습니다.** 로컬 폴더에는 그대로 남아 있습니다.

---

## 🚀 처음 시작하기

1. **환경변수 파일 만들기**
   ```powershell
   Copy-Item .env.example .env
   ```
   그다음 `.env` 를 열어 실제 키 값을 채웁니다. (`.env` 는 git 에 올라가지 않음)

2. **작업 시작할 때**
   - `tasks/todo.md` 를 열어 오늘 할 일을 확인 / 추가
   - 3단계 이상 큰 작업이면 `todo.md` 에 계획부터 적고 Claude 에게 확인받기

3. **작업 끝낼 때**
   - `tasks/progress.md` 에 한 일을 요약해서 추가 (날짜 포함)

---

## 🛠️ 자동화 스크립트

### 날씨·미세먼지 매일 수집 (API 키 불필요)

```powershell
# 수동 실행 (한 번 테스트)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\weather.ps1

# 매일 09:00 자동 실행 등록 / 해제
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\register-weather-task.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\unregister-weather-task.ps1
```

- 데이터 출처: [Open-Meteo](https://open-meteo.com) (무료, 키 불필요)
- 결과는 `weather.txt` 에 **누적(append)** 저장

---

## 🔒 보안 핵심 (자세한 내용은 `CLAUDE.md`)

- API 키·비밀번호는 항상 마스킹해서 표시 (`sk-or-v1-***`)
- `.env`, `*.key`, `*.pem`, `*credentials*` 파일은 절대 git 에 올리지 않음
- 코드에 키 하드코딩 금지 → 환경변수만 참조
- 키 노출 의심 시 → **`SECURITY.md`** 순서대로 (폐기 → 재발급 → 교체 → 확인)

---

## ⚠️ 위험한 작업은 먼저 확인

파일·폴더 삭제 / DB 파괴 / git 되돌리기(`reset --hard`, `push --force`) /
서비스 중지 / 서버 재설치 / 대량 파일 이동 — 실행 전 반드시 사용자에게 질문합니다.

---

## 🔗 자주 쓰는 경로

| 용도 | 경로 |
|------|------|
| 메인 폴더 | `~/claude-workspace` |
| 할 일 / 기록 | `tasks/todo.md` · `tasks/progress.md` |
| 환경변수 | `.env` (git 제외) |
| 비상 매뉴얼 | `SECURITY.md` |
| 오라클 SSH 키 | `~/.ssh/oracle-server.key` (이 폴더 밖) |
| 오라클 서버 접속 | `ssh oracle-server` (SSH config 별칭) |

---

*환경 구축: 2026-09-02*
