# 🚨 비상 매뉴얼 — 키(비밀번호) 노출 의심 시

> 키가 노출된 것 같으면 **당황하지 말고 이 순서대로** 진행하세요.
> 핵심 원칙: **① 즉시 폐기 → ② 재발급 → ③ 환경변수 교체 → ④ 사용 이력 확인**
> "혹시 노출됐나?" 싶으면 이미 노출됐다고 가정하고 폐기부터 하는 게 안전합니다.

---

## 0. 먼저 — 어떤 키인지 확인

| 키 종류 | 어디에 쓰나 | 노출되면 위험한 것 |
|---------|-------------|--------------------|
| **OpenRouter API 키** (`sk-or-v1-...`) | AI 모델 호출 | 요금 폭탄, 크레딧 도난 |
| **Oracle 서버 SSH 키** (`~/.ssh/oracle-server.key`) | 오라클 클라우드 서버 접속 | 서버 침입, 데이터 유출 |
| **WordPress 계정/앱 비밀번호** | 블로그 관리자 로그인 | 사이트 변조, 악성코드 삽입 |

노출된 키 종류에 따라 아래 해당 섹션으로 가세요.

---

## 1. OpenRouter API 키 노출

### ① 즉시 폐기
1. https://openrouter.ai/keys 접속 → 로그인
2. 노출된 키 찾아서 **Delete(삭제)** 또는 **Disable(비활성화)**
3. 삭제하면 그 키로는 더 이상 호출 불가 → 요금 발생 중단

### ② 재발급
1. 같은 페이지에서 **Create Key** 클릭
2. 새 키 이름 지정 (예: `workspace-2026-09`)
3. 필요하면 **한도(credit limit)** 를 낮게 걸어두기 (사고 대비)
4. 새 키 복사 (`sk-or-v1-...`) — **이때만 전체가 보임**

### ③ 환경변수 교체
1. `~/claude-workspace/.env` 파일 열기
2. `OPENROUTER_API_KEY=` 줄의 값을 새 키로 교체
3. 저장 후 실행 중인 프로그램/터미널 재시작 (환경변수 다시 읽게)

### ④ 사용 이력 확인
1. https://openrouter.ai/activity 에서 최근 사용량·요청 확인
2. 내가 한 적 없는 호출/급증한 사용량 있으면 스크린샷 저장
3. 결제 내역(https://openrouter.ai/credits) 에서 비정상 차감 확인
4. 이상 있으면 OpenRouter 지원팀에 문의 (support)

---

## 2. Oracle 서버 SSH 키 노출

### ① 즉시 폐기 (서버 접근 차단)
1. **다른 정상 키나 콘솔로** 서버 접속:
   Oracle Cloud 웹 콘솔 → Compute → Instances → 해당 인스턴스 → **Console connection**
2. 서버에서 노출된 공개키를 제거:
   ```
   nano ~/.ssh/authorized_keys
   ```
   노출된 키에 해당하는 줄 삭제 후 저장
3. 급하면 인스턴스를 **Stop(정지)** 시켜 접근 자체를 막기

### ② 재발급 (새 키쌍 생성)
1. 로컬(내 PC)에서 새 키쌍 생성:
   ```
   ssh-keygen -t ed25519 -f ~/.ssh/oracle-server-new.key -C "oracle 2026-09"
   ```
2. 새 **공개키**(`oracle-server-new.key.pub`) 내용을 서버 `~/.ssh/authorized_keys`에 추가
3. 새 키로 접속 테스트:
   ```
   ssh -i ~/.ssh/oracle-server-new.key <서버주소>
   ```
4. 접속 확인되면 이전 키 파일 삭제:
   ```
   rm ~/.ssh/oracle-server.key ~/.ssh/oracle-server.key.pub
   mv ~/.ssh/oracle-server-new.key ~/.ssh/oracle-server.key
   mv ~/.ssh/oracle-server-new.key.pub ~/.ssh/oracle-server.key.pub
   ```

### ③ 설정 교체
- `~/.ssh/config` 의 `oracle-server` 항목이 `IdentityFile ~/.ssh/oracle-server.key` 를
  가리키는지 확인 (경로 그대로면 수정 불필요)

### ④ 침입 흔적 확인
1. 서버에서 접속 로그 확인:
   ```
   sudo last -20                          # 최근 로그인
   sudo grep "Accepted" /var/log/auth.log # 성공한 SSH 접속
   sudo grep "Failed"   /var/log/auth.log # 실패한 시도 (무차별 대입)
   ```
2. 내가 한 적 없는 IP에서 **Accepted(성공)** 로그가 있으면 침입 가능성
3. 낯선 프로세스/크론 작업 확인:
   ```
   ps aux --sort=-%cpu | head
   crontab -l
   ```
4. 침입이 확실하면: 중요 데이터 백업 → 인스턴스 새로 만들기(재설치) 고려
   ⚠️ 재설치는 되돌릴 수 없으니 Claude에게 먼저 물어보세요.

---

## 3. WordPress 비밀번호 노출

### ① 즉시 폐기
1. WordPress 관리자 로그인 → **사용자 → 프로필**
2. **새 비밀번호 설정** → 강한 비밀번호로 변경 → 저장
3. **응용 프로그램 비밀번호(Application Passwords)** 를 썼다면:
   프로필 하단에서 노출된 항목 **취소(Revoke)**

### ② 재발급
1. 자동화/API용이면 **새 Application Password** 발급 (이름: `workspace-2026-09`)
2. 발급 직후 나오는 값 복사 (다시 못 봄)

### ③ 환경변수 교체
1. `~/claude-workspace/.env` 의 `WORDPRESS_APP_PASSWORD=` 값 교체
2. `WORDPRESS_USER=` 도 맞는지 확인
3. 저장 후 프로그램 재시작

### ④ 사용 이력 확인
1. 관리자 → **도구 → 사이트 상태**, 그리고 최근 게시글/댓글/사용자 목록 확인
2. 내가 안 쓴 글, 새로 생긴 관리자 계정, 수정된 테마/플러그인 파일 확인
3. 의심되면: 보안 플러그인(Wordfence 등)으로 전체 검사
4. 모든 사용자 로그아웃: 프로필에서 **다른 곳에서 로그아웃**

---

## 4. 공통 마무리 체크리스트

- [ ] 노출된 키 폐기 완료
- [ ] 새 키 발급 완료
- [ ] `.env` 파일에 새 값 반영 완료
- [ ] 프로그램/터미널 재시작함
- [ ] 사용 이력·침입 흔적 확인함
- [ ] 노출 경로 파악 (실수로 커밋? 채팅에 붙여넣기? 스크린샷?)
- [ ] `tasks/progress.md` 에 사건 기록 남김 (날짜, 어떤 키, 조치 내용)

---

## 5. 예방 수칙

1. 키는 **항상 `.env` 파일에만** 두고, 코드에는 `os.environ` / `process.env` 로만 참조
2. `.env`, `*.key`, `*.pem`, `id_rsa`, `credentials` 는 **절대 `git add` 하지 않기**
   → `.gitignore` 에 이미 등록되어 있음
3. 키를 채팅·이슈·스크린샷에 붙여넣지 않기. 공유할 땐 `sk-or-v1-***` 처럼 마스킹
4. 키마다 **한도(limit)** 를 걸어두기 (사고 시 피해 최소화)
5. 3~6개월마다 키를 새로 발급(로테이션)
6. 안 쓰는 옛날 키는 바로 삭제

---

*작성: 2026-09-02 · 관련 규칙은 `CLAUDE.md`의 "보안 규칙" 참고*
