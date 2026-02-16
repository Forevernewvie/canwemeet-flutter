# 우리 제법 잘 어울려 (Flutter)

영어권 연인과 대화가 막힐 때, **매일 문장 3개 + 패턴 3개**를 제공하고 발음/저장/복습을 지원하는 앱을 Flutter로 포팅하는 프로젝트입니다.

## 현재 구현 범위 (MVP)

- Onboarding: 캐러셀(PageView) + `건너뛰기`
- Root: 3 탭 (Today / Explore / My)
- Today: 포커스(상황) 선택 + (큐레이션 1개 + 추가 추천 2개) + 패턴 3개
- Sentence Detail: 라우팅/뼈대(상세 로딩/즐겨찾기/발음 연동은 확장 예정)
- 광고: AdMob 배너 + UMP 동의 플로우
- AI 기능: 서버 연동 전 준비 중 안내

## 기술 스택

- Flutter `3.41.1` / Dart `3.11.0`
- State: `flutter_riverpod`
- Routing: `go_router`
- Storage: `shared_preferences` (온보딩 완료/설치일)
- Cache: `path_provider` + 파일 캐시 (런타임), 테스트는 `MemoryCache`
- TTS: `flutter_tts` (연동 예정)
- Ads: `google_mobile_ads` (배너만 사용)
- Deterministic selection: `crypto` + `Random(seed)`

## 프로젝트 구조

```text
lib/
  app/                 # App, router, theme
  core/
    content/           # ContentStore(bundle->cache) + selection helpers
    persistence/       # preferences, cache abstraction
    tts/               # tts service (placeholder)
  domain/
    models/            # Sentence/Pattern models
    usecases/          # TodayPackUseCase
  features/            # 8 screens (feature-first)
  ui_components/       # reusable UI
assets/
  data/                # JSON datasets
test/                  # lean tests (determinism, curated phase, routing)
```

## 데이터셋

- `assets/data/sentences_v1.json` (1000)
- `assets/data/curated_sentences_200_v1.json` (200)
- `assets/data/patterns_v1.json` (24)

## 시작하기

### Requirements

- Flutter SDK (stable) installed
- Xcode installed (iOS run)

### Install

```bash
flutter pub get
```

### Run (iOS Simulator)

```bash
flutter run
```

### Quality Gates

```bash
dart format .
flutter analyze
flutter test -j 1
```

## 출시 기준 값 (Google Play)

- 패키지명(`applicationId`): `com.ourmatchwell.ourmatchwell_flutter`
- AdMob App ID(Android): `ca-app-pub-9780094598585299~9220627585`
- AdMob Banner Unit ID(Android): `ca-app-pub-9780094598585299/6706144880`
- 고객지원 이메일: `dlfjs351@gmail.com`
- 개인정보처리방침: `https://github.com/Forevernewvie/canwemeet-flutter/blob/main/docs/PRIVACY_POLICY_KO.md`

## Git Worktree 병렬 작업 (추천)

원리: **하나의 git 레포**에서 **브랜치별로 작업 디렉토리를 분리**해 동시에 작업/빌드/테스트를 수행합니다.

권장 규칙:

- 동시에 활성 worktree는 최대 2~3개만 유지
- 머지 완료 시 worktree 제거 + 브랜치 정리

예시:

```bash
cd /path/to/OurMatchWellFlutter
git fetch origin

WT_ROOT=/path/to/OurMatchWellFlutter-wt
mkdir -p "$WT_ROOT"

git worktree add -b codex/core-content  "$WT_ROOT/core-content"  origin/main
git worktree add -b codex/ui-shell      "$WT_ROOT/ui-shell"      origin/main
git worktree add -b codex/release-hardening "$WT_ROOT/release-hardening" origin/main

git worktree list
```

정리:

```bash
git worktree remove "$WT_ROOT/core-content"
git branch -d codex/core-content
```

## Stub/미구현 항목

- AI 대화 서버 API (현재는 준비 중 안내)
- 원격 업데이트(manifest) 네트워크 구현 (현재 manifest client는 stub)
