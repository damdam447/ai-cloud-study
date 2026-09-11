# CSV 기반 환율 계산기

Frankfurter API에서 USD 기준 환율을 CSV로 저장하고, HTML 화면에서 해당 CSV를 읽어 USD·KRW·JPY·EUR 간 금액을 계산합니다.

프로젝트 위치: `C:\ai-starter\exchange-calculator`

## 빠르게 다시 실행하기

PowerShell에서 실행합니다.

```powershell
cd C:\ai-starter\exchange-calculator
powershell -ExecutionPolicy Bypass -File .\start.ps1
```

브라우저에서 [환율 계산기](http://127.0.0.1:8765)를 엽니다. 서버를 실행한 터미널은 열어 두고, 종료할 때 `Ctrl+C`를 누릅니다. 서버는 이 컴퓨터의 `127.0.0.1`에서만 접속할 수 있습니다.

서버 없이 사용하려면 `index.html`을 더블클릭한 다음 화면의 **CSV 파일 직접 선택**에서 같은 폴더의 `rates.csv`를 선택합니다. 브라우저는 HTML 파일을 직접 열었을 때 옆의 CSV를 자동으로 읽지 못할 수 있습니다.

## 최신 환율 저장하기

별도의 PowerShell 창에서 실행합니다.

```powershell
cd C:\ai-starter\exchange-calculator
powershell -ExecutionPolicy Bypass -File .\update-rates.ps1
```

실행하면 API 자료를 검증하고 `rates.csv`를 교체합니다. 화면에서 **저장된 CSV 다시 읽기**를 누르면 갱신된 값으로 계산합니다. HTML 파일을 직접 연 경우 CSV를 다시 선택합니다.

화면의 다시 읽기 버튼은 저장된 CSV만 읽습니다. API 조회는 `update-rates.ps1`을 실행할 때 수행합니다. 다운로드나 검증이 실패하면 기존 CSV는 유지됩니다.

## 파일 구성

| 파일 | 역할 |
|---|---|
| `index.html` | 한국어 화면, 입력·통화 선택, CSS 스타일 |
| `calculator.js` | CSV 해석·검증, 환산 계산, 화면 갱신 |
| `rates.csv` | 저장된 환율 데이터 |
| `update-rates.ps1` | API 조회 후 UTF-8 CSV 저장 |
| `start.ps1` | Python으로 로컬 HTTP 서버 실행 |
| `README.md` | 실행 및 작업 재개 안내 |
| `README.txt` | 최초 작성한 간단 사용 안내 |

별도의 npm 설치나 빌드 과정은 없습니다. 데이터 갱신에는 PowerShell과 인터넷 연결, 자동 CSV 로딩용 서버에는 Python 3가 필요합니다. 직접 HTML을 열어 CSV를 선택하는 방식은 Python 없이 사용할 수 있습니다.

`start.ps1`은 현재 PC의 Codex 번들 Python을 먼저 사용하고, 해당 경로가 없으면 PATH의 `python` 명령을 사용합니다. 다른 PC에서는 Python 설치 상태를 확인하거나 스크립트의 `$python` 경로를 수정하세요.

## 데이터 출처와 CSV 형식

API: [Frankfurter USD 기준 KRW·JPY·EUR 환율](https://api.frankfurter.dev/v1/latest?from=USD&to=KRW,JPY,EUR)

아래는 최초 저장된 자료입니다. API 갱신 후 값과 기준일은 달라질 수 있습니다.

```csv
"date","base","currency","rate"
"2026-09-09","USD","KRW","1336.2"
"2026-09-09","USD","JPY","153.27"
"2026-09-09","USD","EUR","0.85822"
```

| 열 | 의미 |
|---|---|
| `date` | API가 반환한 환율 기준일. 다운로드 날짜와 다를 수 있음 |
| `base` | 기준 통화. 현재 USD 고정 |
| `currency` | 환산 대상 통화 KRW, JPY, EUR |
| `rate` | 1 USD에 해당하는 대상 통화 금액. 양수 |

열 순서는 `date,base,currency,rate`입니다. 세 통화가 각각 한 번씩 있어야 하며 모든 행의 기준일이 같아야 합니다. 현재 파서는 이 단순한 4열 형식에 맞춰 작성되어 있어 셀 안의 쉼표나 여러 줄 문자열은 지원하지 않습니다.

## 계산 방식

```text
환산 금액 = 입력 금액 ÷ 보유 통화의 USD 기준 환율 × 받을 통화의 USD 기준 환율
USD의 USD 기준 환율 = 1
```

위 예시 자료 기준:

- 100 USD → 133,620 KRW
- 133,620 KRW → 15,327 JPY
- 동일 통화로 변환하면 입력 금액 유지

JavaScript 숫자로 계산하고, 최종 표시 금액은 소수 둘째 자리까지 반올림합니다. 환율은 저장된 기준일의 참고값이며 환전 수수료는 포함하지 않습니다.

## 다음 작업을 이어가는 방법

1. 이 문서와 `index.html`, `calculator.js`, `update-rates.ps1`, `start.ps1`을 읽습니다.
2. 기존 서버가 동작 중인지 확인하고, 없으면 실행합니다.
3. 화면·배치 수정은 `index.html`, 계산·CSV 처리 수정은 `calculator.js`에서 진행합니다.
4. API 또는 CSV 열을 변경할 때는 저장 스크립트와 `parseRates()`를 함께 수정합니다.
5. 통화를 추가할 때는 API URL, 저장 통화 목록, CSV 검증 목록, 표 표시 목록, 두 통화 선택 상자를 함께 수정합니다.
6. 변경 후 아래 항목을 확인하고 이 문서도 갱신합니다.

### 수정 후 확인 항목

- CSV가 정상 로딩되고 기준일과 세 환율이 표시되는지
- CSV 값 기준으로 USD→KRW와 KRW→JPY 계산이 맞는지
- 같은 통화 변환과 0 입력이 정상인지
- 빈 값·음수 입력 시 계산 대신 안내가 표시되는지
- 누락·중복 통화, 0 이하 환율, 서로 다른 기준일의 CSV를 거부하는지
- 통화 교환 버튼과 CSV 다시 읽기가 동작하는지
- 작은 화면에서도 입력·결과가 잘 보이는지

최초 작업에서는 CSV 파싱, 교차 환산, 0·동일 통화 계산, 일부 잘못된 CSV 거부, JavaScript 구문 검사와 HTTP 200 응답을 확인했습니다. 브라우저 상호작용과 화면 크기별 시각 검사는 별도로 수행하지 않았습니다.

### 다음 작업 요청 예시

```text
C:\ai-starter\exchange-calculator\README.md를 읽고 기존 환율 계산기 작업을 이어가줘.
현재 CSV 기반 계산 기능을 유지하면서 [원하는 변경 사항]을 적용하고 관련 동작을 확인해줘.
```

## 문제 해결

- **8765 포트 사용 중:** 기존 계산기가 열리는지 먼저 확인합니다. 다른 프로그램이 사용 중이면 `start.ps1`의 포트를 바꾸고 브라우저에서도 같은 포트로 접속합니다.
- **Python을 찾을 수 없음:** `start.ps1`의 실행 경로를 수정하거나 HTML을 직접 열고 CSV를 선택합니다.
- **API 조회 실패:** 인터넷 연결과 오류 메시지를 확인한 뒤 갱신 명령을 다시 실행합니다. 기존 CSV로는 계속 계산할 수 있습니다.
- **CSV를 변경했는데 이전 값 표시:** 서버 방식은 CSV 다시 읽기, 직접 파일 방식은 CSV 재선택을 수행합니다.
- **기준일이 오늘보다 이전:** 다운로드 시각 대신 API의 환율 기준일을 표시합니다.
