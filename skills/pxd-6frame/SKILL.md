---
name: pxd-6frame
description: pxd 인터뷰 분석 6프레임 프로토콜 — 트랜스크립트 발화를 6프레임(상황·촉발·행동·결과·감정·학습)에 매핑해 findings JSON + 요약 리포트 생성. 프로젝트 폴더에 transcripts/ 가 있고 사용자가 6프레임·인터뷰 분석·발화 태깅을 언급할 때 발동.
---

# pxd 6프레임 인터뷰 분석 스킬

pxd 의 표준 정성 분석 프로토콜. 인터뷰 트랜스크립트를 6개 프레임에 매핑해 **비교 가능한 구조화 데이터** 로 만든다.

## 언제 발동

- 현재 작업 폴더에 `transcripts/`, `transcript*/`, 혹은 `interviews/` 폴더가 있고
- 사용자가 다음 중 하나를 언급:
  - "6프레임", "6frame", "육프레임"
  - "인터뷰 분석", "발화 태깅", "코딩(태깅 의미)"
  - "findings 만들어줘"

## 6프레임 정의

프레임 상세 정의는 `frames.md` 참조. 요약:

| 코드 | 프레임 | 한 줄 정의 |
|---|---|---|
| **S** | Situation | 대상자가 놓인 배경·조건 |
| **T** | Trigger | 행동을 유발한 계기·사건 |
| **A** | Action | 실제로 한 행동 |
| **O** | Outcome | 그 행동의 결과·현상태 |
| **E** | Emotion | 감정·태도 (명시적일 때만) |
| **L** | Learning | 인식·신념의 변화 (명시적일 때만) |

## 절차

### 1. 대상 파일 스캔

`transcripts/*.{txt,md,vtt}` 를 인터뷰 단위로 스캔. VTT (자막 포맷) 는 화자 태그가 이미 있으므로 우선적 처리.

### 2. 발화 단위 분리

각 파일을 발화(utterance) 단위로 나눔:
- 화자 태그 있으면 (`P1:`, `Moderator:` 등) 그 기준
- 없으면 문단(빈 줄) 기준
- 각 발화에 `{file, line_start, line_end, speaker, text}` 메타 부여

### 3. 프레임 태깅

각 발화를 6개 프레임 중 **하나 이상** 에 매핑. 한 발화가 여러 프레임에 걸치는 것도 정상.

**태깅 원칙 (중요)**:
- **애매하면 태깅하지 않는다.** 강제 매핑 금지.
- **Emotion 은 명시적 감정어 있을 때만.** LLM 은 감정을 과잉 감지하는 경향이 있으므로 보수적으로.
  - OK: "너무 짜증났어요", "뿌듯했죠"
  - NOT OK: "그냥 발라봤어요" (감정 아님)
- **Learning 은 신념/인식 변화 시그널이 명시된 경우만.**
  - OK: "이제 성분표부터 보게 되더라구요", "그때 알았어요"
  - NOT OK: 단순 정보 획득 ("~라고 하더라구요")
- 발화가 짧아 판단 불가능하면 skip.

### 4. findings JSON 생성

`analysis/findings_6frame.json` 저장:

```json
{
  "meta": {
    "generated_at": "ISO8601",
    "source_files": ["transcripts/p01.txt", "..."],
    "total_utterances": 245,
    "tagged_utterances": 187,
    "tagging_coverage": 0.76
  },
  "frames": {
    "S": [
      {
        "participant": "P1",
        "file": "transcripts/p01.txt",
        "line": 12,
        "speaker": "P1",
        "quote": "저는 아기 있는 30대 워킹맘이라...",
        "confidence": "high"
      }
    ],
    "T": [ /* ... */ ],
    "A": [ /* ... */ ],
    "O": [ /* ... */ ],
    "E": [ /* ... */ ],
    "L": [ /* ... */ ]
  }
}
```

### 5. 요약 리포트 생성

`analysis/REPORT_6frame.md` 생성. 템플릿은 `report_template.md` 참조.

기본 구성:
- 프레임별 발화 수 · 태깅 커버리지
- 각 프레임 대표 인용 3~5개 (인용, 참여자, 파일 위치)
- 크로스-프레임 패턴 (예: T→A→O 시퀀스가 자주 나오는 조합)

## 산출물

- `analysis/findings_6frame.json` — 전체 태깅 (기계 판독)
- `analysis/REPORT_6frame.md` — 사람 판독용 요약

## 관련 스킬 (예정)

- `pxd-quote-extract` — 특정 주제어로 인용문 검색
- `pxd-journey-map` — 6프레임 → 저널맵 시각화

## 참고

이 프로토콜은 pxd 리서치 팀 표준. 프레임 정의 변경이나 태깅 원칙 개선은 PR 로 제안 → 시니어 리뷰 → 머지되면 `git log skills/pxd-6frame/` 에 방법론 진화가 기록됨.
