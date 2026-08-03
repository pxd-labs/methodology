# pxd-labs / methodology

Claude Code 하네스 실습용 방법론 저장소. pxd-labs 조직의 세 저장소 중 하나:

- **`pxd-labs/methodology`** ← 이 저장소. 슬래시 커맨드 + 설문 템플릿 + install.sh
- **`pxd-labs/responses`** — 온보딩 응답 데이터 (public, PAT로 누구나 push 가능 — 시연용)
- **`pxd-labs/raw-data`** — 향후 인터뷰 원본 데이터용

## 이 저장소에 들어있는 것

- **`commands/pxd.md`** — `/pxd <답변>` 슬래시 커맨드
- **`commands/pxd-lunch.md`** — `/pxd-lunch` 팀원 선호 음식 조회
- **`onboarding.md`** — 신입 설문 안내
- **`install.sh`** — 원클릭 설치 스크립트

## 설치 (아무 기기든 한 줄)

```bash
curl -fsSL https://raw.githubusercontent.com/pxd-labs/methodology/main/install.sh | bash
```

이후 새 `claude` 세션에서 `/pxd` · `/pxd-lunch` 자동 등록.

## 사용

```
/pxd 이름 김철수, 나이 28, 취미 러닝, 좋아하는 음식 파스타, 좋아하는 영화 라라랜드, MBTI ENFP
```

응답 파일은 `~/pxd-responses/<이름>.md` 로 저장되고 **자동으로 GitHub (`pxd-labs/responses`) 로 push** 됩니다. 다른 기기에서 `/pxd-lunch` 실행 시 자동 pull 되어 즉시 반영.

## 시연용 보안 정책

`install.sh` 안에 fine-grained PAT 가 임베드돼있습니다. 이 토큰은:

- **스코프**: `pxd-labs` 조직의 모든 저장소에 `Contents: Read/Write` 만
- **불가능**: 저장소 삭제, 설정 변경, 다른 조직/개인 계정 접근
- **유출 시**: `github.com/settings/tokens` 에서 rotate → install.sh 업데이트 → 30초 복구

시연 종료 후 토큰을 만료시키거나 삭제하시면 이 방식은 종료됩니다.

## 개선 제안

`commands/` 아래 새 `.md` 파일 하나 만들어서 PR 올리면 됩니다. 머지되면 팀은 다음 `bash install.sh` 로 자동 수신.
