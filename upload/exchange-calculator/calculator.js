let rates = null;
const amount = document.getElementById('amount');
const from = document.getElementById('from');
const to = document.getElementById('to');
const result = document.getElementById('result');
const status = document.getElementById('status');
function parseRates(text) {
  const lines = text.replace(/^\uFEFF/, '').trim().split(/\r?\n/);
  const cells = line => line.split(',').map(value => value.trim().replace(/^"(.*)"$/, '$1'));
  if (cells(lines.shift()).join(',') !== 'date,base,currency,rate') throw new Error('CSV 열은 date,base,currency,rate 순서여야 합니다.');
  const parsed = { USD: 1 }; let date;
  for (const line of lines) {
    const row = cells(line); const [day, base, currency, value] = row;
    const rate = Number(value);
    if (row.length !== 4 || base !== 'USD' || !['KRW', 'JPY', 'EUR'].includes(currency) || currency in parsed || !/^\d{4}-\d{2}-\d{2}$/.test(day) || (date && day !== date) || !Number.isFinite(rate) || rate <= 0) throw new Error('CSV의 통화, 기준일 또는 환율을 확인해 주세요.');
    parsed[currency] = rate; date = day;
  }
  if (!['KRW', 'JPY', 'EUR'].every(currency => currency in parsed)) throw new Error('KRW, JPY, EUR 환율이 모두 필요합니다.');
  return { rates: parsed, date };
}
function convert(value, source, target, data) { return value / data[source] * data[target]; }
function calculate() {
  if (!rates) { result.textContent = 'CSV를 불러오세요'; return; }
  const value = Number(amount.value);
  if (amount.value.trim() === '' || !Number.isFinite(value) || value < 0) { result.textContent = '0 이상의 금액을 입력하세요'; return; }
  const converted = convert(value, from.value, to.value, rates);
  if (!Number.isFinite(converted)) { result.textContent = '금액이 너무 큽니다'; return; }
  result.textContent = new Intl.NumberFormat('ko-KR', { maximumFractionDigits: 2 }).format(converted) + ' ' + to.value;
  document.getElementById('unit').textContent = `1 ${from.value} = ${new Intl.NumberFormat('ko-KR', { maximumFractionDigits: 6 }).format(rates[to.value] / rates[from.value])} ${to.value}`;
}
function load(text) {
  const parsed = parseRates(text); rates = parsed.rates;
  status.textContent = `환율 기준일 ${parsed.date} · CSV 불러오기 완료`;
  document.getElementById('table').replaceChildren();
  for (const currency of ['KRW', 'JPY', 'EUR']) {
    const tr = document.createElement('tr');
    for (const value of [currency, rates[currency].toLocaleString('ko-KR', { maximumFractionDigits: 8 })]) {
      const td = document.createElement('td'); td.textContent = value; tr.append(td);
    }
    document.getElementById('table').append(tr);
  }
  calculate();
}
function fail(error) { rates = null; status.textContent = error.message; document.getElementById('table').replaceChildren(); document.getElementById('unit').textContent = ''; calculate(); }
async function reload() {
  try {
    const response = await fetch('./rates.csv', { cache: 'no-store' });
    if (!response.ok) throw new Error('CSV를 읽지 못했습니다. 파일을 선택해 주세요.');
    load(await response.text());
  } catch (error) { fail(new Error(location.protocol === 'file:' ? '아래에서 rates.csv 파일을 선택해 주세요.' : error.message)); }
}
amount.addEventListener('input', calculate);
from.addEventListener('change', calculate); to.addEventListener('change', calculate);
document.getElementById('swap').onclick = () => { [from.value, to.value] = [to.value, from.value]; calculate(); };
document.getElementById('reload').onclick = reload;
document.getElementById('file').onchange = async event => {
  const file = event.target.files[0]; if (!file) return;
  try { load(await file.text()); } catch (error) { fail(error); }
};
reload();
