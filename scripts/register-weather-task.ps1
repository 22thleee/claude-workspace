<#
  register-weather-task.ps1
  weather.ps1 을 "매일 오전 9시" 자동 실행하도록 윈도우 작업 스케줄러에 등록한다.
  실행 방법: 이 파일에서 마우스 오른쪽 > "PowerShell에서 실행"
            또는 프롬프트에 아래처럼 입력
            !  powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Hoon's Desktop\Desktop\claude-workspace\scripts\register-weather-task.ps1"
#>

$ErrorActionPreference = 'Stop'

$TaskName   = 'GangnamWeatherDaily'
$ScriptPath = Join-Path $PSScriptRoot 'weather.ps1'

if (-not (Test-Path $ScriptPath)) {
  Write-Error "weather.ps1 을 찾을 수 없습니다: $ScriptPath"
  return
}

# 매일 09:00 실행 트리거
$trigger = New-ScheduledTaskTrigger -Daily -At '09:00'

# powershell.exe 로 weather.ps1 실행 (창 없이, 정책 우회)
$action = New-ScheduledTaskAction -Execute 'powershell.exe' `
  -Argument "-NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$ScriptPath`""

# PC 가 꺼져 있어 놓친 경우 켜지면 곧바로 실행 / 최대 10분 제한
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable `
  -ExecutionTimeLimit (New-TimeSpan -Minutes 10) `
  -DontStopOnIdleEnd

# 같은 이름의 기존 작업이 있으면 먼저 제거 (재등록 대비)
if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
  Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
  Write-Output "기존 작업 '$TaskName' 을 지우고 다시 등록합니다."
}

Register-ScheduledTask -TaskName $TaskName `
  -Description '매일 09:00 서울 강남구 날씨/미세먼지를 weather.txt 에 저장 (Open-Meteo, API 키 불필요)' `
  -Trigger $trigger -Action $action -Settings $settings | Out-Null

Write-Output ''
Write-Output "[완료] 작업 '$TaskName' 등록됨 - 매일 오전 9시에 자동 실행됩니다."
Write-Output ''
Write-Output "지금 바로 한 번 테스트하려면:"
Write-Output "  Start-ScheduledTask -TaskName $TaskName"
Write-Output "등록 상태 확인:"
Write-Output "  Get-ScheduledTask -TaskName $TaskName | Get-ScheduledTaskInfo"
Write-Output "자동 실행을 해제하려면 scripts\unregister-weather-task.ps1 을 실행하세요."
