$ErrorActionPreference = 'Stop'
$data = Invoke-RestMethod -Uri 'https://api.frankfurter.dev/v1/latest?from=USD&to=KRW,JPY,EUR' -TimeoutSec 30
if ($data.base -ne 'USD' -or $data.amount -ne 1) { throw 'Unexpected API base or amount' }
$rows = foreach ($currency in @('KRW', 'JPY', 'EUR')) {
    $rate = [double]$data.rates.$currency
    if ($rate -le 0 -or [double]::IsNaN($rate) -or [double]::IsInfinity($rate)) { throw "Invalid rate: $currency" }
    [PSCustomObject]@{ date = $data.date; base = 'USD'; currency = $currency; rate = $rate.ToString('R', [Globalization.CultureInfo]::InvariantCulture) }
}
$path = Join-Path $PSScriptRoot 'rates.csv'
$rows | Export-Csv -LiteralPath "$path.tmp" -NoTypeInformation -Encoding UTF8
Move-Item -LiteralPath "$path.tmp" -Destination $path -Force
Write-Host "Saved: $path (date: $($data.date))"
