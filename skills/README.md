# pxd-labs 스킬

이 폴더의 각 하위 디렉토리는 Claude Code 의 **스킬**로 등록됩니다.
install.sh 가 `~/.claude/skills/<name>` 로 심링크합니다.

## 폴더 구조

```
skills/
├── README.md            ← 이 파일 (심링크되지 않음)
└── <skill-name>/
    └── SKILL.md         ← 필수. 프론트매터에 name/description
```

## 최소 예시

```
skills/pxd-6frame/
└── SKILL.md
```

`SKILL.md`:

```markdown
---
name: pxd-6frame
description: pxd 6프레임 분석 프로토콜. 인터뷰 트랜스크립트가 열려있을 때 자동 발동.
---

# pxd 6프레임 분석

## 프레임
1. Situation
2. Trigger
3. Action
4. Outcome
5. Emotion
6. Learning

## 절차
...
```

## 언제 스킬을 만드나

- **여러 프로젝트에서 반복 사용**하는 리서치 방법론
- 특정 파일 타입/컨텍스트에 자동 발동해야 하는 워크플로우
- 팀 전체가 동일한 프로토콜을 공유해야 하는 경우

## 앞으로 추가 예정 (예시)

- `pxd-6frame/` — 6프레임 분석 프로토콜
- `pxd-journey-map/` — 저널맵 자동 생성
- `pxd-quote-extract/` — 트랜스크립트에서 인용문 추출

새 스킬 추가하면 다음 push 로 팀 전체에 배포됨.
