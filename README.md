# pxd-labs / methodology

Claude Code 하네스 실습용 방법론 저장소.

## 아키텍처

```
[아무 기기] ─► /pxd <답변>     ─► HTTP POST ─► pxd-api.vercel.app ─► Upstash Redis
[아무 기기] ─► /pxd-lunch      ─► HTTP GET  ─► pxd-api.vercel.app ─► Upstash Redis
```

**GitHub 인증 필요 없음.** 청중 전원이 install 즉시 실시간 공유 참여 가능.

## 이 저장소에 들어있는 것

- **`commands/pxd.md`** — `/pxd <답변>` (API POST + 로컬 백업)
- **`commands/pxd-lunch.md`** — `/pxd-lunch` (API GET + 랜덤 pick)
- **`onboarding.md`** — 신입 설문 안내
- **`install.sh`** — 원클릭 설치 스크립트

## 설치 (한 줄)

**Mac / Linux / WSL / Git Bash**:
```bash
curl -fsSL https://raw.githubusercontent.com/pxd-labs/methodology/main/install.sh | bash
```

**Windows (PowerShell)**:
```powershell
irm https://raw.githubusercontent.com/pxd-labs/methodology/main/install.ps1 | iex
```

전제조건: `git`, `curl`, `claude` CLI 만 있으면 됨. GitHub 로그인 불필요.

Windows 팁: symlink 는 Developer Mode 활성화 시 정상 동작 (Settings → Privacy & Security → For developers → Developer Mode 켜기). 비활성화 상태면 파일 복사로 대체되며, 방법론 업데이트 시 `install.ps1` 재실행 필요.

## 사용

```
/pxd 이름 김철수, 나이 28, 취미 러닝, 좋아하는 음식 파스타, 좋아하는 영화 라라랜드, MBTI ENFP
```

응답은 Vercel API 로 즉시 전송되어 `pxd-api.vercel.app` 의 Redis 에 저장됩니다.
로컬 백업은 `~/pxd-responses/<이름>.md` 로도 저장 (네트워크 실패 대비).

```
/pxd-lunch
```

전체 팀원의 좋아하는 음식 리스트 + 오늘의 랜덤 추천 표시.

## 관련 저장소

- **`pxd-labs/methodology`** ← 이 저장소
- **`pxd-labs/responses`** — (구) git 기반 응답 저장소, deprecated
- **`pxd-labs/raw-data`** — 향후 인터뷰 원본 데이터용

## 개선 제안

`commands/` 아래 새 `.md` 하나 만들어 PR 올리면 됩니다. 머지되면 팀은 다음 `bash install.sh` 로 자동 수신.
