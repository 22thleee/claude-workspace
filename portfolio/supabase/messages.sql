-- ============================================================
-- 방명록(guestbook) — messages 테이블 + RLS
-- 실행 방법: Supabase 대시보드 > SQL Editor 에 붙여넣고 [Run]
-- 프로젝트: wnzaeouoatogztnxjdlv
-- ============================================================

-- 1) 테이블 ------------------------------------------------
create table if not exists public.messages (
  id          bigint generated always as identity primary key,
  name        text        not null,
  content     text        not null,
  created_at  timestamptz not null default now(),

  constraint messages_name_len
    check (char_length(trim(name)) between 1 and 40),
  constraint messages_content_len
    check (char_length(trim(content)) between 1 and 1000)
);

comment on table public.messages is '포트폴리오 방명록';

-- 2) 인덱스 (최신순 목록 조회용) -------------------------
create index if not exists messages_created_at_idx
  on public.messages (created_at desc);

-- 3) RLS 활성화 (이걸 켜야 아래 정책이 적용됨) -----------
alter table public.messages enable row level security;

-- 정책을 다시 실행해도 되도록 기존 것 제거
drop policy if exists "messages_select_public" on public.messages;
drop policy if exists "messages_insert_public" on public.messages;

-- 4) 정책: 누구나 읽기 ----------------------------------
create policy "messages_select_public"
  on public.messages
  for select
  to anon, authenticated
  using (true);

-- 5) 정책: 누구나 쓰기(작성) --------------------------
create policy "messages_insert_public"
  on public.messages
  for insert
  to anon, authenticated
  with check (
    char_length(trim(name))    between 1 and 40
    and char_length(trim(content)) between 1 and 1000
  );

-- UPDATE / DELETE 정책은 만들지 않음
--  → anon·authenticated 는 수정·삭제 불가.
--    스팸 삭제는 Supabase 대시보드 Table Editor 또는 service_role 키로.

-- 6) 컬럼 단위 권한: id·created_at 위조 방지 ------------
--    (작성 시 name·content 만 받고, 번호·시간은 서버 기본값 사용)
revoke insert on public.messages from anon, authenticated;
grant  insert (name, content) on public.messages to anon, authenticated;

-- 7) 이중 방어: 수정·삭제 권한 회수 --------------------
revoke update, delete on public.messages from anon, authenticated;
