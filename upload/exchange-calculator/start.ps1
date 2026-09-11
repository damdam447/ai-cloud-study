Set-Location $PSScriptRoot
$python = 'C:\Users\Admin\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
if (-not (Test-Path $python)) { $python = 'python' }
Write-Host 'Open http://127.0.0.1:8765 (Ctrl+C to stop)'
& $python -m http.server 8765 --bind 127.0.0.1 --directory $PSScriptRoot
