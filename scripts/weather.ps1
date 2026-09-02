<#
  weather.ps1
  서울 강남구의 현재 날씨와 미세먼지 정보를 가져와 weather.txt 에 누적 저장한다.
  - API 키 불필요 (Open-Meteo 무료 API 사용)
  - 매일 09:00 작업 스케줄러가 자동 실행하는 것을 전제로 작성
  주의: 이 파일은 UTF-8 (BOM 포함) 로 저장되어야 한다. (한글 깨짐 방지)
#>

# ── 설정 ────────────────────────────────────────────────
$Lat      = 37.5172          # 서울 강남구 위도
$Lon      = 127.0473         # 서울 강남구 경도
$Location = '서울 강남구'
$OutFile  = Join-Path (Split-Path $PSScriptRoot -Parent) 'weather.txt'

# 구버전 PowerShell(5.1) 에서 TLS 1.2 강제 (Open-Meteo 접속용)
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072

# ── WMO 날씨 코드 → 한글 ─────────────────────────────────
$WmoText = @{
   0 = '맑음'; 1 = '대체로 맑음'; 2 = '구름 조금'; 3 = '흐림'
  45 = '안개'; 48 = '짙은 안개'
  51 = '약한 이슬비'; 53 = '이슬비'; 55 = '강한 이슬비'
  56 = '약한 어는 이슬비'; 57 = '강한 어는 이슬비'
  61 = '약한 비'; 63 = '비'; 65 = '강한 비'
  66 = '약한 어는 비'; 67 = '강한 어는 비'
  71 = '약한 눈'; 73 = '눈'; 75 = '강한 눈'; 77 = '싸락눈'
  80 = '약한 소나기'; 81 = '소나기'; 82 = '강한 소나기'
  85 = '약한 눈 소나기'; 86 = '강한 눈 소나기'
  95 = '뇌우'; 96 = '뇌우(약한 우박)'; 99 = '뇌우(강한 우박)'
}

# ── 미세먼지 농도 → 한국 환경부 기준 등급 ────────────────
function Get-DustGrade {
  param([double]$Value, [int]$Good, [int]$Normal, [int]$Bad)
  if     ($Value -le $Good)   { '좋음' }
  elseif ($Value -le $Normal) { '보통' }
  elseif ($Value -le $Bad)    { '나쁨' }
  else                        { '매우 나쁨' }
}

# ── 한글 요일 ───────────────────────────────────────────
$KorDay = @{ Sunday = '일'; Monday = '월'; Tuesday = '화'; Wednesday = '수'; Thursday = '목'; Friday = '금'; Saturday = '토' }
$now   = Get-Date
$stamp = '{0} ({1}) {2}' -f $now.ToString('yyyy-MM-dd'), $KorDay[$now.DayOfWeek.ToString()], $now.ToString('HH:mm')

# ── 1. 날씨 조회 ────────────────────────────────────────
$weatherLines = New-Object System.Collections.Generic.List[string]
try {
  $wUrl = "https://api.open-meteo.com/v1/forecast?latitude=$Lat&longitude=$Lon" +
          "&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m" +
          "&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max" +
          "&timezone=Asia%2FSeoul&wind_speed_unit=ms&forecast_days=1"
  $w   = Invoke-RestMethod -Uri $wUrl -Method Get -TimeoutSec 20
  $cur = $w.current
  $day = $w.daily
  $code = [int]$cur.weather_code
  $sky  = if ($WmoText.ContainsKey($code)) { $WmoText[$code] } else { "날씨코드 $code" }

  $weatherLines.Add('[날씨]')
  $weatherLines.Add((' 하늘      : {0}' -f $sky))
  $weatherLines.Add((' 현재기온  : {0}도 (체감 {1}도)' -f $cur.temperature_2m, $cur.apparent_temperature))
  $weatherLines.Add((' 최저/최고 : {0}도 / {1}도' -f $day.temperature_2m_min[0], $day.temperature_2m_max[0]))
  $weatherLines.Add((' 습도      : {0}%' -f $cur.relative_humidity_2m))
  $weatherLines.Add((' 강수      : {0}mm (오늘 강수확률 {1}%)' -f $cur.precipitation, $day.precipitation_probability_max[0]))
  $weatherLines.Add((' 바람      : {0} m/s' -f $cur.wind_speed_10m))
}
catch {
  $weatherLines.Add('[날씨] 조회 실패: ' + $_.Exception.Message)
}

# ── 2. 미세먼지 조회 ────────────────────────────────────
$dustLines = New-Object System.Collections.Generic.List[string]
try {
  $aUrl = "https://air-quality-api.open-meteo.com/v1/air-quality?latitude=$Lat&longitude=$Lon" +
          "&current=pm10,pm2_5&timezone=Asia%2FSeoul&forecast_days=1"
  $a    = Invoke-RestMethod -Uri $aUrl -Method Get -TimeoutSec 20
  $pm10 = [double]$a.current.pm10
  $pm25 = [double]$a.current.pm2_5

  $dustLines.Add('[미세먼지]')
  $dustLines.Add((' 미세먼지(PM10)    : {0} ug/m3 - {1}' -f [math]::Round($pm10), (Get-DustGrade $pm10 30 80 150)))
  $dustLines.Add((' 초미세먼지(PM2.5) : {0} ug/m3 - {1}' -f [math]::Round($pm25), (Get-DustGrade $pm25 15 35 75)))
}
catch {
  $dustLines.Add('[미세먼지] 조회 실패: ' + $_.Exception.Message)
}

# ── 3. 기록 작성 ────────────────────────────────────────
$block = New-Object System.Collections.Generic.List[string]
$block.Add('========================================')
$block.Add("[일시] $stamp 기준")
$block.Add("[위치] $Location (위도 $Lat, 경도 $Lon)")
$block.Add('----------------------------------------')
$weatherLines | ForEach-Object { $block.Add($_) }
$dustLines    | ForEach-Object { $block.Add($_) }
$block.Add('출처: Open-Meteo (무료, API 키 불필요)')
$block.Add('========================================')
$block.Add('')

$text = ($block -join "`r`n") + "`r`n"

# 콘솔 출력 + weather.txt 에 누적 저장 (UTF-8, BOM 없음)
Write-Output $text
$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::AppendAllText($OutFile, $text, $utf8)

Write-Output "저장 완료 -> $OutFile"
