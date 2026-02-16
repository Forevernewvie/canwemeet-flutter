# Play Console 데이터 안전/광고 선언 체크리스트

기준: 현재 앱 상태(AdMob 배너, 결제/구독 없음, AI 서버 연동 없음)

## 1) 광고 포함 선언
- 광고 포함 여부: 예
- 광고 유형: 배너만
- 전면/리워드/네이티브/미디에이션/파트너 입찰: 사용 안 함

## 2) 데이터 안전 답변 준비
- 앱에서 수집하는 데이터: AdMob SDK를 통한 광고 게재/성과 측정 데이터(광고 ID, IP/기기 정보, 진단 정보 등) 처리 가능
- 수집 목적: 광고 게재/앱 기능 제공(동의 기반)
- 데이터 공유 여부: 예 (광고 네트워크 처리 목적, Google AdMob SDK 경유)
- 데이터 삭제 요청 방법: 고객지원 이메일 접수(`dlfjs351@gmail.com`)
- 전송 중 암호화: 예(HTTPS)
- 개인정보처리방침 URL: https://github.com/Forevernewvie/canwemeet-flutter/blob/main/docs/PRIVACY_POLICY_KO.md

## 3) UMP/개인정보 동의
- 동의 전 광고 요청 금지: 적용됨
- 동의 상태 표시(Required/Not required/Obtained/Unknown): 설정 화면에서 확인 가능
- Privacy Options 진입 버튼: 설정 화면에 노출

## 4) 출시 전 최종 확인
- Play Console 앱 콘텐츠 설문 완료 (콘솔에서 수동 체크 필요)
- 개인정보처리방침 URL 공개 상태 확인 (완료)
- 고객지원 이메일 등록 확인 (완료)
- 내부 테스트 트랙에서 광고 노출/비노출 동작 확인 (콘솔 업로드 후 수동 체크 필요)
