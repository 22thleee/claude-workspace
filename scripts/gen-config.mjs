#!/usr/bin/env node
/*
 * .env.local (repo 루트) 또는 환경변수를 읽어
 * portfolio/config.js 를 생성합니다.
 *
 *   node scripts/gen-config.mjs
 *
 * 우선순위: .env.local 의 값 > process.env 의 값
 * 어느 경로에서 실행해도 되도록 스크립트 위치를 기준으로 경로를 잡습니다.
 */
import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const scriptDir = dirname(fileURLToPath(import.meta.url));
const repoRoot = join(scriptDir, "..");
const envPath = join(repoRoot, ".env.local");
const outPath = join(repoRoot, "portfolio", "config.js");

function parseEnv(text) {
  const out = {};
  for (const rawLine of text.split(/\r?\n/)) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#")) continue;
    const eq = line.indexOf("=");
    if (eq === -1) continue;
    const key = line.slice(0, eq).trim();
    let val = line.slice(eq + 1).trim();
    if (
      (val.startsWith('"') && val.endsWith('"')) ||
      (val.startsWith("'") && val.endsWith("'"))
    ) {
      val = val.slice(1, -1);
    }
    out[key] = val;
  }
  return out;
}

const fromFile = existsSync(envPath)
  ? parseEnv(readFileSync(envPath, "utf8"))
  : {};

const url = fromFile.SUPABASE_URL || process.env.SUPABASE_URL || "";
const anonKey = fromFile.SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY || "";

const onVercel = !!process.env.VERCEL;

if (!url || !anonKey) {
  const msg =
    "[gen-config] SUPABASE_URL / SUPABASE_ANON_KEY 를 찾지 못했습니다.\n" +
    "  - 로컬: repo 루트에 .env.local 을 만드세요 (.env.example 참고)\n" +
    "  - Vercel: 프로젝트 Settings > Environment Variables 에 두 값을 등록하세요.";
  if (onVercel) {
    // 배포는 계속 진행 — 방명록만 비활성(페이지에 "설정 필요" 안내가 뜸)
    console.warn(msg + "\n  → 빈 config.js 로 계속합니다 (방명록 비활성).");
  } else {
    console.error(msg);
    process.exit(1);
  }
}

const banner = "// 자동 생성 파일 — 직접 수정하지 마세요. `node scripts/gen-config.mjs` 로 재생성됩니다.";
const body = `${banner}\nwindow.PORTFOLIO_CONFIG = {\n  SUPABASE_URL: ${JSON.stringify(url)},\n  SUPABASE_ANON_KEY: ${JSON.stringify(anonKey)},\n};\n`;

writeFileSync(outPath, body, "utf8");

const mask = (s) => (s.length > 12 ? s.slice(0, 6) + "…" + s.slice(-4) : "***");
console.log("[gen-config] portfolio/config.js 생성 완료");
console.log("  SUPABASE_URL      =", url);
console.log("  SUPABASE_ANON_KEY =", mask(anonKey));
