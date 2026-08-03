# pxd-playground

Claude Code 하네스 실습용 미니 플러그인 — pxd 신입 온보딩 설문 수집 워크플로우.

## 이 레포에 들어있는 것

- **`commands/pxd.md`** — `/pxd <답변>` 슬래시 커맨드 정의
- **`onboarding.md`** — 신입에게 배포하는 설문 안내 문서

## 팀원 설치 방법 (일회성 세팅)

```bash
# 1. 원하는 위치에 clone
git clone https://github.com/chrislee-cmd/pxd-playground.git ~/pxd-playground

# 2. commands 폴더의 커맨드를 Claude Code가 인식하도록 심링크
ln -s ~/pxd-playground/commands/pxd.md ~/.claude/commands/pxd.md
```

이후 아무 폴더에서 `claude` 실행 → `/pxd` 자동으로 뜸.

## 사용 예시

```
/pxd 이름 김철수, 나이 28, 취미 러닝, 좋아하는 음식 파스타, 좋아하는 영화 라라랜드, MBTI ENFP
```

답변은 `~/pxd-onboarding-responses/<이름>.md` 로 저장됩니다.

## 업데이트 받기

방법론이 개선되면 팀에 공지가 갑니다. 각자 한 번 pull:

```bash
cd ~/pxd-playground && git pull
```

## 개선 제안하기

새 워크플로우가 도움이 될 것 같으면 PR 하나 올려주세요. 시니어 리뷰 후 머지되면 팀 전체가 다음 pull에서 받습니다.
