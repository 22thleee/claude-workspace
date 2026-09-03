# 포트폴리오 웹 — 배포 안내

이태훈 / 안전관리자 포트폴리오. **정적 사이트**(HTML 1파일)라 빌드 과정이 없습니다.

```
portfolio/
├── index.html     페이지 본문 (디자인·내용 전부 이 파일 안에)
├── favicon.svg    브라우저 탭 아이콘
├── robots.txt     검색엔진 수집 허용
├── vercel.json    Vercel 설정 (클린 URL + 기본 보안 헤더)
└── index.html.bak 수정 전 백업 (git 에 안 올라감)
```

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
