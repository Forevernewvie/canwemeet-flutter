/// Centralized user-facing text constants for newly added features.
///
/// Keeping messages in one place avoids hardcoded duplicates and simplifies
/// future localization or policy updates.
abstract final class FeatureTexts {
  static const String sendModeSectionTitle = '실전 전송 모드';
  static const String sendModePreviewTitle = '보낼 문장';
  static const String sendModeCopyButton = '복사';
  static const String sendModeShareButton = '공유';
  static const String sendModeCopiedSnackbar = '문장을 복사했어요.';

  static const String toneNatural = 'Natural';
  static const String toneSofter = 'Softer';
  static const String toneDirect = 'More direct';

  static const String reminderCardTitle = '복습 리마인더';
  static const String reminderCardBadge = 'Daily reminder';
  static const String reminderToggleTitle = '매일 복습 알림';
  static const String reminderToggleSubtitle = '오늘 복습량을 기준으로 알림 문구가 바뀌어요.';
  static const String reminderTimeTitle = '리마인더 시간';

  static const String reminderToggleOnMessage = '복습 리마인더를 켰어요.';
  static const String reminderToggleOffMessage = '복습 리마인더를 껐어요.';
  static const String reminderPermissionDeniedMessage =
      '알림 권한이 꺼져 있어요. 시스템 설정에서 알림을 허용해 주세요.';

  /// Builds the reminder card subtitle with the selected local time.
  static String reminderCardSubtitle(String formattedTime) {
    return '매일 $formattedTime에 복습 알림을 보냅니다.\n알림은 설정에서 언제든지 끌 수 있어요.';
  }

  /// Builds snackbar text after reminder time update.
  static String reminderTimeUpdatedMessage(String formattedTime) {
    return '리마인더 시간을 $formattedTime로 설정했어요.';
  }
}
