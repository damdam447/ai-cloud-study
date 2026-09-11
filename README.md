# AI Starter

이 저장소는 HTML, JavaScript, CSV를 이용한 간단한 환율 계산기 실습 내용을 담고 있습니다.
PowerShell을 이용해 시스템 정보를 확인하는 방법을 연습합니다.
환율 정보를 이미지에 표시하고 Windows 바탕화면으로 설정하는 작업을 연습합니다.

## 폴더 설명

* `exchange-calculator`: 환율 계산 웹페이지와 환율 데이터 갱신 스크립트가 들어 있습니다.
* `system-monitor`: PC의 시스템 정보를 확인하는 PowerShell 스크립트와 작업 설명이 들어 있습니다.
* `wallpaper`: 환율 정보를 이미지에 표시하는 PowerShell 스크립트와 원본 이미지가 들어 있습니다.
* `wallpaper/output`: 스크립트 실행으로 만들어진 결과 이미지가 저장됩니다.

## 결과물 확인 방법

### 1. 환율 계산기

`exchange-calculator` 폴더의 `index.html`을 더블클릭하면 웹브라우저에서 계산기 화면을 확인할 수 있습니다.

필요한 파일:

* `index.html`: 계산기 화면
* `calculator.js`: 계산 기능
* `rates.csv`: 계산에 사용하는 환율 데이터
* `update-rates.ps1`: 환율 데이터를 갱신하는 PowerShell 스크립트
* `start.ps1`: 계산기 실행을 돕는 PowerShell 스크립트

### 2. 시스템 모니터

PowerShell에서 `system-monitor` 폴더로 이동한 후 다음 명령어를 실행합니다.

```powershell
.\system_monitor.ps1
```

실행하면 PC의 시스템 정보가 PowerShell 화면에 표시됩니다.

`TASK.md`에서는 해당 작업의 목표와 내용을 확인할 수 있습니다.

### 3. 환율 바탕화면

PowerShell에서 `wallpaper` 폴더로 이동한 후 다음 명령어를 실행합니다.

```powershell
.\exchange-wallpaper.ps1
```

실행 결과는 다음 파일에서 확인할 수 있습니다.

```text
wallpaper\output\today.png
```

`am.png`, `am.jpg`, `pm.jpg`는 바탕화면 제작에 사용하는 이미지 파일입니다.

## 현재 폴더 구조

```text
ai-starter/
├─ exchange-calculator/
│  ├─ calculator.js
│  ├─ index.html
│  ├─ rates.csv
│  ├─ README.md
│  ├─ README.txt
│  ├─ start.ps1
│  └─ update-rates.ps1
├─ system-monitor/
│  ├─ system_monitor.ps1
│  └─ TASK.md
└─ wallpaper/
   ├─ am.jpg
   ├─ am.png
   ├─ exchange-wallpaper.ps1
   ├─ pm.jpg
   └─ output/
      └─ today.png
```
