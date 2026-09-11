환율 계산기

저장 위치: C:\ai-starter\exchange-calculator

1. index.html을 열고 rates.csv를 선택하면 바로 계산할 수 있습니다.
2. CSV를 자동으로 읽으려면 PowerShell에서 다음 명령을 실행하세요.
   cd C:\ai-starter\exchange-calculator
   powershell -ExecutionPolicy Bypass -File .\start.ps1
   브라우저 주소: http://127.0.0.1:8765
3. 최신 환율 CSV 갱신:
   powershell -ExecutionPolicy Bypass -File .\update-rates.ps1
   갱신 후 화면의 '저장된 CSV 다시 읽기' 버튼을 누르세요.

CSV 열: date,base,currency,rate
rate는 1 USD에 해당하는 각 통화의 금액입니다.
계산식: 입력 금액 / 보유 통화의 USD 기준 환율 * 받을 통화의 USD 기준 환율
USD 환율은 1로 계산합니다. 계산 중 원본 정밀도를 유지하고 화면만 소수 둘째 자리까지 반올림합니다.
API 기준일은 휴일 및 발표 시점에 따라 오늘보다 이전일 수 있습니다.
