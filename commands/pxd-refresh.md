---
description: pxd 방법론(commands · agents · skills) 을 최신 버전으로 sync. 팀원이 새 스킬을 push 했을 때 실행.
argument-hint: "(인자 없음)"
---

# pxd-refresh — 방법론 최신화

`~/pxd-methodology` 를 GitHub 최신본으로 pull 하고, install.sh 로 심링크를 재구성합니다.

## 실행 단계

### 1. install.sh 실행

```bash
bash ~/pxd-methodology/install.sh 2>&1
```

install.sh 가 자동으로 다음을 수행:
- `git -C ~/pxd-methodology pull --ff-only` (최신 methodology 가져오기)
- `commands/*.md` 심링크 재구성
- `agents/*.md` 심링크 재구성
- `skills/*/` 심링크 재구성

### 2. 변경사항 요약

실행 후 다음 정보를 사용자에게 표시:

- **새로 추가된 커맨드 / 에이전트 / 스킬**: install.sh 출력의 `✓ ... linked` 라인 파싱
- **methodology 최신 커밋 3개**: `git -C ~/pxd-methodology log --oneline -3` 결과

### 3. 새 세션 안내

**이미 열린 Claude 세션에서도 대부분 즉시 반영**되지만, 완전한 인식을 위해선 새 `claude` 세션을 여는 게 확실함을 알림.

## 보고 형식 예시

```
✓ pxd 방법론 최신화 완료

새로 등록된 것:
  - skills/pxd-emotional-journey (신규)
  - commands/pxd-tag.md (신규)

최근 methodology 커밋:
  c402ad7  Add pxd-6frame skill
  ac4e873  Two-layer validation
  2bdf8d8  install.sh: skip README.md
```

## 특이 케이스

- **오프라인**: git pull 실패해도 install.sh 는 로컬 재심링크는 수행. 그 경우 "네트워크 미연결, 로컬 상태 유지" 로 안내.
- **처음 실행 (methodology 폴더 없음)**: install.sh 가 알아서 초기 clone. "pxd 방법론 최초 설치됨" 으로 알림.
- **conflict (로컬 변경 있음)**: git pull --ff-only 가 실패. 사용자에게 `~/pxd-methodology` 에 로컬 편집이 있으니 커밋/스태시 필요하다고 안내.


## 응답 톤 · 비개발자용 일반어

이 커맨드/스킬 실행 시 응답은 **비개발자 (UX 리서처 · 기획자 · 고등학생 수준 배경지식)** 을 대상으로 소통한다. 개발자 용어는 즉시 일반어로 풀어서 씀:

- push · 푸시 → **올리기** · **저장**
- commit · 커밋 → **기록**
- repository · 레포 → **저장소**
- pull · 풀 → **가져오기** · **최신화**
- symlink · 심링크 → **연결**
- endpoint · API 호출 → **주소** · **서버 요청**
- 401 · auth error → **권한 문제**
- payload · JSON → **보낸 내용** · **받은 내용**
- script · 파이프라인 → **자동 처리 순서**
- symlink 실패 · fallback → **연결 대신 파일 복사됨**

전문용어를 꼭 써야 하면 괄호로 한글 뜻 병기. 예: "이건 심링크(연결)로 걸어놨어요".
어색한 일본식 · 직역식 표현 대신 자연스러운 대화체 한국어.
"~한 것으로 보입니다" 대신 "~하는 것 같아요" 같은 편안한 말투.
