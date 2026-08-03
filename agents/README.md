# pxd-labs 서브에이전트

이 폴더의 각 `.md` 파일은 Claude Code 의 **서브에이전트**로 등록됩니다.
install.sh 가 `~/.claude/agents/<name>.md` 로 심링크합니다.

## 최소 문법

```markdown
---
name: pxd-agent-name
description: 이 에이전트가 무엇을 하는지 한 문장.
tools: Bash, Read, Grep    # 이 에이전트가 쓸 수 있는 도구만 명시
---

# 에이전트 이름

## 페르소나
... 시스템 프롬프트 역할의 본문 ...

## 실행 절차
...
```

## 언제 서브에이전트를 만드나

- **컨텍스트를 격리**하고 싶을 때 (본 세션 오염 방지)
- **특정 페르소나/톤** 이 필요할 때 (평론가, 인터뷰어, 어드보캇 등)
- **일부 도구만 허용**하고 싶을 때 (예: read-only 리뷰어)
- **병렬 실행**하고 싶을 때 (여러 관점을 동시에)

## 이 폴더의 예시

- `pxd-food-critic.md` — 팀 음식 취향을 미슐랭 톤으로 리뷰 (온보딩 답변 활용)

## 앞으로 추가 예정 (예시)

- `pxd-interview-tagger.md` — 트랜스크립트 6프레임 태깅
- `pxd-quote-extractor.md` — 인용문 발췌 전문
- `pxd-report-reviewer.md` — 리포트 초안 코멘터리
