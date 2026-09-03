# 포트폴리오 웹 — 배포 안내

이태훈 / 안전관리자 포트폴리오. **정적 사이트**(HTML 1파일)라 빌드 과정이 없습니다.
Vercel 은 `portfolio/` 폴더를 그대로 서빙합니다.

```
portfolio/
├── index.html         페이지 본문 (디자인·내용·방명록 스크립트 전부 이 파일 안에)
├── favicon.svg        브라우저 탭 아이콘
├── robots.txt         검색엔진 수집 허용
├── vercel.json        Vercel 설정 (클린 URL + 보안 헤더)
├── config.js          방명록 Supabase 연결 정보 (커밋됨 — anon/public 키)
├── config.example.js  config.js 템플릿
├── supabase/
│   └── messages.sql   방명록 테이블 + RLS (Supabase SQL Editor 에서 실행)
└── index.html.bak     수정 전 백업 (git 에 안 올라감)
```

---

## 📖 방명록 (Supabase) 세팅

방명록은 Supabase(Postgres) 의 `messages` 테이블에 글을 저장합니다.
연결 정보는 `portfolio/config.js` 한 파일에 들어 있고, **이 파일은 git 에 커밋**되어
배포본에 그대로 포함됩니다. (`SUPABASE_ANON_KEY` 는 브라우저에 노출되는 공개 키이고,
데이터 접근은 RLS 정책이 막습니다. `service_role` 키·DB 비밀번호는 절대 넣지 않습니다.)

`config.js` 는 손으로 고치지 말고 `.env.local` → 생성 스크립트로 만듭니다:

```
.env.local  (repo 루트, git 제외)  ── node scripts/gen-config.mjs ──▶  portfolio/config.js  (커밋)
```

### 1. Supabase 에 테이블 만들기 (최초 1회)

`portfolio/supabase/messages.sql` 내용을 복사 → Supabase 대시보드 **SQL Editor** 에 붙여넣고 **Run**.
`messages(id, name, content, created_at)` 테이블과 RLS 정책(누구나 읽기/쓰기)이 생성됩니다.

### 2. 연결 정보를 바꿀 때 (Supabase 프로젝트 교체 등)

1. repo 루트 `.env.local` 을 수정 (`.env.example` 형식 참고):

   ```
   SUPABASE_URL=https://<프로젝트>.supabase.co
   SUPABASE_ANON_KEY=eyJ...
   ```

2. 재생성 후 커밋:

   ```bash
   node scripts/gen-config.mjs
   git add portfolio/config.js && git commit -m "Update guestbook Supabase config"
   ```

### 3. 로컬에서 테스트

```bash
node scripts/gen-config.mjs          # (config.js 가 없거나 값을 바꿨을 때만)
cd portfolio
python -m http.server 8000           # 또는  npx serve -l 8000
```

브라우저에서 `http://localhost:8000` → 맨 아래 **방명록** 섹션에서 글 작성 → 목록에 바로 표시되면 정상.
(`file://` 로 직접 열면 `fetch` 가 막혀서 안 됩니다. 반드시 로컬 서버로 여세요.)

---

## 🚀 Vercel 웹에서 배포하기 (버튼 클릭만)

빌드 과정이 없습니다. `config.js` 도 이미 커밋돼 있어서 대시보드에서 손댈 것은 **Root Directory 하나**뿐입니다.

1. **[vercel.com](https://vercel.com) 로그인** (GitHub 계정).
2. **Add New… → Project** → **`22thleee/claude-workspace`** 를 **Import**.
3. **Root Directory** 를 `portfolio` 로 지정. ⚠️ **이걸 안 하면 404** 가 뜹니다.
   - Framework Preset: `Other` (자동)
   - Build Command / Output Directory: **비워 둠** (건드리면 배포가 깨집니다)
4. **Deploy** → `https://프로젝트이름.vercel.app`

이후 `main` 에 푸시할 때마다 자동 재배포됩니다.
Supabase 테이블(`messages.sql`)은 배포 전에 실행돼 있어야 방명록이 동작합니다.

---

## 배포 후 확인할 것

- [ ] 휴대폰에서 열어 글자 크기·여백이 정상인지 (viewport 반영 확인)
- [ ] 탭에 녹색 방패 아이콘이 보이는지 (favicon)
- [ ] 우측 상단 **Theme** 버튼으로 라이트/다크 전환되는지
- [ ] 카톡·링크드인에 주소를 붙여 미리보기 제목/설명이 뜨는지 (OG 태그)
- [ ] 맨 아래 **방명록**에서 글이 작성되고 목록에 뜨는지
      (안 되면 → Supabase `messages` 테이블 존재 확인 / 브라우저 콘솔의 `[guestbook]` 로그 확인)

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
