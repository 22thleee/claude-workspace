# 포트폴리오 웹 — 배포 안내

이태훈 / 안전관리자 포트폴리오. **정적 사이트**(HTML 1파일)라 빌드 과정이 없습니다.

```
portfolio/
├── index.html         페이지 본문 (디자인·내용·방명록 스크립트 전부 이 파일 안에)
├── favicon.svg        브라우저 탭 아이콘
├── robots.txt         검색엔진 수집 허용
├── vercel.json        Vercel 설정 (클린 URL + 기본 보안 헤더)
├── config.example.js  방명록 설정 템플릿 (git 포함)
├── config.js          방명록 실제 설정 — 자동 생성, git 제외
├── supabase/
│   └── messages.sql   방명록 테이블 + RLS (Supabase SQL Editor 에서 실행)
└── index.html.bak     수정 전 백업 (git 에 안 올라감)
```

---

## 📖 방명록 (Supabase) 세팅

방명록은 Supabase(Postgres) 의 `messages` 테이블에 글을 저장합니다.
빌드 과정이 없는 정적 사이트라, 연결 정보는 아래 흐름으로 주입합니다.

```
.env.local  (repo 루트, git 제외)  ── node scripts/gen-config.mjs ──▶  portfolio/config.js  (git 제외)
                                                                        └─ index.html 이 <script src="config.js"> 로 읽음
```

### 1. Supabase 에 테이블 만들기 (최초 1회)

`portfolio/supabase/messages.sql` 내용을 복사 → Supabase 대시보드 **SQL Editor** 에 붙여넣고 **Run**.
`messages(id, name, content, created_at)` 테이블과 RLS 정책(누구나 읽기/쓰기)이 생성됩니다.

### 2. 연결 정보 넣기

repo 루트 `.env.local` 에 값이 들어 있어야 합니다 (`.env.example` 형식 참고):

```
SUPABASE_URL=https://<프로젝트>.supabase.co
SUPABASE_ANON_KEY=eyJ...
```

> `anon key` 는 브라우저에 노출되는 **공개 키**입니다. 데이터 보호는 RLS 가 합니다.
> **service_role 키·DB 비밀번호는 절대 여기 넣지 마세요.**

### 3. config.js 생성

```bash
node scripts/gen-config.mjs
```

`.env.local` 을 고칠 때마다 이 명령을 다시 실행하세요.

### 4. 로컬에서 테스트

```bash
node scripts/gen-config.mjs          # config.js 생성/갱신
cd portfolio
python -m http.server 8000           # 또는  npx serve -l 8000
```

브라우저에서 `http://localhost:8000` → 맨 아래 **방명록** 섹션에서 글 작성 → 목록에 바로 표시되면 정상.
(`file://` 로 직접 열면 `fetch` 가 막혀서 안 됩니다. 반드시 로컬 서버로 여세요.)

### 배포(Vercel) 시 config.js 넣는 법

`config.js` 는 git 에 안 올라가므로 배포본에는 없습니다. 둘 중 하나:

- **간단:** `config.js` 를 커밋한다. (anon key 는 공개 키라 저장소가 private 이면 부담 없음)
- **깔끔:** Vercel 프로젝트 **Settings → Environment Variables** 에 `SUPABASE_URL`,
  `SUPABASE_ANON_KEY` 등록 → **Build Command** 를 `node ../scripts/gen-config.mjs` 로 설정
  (Root Directory 가 `portfolio` 이므로 스크립트 경로 앞에 `../`).

---

## 🚀 Vercel 웹에서 배포하기 (버튼 클릭만)

1. **[vercel.com](https://vercel.com) 로그인** — GitHub 계정으로 로그인하면 편합니다.
2. 대시보드에서 **Add New… → Project** 클릭.
3. **`22thleee/claude-workspace`** 저장소를 **Import**.
4. 설정 화면에서 아래 **한 가지만** 바꿉니다:

   | 항목 | 값 | 설명 |
   |------|-----|------|
   | **Root Directory** | `portfolio` | ⚠️ **꼭 지정하세요.** 저장소 루트가 아니라 `portfolio` 폴더를 사이트 루트로 씁니다. |
   | Framework Preset | `Other` | 자동으로 잡힙니다. 정적 사이트라 그대로 두면 됩니다. |
   | Build Command | (비움) | 빌드 없음 |
   | Output Directory | (비움) | `portfolio` 폴더를 그대로 서빙 |

5. **Deploy** 클릭 → 30초쯤 뒤 `https://프로젝트이름.vercel.app` 주소가 나옵니다.

이후 `main` 브랜치에 푸시할 때마다 자동으로 다시 배포됩니다.

---

## 배포 후 확인할 것

- [ ] 휴대폰에서 열어 글자 크기·여백이 정상인지 (viewport 반영 확인)
- [ ] 탭에 녹색 방패 아이콘이 보이는지 (favicon)
- [ ] 우측 상단 **Theme** 버튼으로 라이트/다크 전환되는지
- [ ] 카톡·링크드인에 주소를 붙여 미리보기 제목/설명이 뜨는지 (OG 태그)
- [ ] 맨 아래 **방명록**에서 글이 작성되고 목록에 뜨는지 (배포본에 `config.js` 반영 필요 — 위 "배포 시" 참고)

## ✏️ 내용 교체 (배포와 별개, 중요)

`index.html` 안의 아래 항목은 아직 **예시 값**입니다. 실제 정보로 바꿔야 합니다.

- **연락처** — 이메일 `taehoon.lee@example.com`, 전화 `010-0000-0000`, LinkedIn 주소
- **성과 지표 4개** (무재해 일수, 재해율 감소 등) — "예시 값" 안내문이 붙어 있음
- **경력 3건** — 회사명·기간·업무. 각 항목에 "예시 항목" 태그가 붙어 있음

교체 후 `og:description`, `<meta name="description">` 문구도 함께 손보면 좋습니다.

---

## 참고 — CLI 로 배포하려면

```bash
npm i -g vercel
cd portfolio
vercel          # 최초 1회: 프로젝트 연결 (Root Directory 물어보면 현재 폴더 선택)
vercel --prod   # 운영 배포
```

`.vercel/` 폴더가 생기며, 이 폴더는 `.gitignore` 에 등록돼 있어 커밋되지 않습니다.
