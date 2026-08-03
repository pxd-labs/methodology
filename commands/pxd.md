---
description: pxd 온보딩 설문 답변을 저장합니다. 사용법 `/pxd <답변 내용>`
argument-hint: "<이름/나이/취미/음식/영화/MBTI 자유 형식>"
---

# pxd — 온보딩 설문 답변 저장

pxd 신입 온보딩 설문의 답변을 저장합니다. (설문 문항은 이 플러그인의 `onboarding.md` 참조)

## 입력

- `$ARGUMENTS` — 다음 6개 항목이 포함된 답변 텍스트 (자유 형식):
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

6개 필드 중 하나라도 빠지면 저장하지 말고, 어떤 필드가 빠졌는지 알려주고 다시 요청.

### 3. 저장

- 저장 폴더: `~/pxd-onboarding-responses/` (이 폴더는 private git repo `chrislee-cmd/pxd-responses` 의 clone)
- 폴더가 없으면 안내: "install.sh 를 먼저 실행해서 응답 저장소를 clone 하세요"
- 파일명: `<이름>.md` (예: `홍길동.md`)
- 이미 같은 이름의 파일이 있으면 사용자에게 덮어쓸지 물어봄

### 4. 파일 형식

```markdown
# 온보딩 응답 — <이름>

- **제출 일시**: <YYYY-MM-DD HH:MM>
- **이름**: <이름>
- **나이**: <나이>
- **취미**: <취미>
- **좋아하는 음식**: <음식>
- **좋아하는 영화**: <영화>
- **MBTI**: <mbti>

## 원본 응답

> <$ARGUMENTS 원문 그대로>
```

### 5. Git 커밋 + 푸시 (auto-sync)

파일 저장 직후 응답 저장소로 자동 push:

```bash
cd ~/pxd-onboarding-responses
git pull --ff-only         # 혹시 다른 팀원이 새 응답 push 했을 수 있음
git add "<이름>.md"
git commit -m "온보딩 응답: <이름>"
git push
```

push 실패 시 (충돌·네트워크 문제): 로컬에는 저장됐음을 알리고, 사용자에게 수동 해결 안내.

## 보고 형식

저장 + push 완료 후 다음 형식으로 보고:

```
✓ 온보딩 응답 저장 완료
- 이름: <이름>
- 파일: ~/pxd-onboarding-responses/<이름>.md
- GitHub 푸시: ✓ chrislee-cmd/pxd-responses
- 현재까지 저장된 응답: N명
```

`ls ~/pxd-onboarding-responses/*.md | grep -v README | wc -l` 로 전체 응답 수 확인 (README 제외).

## 특이 케이스

- **인자가 비어 있음**: pxd 온보딩 설문 안내를 보여주고 종료.
- **필드 누락**: 어떤 필드가 빠졌는지 명시하고 다시 입력받기.
- **MBTI 형식 이상**: 4글자 알파벳(예: INTJ)이 아니면 확인 요청.
