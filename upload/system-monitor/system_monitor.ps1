# ==============================
# 1. 정보 수집
# ==============================

# PC 제조사와 모델 정보
$computer = Get-CimInstance Win32_ComputerSystem

# 운영체제 정보
$os = Get-CimInstance Win32_OperatingSystem

# CPU 정보
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1

# C드라이브 정보
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"


# ==============================
# 2. 계산
# ==============================

# 메모리 전체 용량 (GB)
$totalMemory = [math]::Round($computer.TotalPhysicalMemory / 1GB, 2)

# 메모리 남은 용량 (GB)
$freeMemory = [math]::Round($os.FreePhysicalMemory / 1MB, 2)

# 메모리 사용량 (GB)
$usedMemory = [math]::Round($totalMemory - $freeMemory, 2)

# 메모리 사용률 (%)
$memoryPercent = [math]::Round(($usedMemory / $totalMemory) * 100, 1)

# C드라이브 전체 용량 (GB)
$totalDisk = [math]::Round($disk.Size / 1GB, 2)

# C드라이브 남은 용량 (GB)
$freeDisk = [math]::Round($disk.FreeSpace / 1GB, 2)

# C드라이브 사용량 (GB)
$usedDisk = [math]::Round($totalDisk - $freeDisk, 2)


# ==============================
# 3. 화면 출력
# ==============================

Write-Host "===== PC 시스템 정보 ====="
Write-Host ""

Write-Host "제조사        :" $computer.Manufacturer
Write-Host "모델명        :" $computer.Model
Write-Host "운영체제      :" $os.Caption

Write-Host ""
Write-Host "CPU           :" $cpu.Name
Write-Host "CPU 코어 수   :" $cpu.NumberOfCores

Write-Host ""
Write-Host "메모리 사용량 :" "$usedMemory GB"
Write-Host "메모리 전체   :" "$totalMemory GB"
Write-Host "메모리 사용률 :" "$memoryPercent %"

Write-Host ""
Write-Host "C드라이브 사용:" "$usedDisk GB"
Write-Host "C드라이브 전체:" "$totalDisk GB"
Write-Host "C드라이브 남음:" "$freeDisk GB"

Write-Host ""
Write-Host "최근 부팅 시각:" $os.LastBootUpTime