---
description: pxd 온보딩 설문 답변을 저장합니다. 사용법 `/pxd <답변 내용>`
argument-hint: "<이름/나이/취미/음식/영화/MBTI 자유 형식>"
---

# pxd — 온보딩 설문 답변 저장 (API 방식)

pxd 신입 온보딩 설문의 답변을 **Vercel API** 로 전송합니다.
누구 기기에서든 저장 즉시 전체 참여자에게 실시간 공유됩니다 (별도 auth 불필요).

- **엔드포인트**: `https://pxd-api.vercel.app/api/responses`
- **저장소**: Upstash Redis (Vercel Marketplace)

## 입력

`$ARGUMENTS` — 다음 6개 항목이 포함된 답변 텍스트 (자유 형식):
1. 이름
2. 나이
3. 취미
4. 좋아하는 음식
5. 좋아하는 영화
6. MBTI

## 실행 단계

### 1. 답변 파싱

`$ARGUMENTS` 에서 6개 필드를 추출:
- "이름 홍길동, 나이 32" 같은 명시적 형식도 지원
- "저는 홍길동이고 32살입니다" 같은 자연 문장도 지원

### 2. 누락 필드 확인

이름이 빠지면 저장하지 말고 안내. 나머지 필드는 누락돼도 저장은 진행하되 어떤 필드가 비어있는지 알림.

### 3. API 로 전송

JSON 페이로드로 POST:

```bash
curl -sS -X POST https://pxd-api.vercel.app/api/responses \
  -H "Content-Type: application/json" \
  -d '{
    "name": "<이름>",
    "age": "<나이>",
    "hobby": "<취미>",
    "food": "<음식>",
    "movie": "<영화>",
    "mbti": "<mbti>",
    "raw": "<$ARGUMENTS 원문>"
  }'
```

응답: `{ "ok": true, "saved": {...}, "count": N }`

### 4. 로컬 백업 (선택)

- 폴더: `~/pxd-responses/`
- 폴더 없으면 만들고, `<이름>.md` 로 파일 저장
- 목적: 네트워크 실패 시 사용자 답변이 사라지지 않게

## 보고 형식

```
✓ 온보딩 응답 저장 완료
- 이름: <이름>
- API 저장: ✓ (총 응답 N개)
- 로컬 백업: ✓ ~/pxd-responses/<이름>.md
```

API 실패 시:
```
⚠ API 저장 실패 (네트워크 문제일 수 있음)
- 로컬 백업: ✓ ~/pxd-responses/<이름>.md
- 나중에 재시도: /pxd 를 다시 실행하면 됩니다
```

## 특이 케이스

- **인자 비어있음**: pxd 온보딩 설문 6개 필드를 안내하고 종료.
- **이름 누락**: 이름은 필수. 다시 요청.
- **MBTI 형식 이상**: 4글자 알파벳(예: INTJ)이 아니면 확인.
- **API 500 에러**: 로컬 백업만 저장하고 알림.
