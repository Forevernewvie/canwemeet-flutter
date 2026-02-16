# Google Play 릴리즈 (GitHub Actions)

대상: 한국/한국어만, 광고: AdMob 배너만, 결제/구독 없음

이 레포는 다음 워크플로를 사용합니다.

- CI: PR / main 푸시 시 `flutter analyze`, `flutter test` 실행
- CD: 태그(`v*`) 푸시 또는 수동 실행 시
  - 서명된 AAB 빌드
  - Play Console Internal track 업로드

릴리즈 노트(한국어)는 아래 파일을 사용합니다(업로드 전 필요하면 수정).

- `distribution/whatsnew/whatsnew-ko-KR`

Play 스토어 아이콘(512x512)은 아래 파일을 사용하세요.

- `distribution/store_icon_512.png`

정책 입력값(현재 기준):

- 고객지원 이메일: `dlfjs351@gmail.com`
- 개인정보처리방침 URL: `https://github.com/Forevernewvie/canwemeet-flutter/blob/main/docs/PRIVACY_POLICY_KO.md`

## 1) GitHub Actions 파일

- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`

현재 워크플로는 Flutter `3.41.1`로 고정되어 있습니다. Flutter 업그레이드 시 두 워크플로의 `flutter-version`도 같이 업데이트하세요.

## 2) 사전 준비 (Play Console)

1. Play Console에서 앱 생성(패키지명/앱 이름/기본 스토어 정보).
2. Internal testing 트랙을 활성화.
3. (중요) 패키지가 Play Console에 존재해야 API 업로드가 됩니다.
   - 액션에서 "Package not found"가 뜨면, 콘솔에서 최소 1회 AAB/APK를 수동 업로드로 생성해두세요.

## 3) 업로드 키(keystore) 생성

로컬(개발 PC)에서 업로드 키를 생성합니다. 이 파일은 절대 Git에 커밋하지 않습니다.
(`android/key.properties`는 release 빌드에 필수이며, GitHub Actions에서는 Secrets로부터 런타임에 생성됩니다.)

```bash
keytool -genkeypair -v \
  -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

### base64 변환 (Secrets 저장용)

macOS:

```bash
base64 -i upload-keystore.jks -o upload-keystore.jks.b64
```

Linux:

```bash
base64 -w 0 upload-keystore.jks > upload-keystore.jks.b64
```

## 4) Google Play Developer API + 서비스계정

1. Google Cloud에서 프로젝트 선택(또는 생성).
2. **Google Play Android Developer API**(androidpublisher) 활성화.
3. 서비스계정 생성 후 JSON 키 발급.
4. Play Console -> 사용자 및 권한에서 서비스계정 이메일을 초대하고,
   앱 권한(Internal 업로드 가능 권한)을 부여합니다.

## 5) GitHub Secrets 설정 (필수)

레포 Settings -> Secrets and variables -> Actions -> New repository secret.

필수(이 이름 그대로):

- `ANDROID_UPLOAD_KEYSTORE_BASE64`: `upload-keystore.jks.b64` 내용(문자열)
- `ANDROID_KEYSTORE_PASSWORD`: keystore 비밀번호
- `ANDROID_KEY_ALIAS`: 보통 `upload`
- `ANDROID_KEY_PASSWORD`: key 비밀번호(보통 keystore 비밀번호와 동일)
- `PLAY_SERVICE_ACCOUNT_JSON`: 서비스계정 JSON 전체를 그대로 넣기(권장)
  - (대안) JSON을 base64로 저장해도 됨. 워크플로가 JSON/BASE64를 자동 감지합니다.

## 6) 릴리즈 실행 방법

### A) 태그로 릴리즈 (권장)

```bash
git tag v1.0.0
git push origin v1.0.0
```

- `v1.0.0` -> `versionName=1.0.0`
- `versionCode`는 `run_number * 10 + run_attempt`로 자동 증가
- 업로드 트랙: internal
- status: draft

### B) 수동 실행 (workflow_dispatch)

GitHub -> Actions -> `Release (Play Internal)` -> Run workflow

- `version`을 비워두면 pubspec.yaml의 `version:`(예: 1.0.0)을 사용합니다.
- status는 기본 `draft` 입니다.

## 7) 제출 전 체크리스트(요약)

- Play Console 앱 생성/기본 정보/콘텐츠 등급 설문 완료
- Internal track 업로드 성공 + 내부 테스트 설치 가능
- AdMob 배너만 노출 + UMP 동의 전 광고 요청 차단 확인
- 개인정보처리방침 URL/고객지원 이메일 입력 + 데이터 안전/광고 선언 작성
