<#
  unregister-weather-task.ps1
  "매일 오전 9시" 자동 실행(GangnamWeatherDaily)을 해제한다.
  weather.ps1 파일이나 weather.txt 는 지우지 않는다. (스케줄 등록만 제거)
#>

$TaskName = 'GangnamWeatherDaily'

if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
  Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
  Write-Output "[완료] 작업 '$TaskName' 자동 실행을 해제했습니다."
} else {
  Write-Output "등록된 작업 '$TaskName' 이 없습니다. (이미 해제됨)"
}
