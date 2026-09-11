# ==============================================
# 오늘의 환율 이미지를 만들고 바탕화면으로 설정
# ==============================================

# 현재 어느 작업을 실행 중인지 기록합니다.
$Step = "스크립트 시작"

try {
    # ------------------------------------------
    # 1. 기본 경로와 환율 주소 설정
    # ------------------------------------------
    $Step = "파일 경로 설정"

    $OriginalImage = "C:\ai-starter\wallpaper\am.png"
    $OutputFolder = "C:\ai-starter\wallpaper\output"
    $OutputImage = Join-Path $OutputFolder "today.png"

    $ExchangeUrl = "https://api.frankfurter.dev/v1/latest?from=USD&to=KRW,JPY"

    # 원본 이미지가 있는지 확인합니다.
    if (-not (Test-Path $OriginalImage)) {
        throw "원본 이미지를 찾을 수 없습니다: $OriginalImage"
    }

    # output 폴더가 없으면 새로 만듭니다.
    if (-not (Test-Path $OutputFolder)) {
        New-Item -Path $OutputFolder -ItemType Directory | Out-Null
    }

    # ------------------------------------------
    # 2. 인터넷에서 환율 데이터 받기
    # ------------------------------------------
    $Step = "환율 데이터 받기"

    $ExchangeData = Invoke-RestMethod `
        -Uri $ExchangeUrl `
        -Method Get `
        -TimeoutSec 20 `
        -ErrorAction Stop

    # 환율과 기준일을 꺼냅니다.
    $KrwRate = [double]$ExchangeData.rates.KRW
    $JpyRate = [double]$ExchangeData.rates.JPY
    $RateDate = [string]$ExchangeData.date

    if ($KrwRate -le 0 -or $JpyRate -le 0) {
        throw "환율 데이터에서 KRW 또는 JPY 값을 찾지 못했습니다."
    }

    # 화면에 표시할 숫자 모양을 만듭니다.
    $KrwText = $KrwRate.ToString("#,##0.00")
    $JpyText = $JpyRate.ToString("#,##0.00")

    # 오늘 날짜를 한국어 형태로 만듭니다.
    $TodayText = Get-Date -Format "yyyy년 MM월 dd일"

    # ------------------------------------------
    # 3. 이미지 위에 글자 그리기
    # ------------------------------------------
    $Step = "이미지에 환율 글자 넣기"

    Add-Type -AssemblyName System.Drawing

    # 파일 잠금 문제를 피하기 위해 원본을 읽고 복사본을 만듭니다.
    $SourceImage = [System.Drawing.Image]::FromFile($OriginalImage)
    $NewImage = New-Object System.Drawing.Bitmap(
        $SourceImage.Width,
        $SourceImage.Height
    )

    $Graphics = [System.Drawing.Graphics]::FromImage($NewImage)

    # 원본 이미지를 새 이미지에 그대로 그립니다.
    $Graphics.DrawImage(
        $SourceImage,
        0,
        0,
        $SourceImage.Width,
        $SourceImage.Height
    )

    # 글자를 부드럽게 표시합니다.
    $Graphics.TextRenderingHint = `
        [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    # 이미지 크기에 따라 글자 크기를 정합니다.
    $TitleSize = [Math]::Max(22, [Math]::Round($NewImage.Width / 35))
    $RateSize = [Math]::Max(28, [Math]::Round($NewImage.Width / 25))
    $SmallSize = [Math]::Max(14, [Math]::Round($NewImage.Width / 60))

    # 맑은 고딕 글꼴을 사용합니다.
    $TitleFont = New-Object System.Drawing.Font(
        "맑은 고딕",
        $TitleSize,
        [System.Drawing.FontStyle]::Bold
    )

    $RateFont = New-Object System.Drawing.Font(
        "맑은 고딕",
        $RateSize,
        [System.Drawing.FontStyle]::Bold
    )

    $SmallFont = New-Object System.Drawing.Font(
        "맑은 고딕",
        $SmallSize,
        [System.Drawing.FontStyle]::Regular
    )

    # 흰색 글자와 검은색 그림자를 준비합니다.
    $WhiteBrush = New-Object System.Drawing.SolidBrush(
        [System.Drawing.Color]::White
    )

    $ShadowBrush = New-Object System.Drawing.SolidBrush(
        [System.Drawing.Color]::FromArgb(180, 0, 0, 0)
    )

    # 글자를 그릴 위치입니다.
    $X = 70
    $DateY = 70
    $RateY = $DateY + $TitleSize + 35
    $BaseDateY = $RateY + $RateSize + 30

    $RateText = "1 USD = $KrwText 원 / $JpyText 엔"
    $BaseDateText = "환율 기준일: $RateDate"

    # 먼저 검은색 그림자를 조금 옆에 그립니다.
    $Graphics.DrawString(
        $TodayText, $TitleFont, $ShadowBrush, $X + 3, $DateY + 3
    )
    $Graphics.DrawString(
        $RateText, $RateFont, $ShadowBrush, $X + 3, $RateY + 3
    )
    $Graphics.DrawString(
        $BaseDateText, $SmallFont, $ShadowBrush, $X + 3, $BaseDateY + 3
    )

    # 그림자 위에 흰색 글자를 그립니다.
    $Graphics.DrawString(
        $TodayText, $TitleFont, $WhiteBrush, $X, $DateY
    )
    $Graphics.DrawString(
        $RateText, $RateFont, $WhiteBrush, $X, $RateY
    )
    $Graphics.DrawString(
        $BaseDateText, $SmallFont, $WhiteBrush, $X, $BaseDateY
    )

    # 기존 today.png가 열려 있지 않은지 확인한 후 저장합니다.
    $NewImage.Save(
        $OutputImage,
        [System.Drawing.Imaging.ImageFormat]::Png
    )

    # 사용한 이미지 관련 자원을 정리합니다.
    $Graphics.Dispose()
    $SourceImage.Dispose()
    $NewImage.Dispose()
    $TitleFont.Dispose()
    $RateFont.Dispose()
    $SmallFont.Dispose()
    $WhiteBrush.Dispose()
    $ShadowBrush.Dispose()

    # ------------------------------------------
    # 4. 만들어진 이미지를 바탕화면으로 설정
    # ------------------------------------------
    $Step = "Windows 바탕화면 설정"

    # 바탕화면 이미지 표시 방식을 '채우기'로 설정합니다.
    Set-ItemProperty `
        -Path "HKCU:\Control Panel\Desktop" `
        -Name WallpaperStyle `
        -Value "10"

    Set-ItemProperty `
        -Path "HKCU:\Control Panel\Desktop" `
        -Name TileWallpaper `
        -Value "0"

    # Windows의 바탕화면 변경 기능을 불러옵니다.
    Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(
        int action,
        int parameter,
        string path,
        int options
    );
}
"@

    # SPI_SETDESKWALLPAPER = 20
    $Changed = [Wallpaper]::SystemParametersInfo(
        20,
        0,
        $OutputImage,
        3
    )

    if (-not $Changed) {
        throw "Windows가 바탕화면 변경 요청을 처리하지 못했습니다."
    }

    # ------------------------------------------
    # 5. 완료 내용 출력
    # ------------------------------------------
    Write-Host ""
    Write-Host "작업이 완료되었습니다." -ForegroundColor Green
    Write-Host "오늘 날짜    : $TodayText"
    Write-Host "환율 기준일  : $RateDate"
    Write-Host "원화 환율    : 1 USD = $KrwText 원"
    Write-Host "엔화 환율    : 1 USD = $JpyText 엔"
    Write-Host "저장 위치    : $OutputImage"
}
catch {
    # 실패한 작업과 오류 원인을 빨간색으로 보여줍니다.
    Write-Host ""
    Write-Host "작업을 완료하지 못했습니다." -ForegroundColor Red
    Write-Host "멈춘 위치: $Step" -ForegroundColor Yellow
    Write-Host "오류 내용: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    # 오류가 발생했을 때 남아 있을 수 있는 이미지 자원을 정리합니다.
    if ($Graphics)    { $Graphics.Dispose() }
    if ($SourceImage) { $SourceImage.Dispose() }
    if ($NewImage)    { $NewImage.Dispose() }
}