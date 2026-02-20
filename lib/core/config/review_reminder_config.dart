/// Stable notification identifier used to keep one daily reminder instance.
const int reviewReminderNotificationId = int.fromEnvironment(
  'REVIEW_REMINDER_NOTIFICATION_ID',
  defaultValue: 41_001,
);

/// Default reminder hour in 24-hour format.
const int reviewReminderDefaultHour = int.fromEnvironment(
  'REVIEW_REMINDER_DEFAULT_HOUR',
  defaultValue: 21,
);

/// Default reminder minute.
const int reviewReminderDefaultMinute = int.fromEnvironment(
  'REVIEW_REMINDER_DEFAULT_MINUTE',
  defaultValue: 0,
);

/// Android notification channel id for review reminders.
const String reviewReminderChannelId = String.fromEnvironment(
  'REVIEW_REMINDER_CHANNEL_ID',
  defaultValue: 'daily_review_channel',
);

/// Human-readable Android notification channel name.
const String reviewReminderChannelName = String.fromEnvironment(
  'REVIEW_REMINDER_CHANNEL_NAME',
  defaultValue: 'Daily Review Reminder',
);

/// Android notification channel description.
const String reviewReminderChannelDescription = String.fromEnvironment(
  'REVIEW_REMINDER_CHANNEL_DESCRIPTION',
  defaultValue: 'Reminds the user to complete daily review.',
);

/// Notification title shown for review reminders.
const String reviewReminderNotificationTitle = String.fromEnvironment(
  'REVIEW_REMINDER_NOTIFICATION_TITLE',
  defaultValue: 'Daily Review',
);

/// Prefix for due-count reminder body text.
const String reviewReminderDueBodyPrefix = String.fromEnvironment(
  'REVIEW_REMINDER_DUE_BODY_PREFIX',
  defaultValue: 'You have ',
);

/// Suffix for due-count reminder body text.
const String reviewReminderDueBodySuffix = String.fromEnvironment(
  'REVIEW_REMINDER_DUE_BODY_SUFFIX',
  defaultValue: ' reviews due today.',
);

/// Fallback reminder body when due count is unavailable or zero.
const String reviewReminderFallbackBody = String.fromEnvironment(
  'REVIEW_REMINDER_FALLBACK_BODY',
  defaultValue: 'Take 3 minutes for your daily review.',
);

/// Payload attached to reminder notifications.
const String reviewReminderPayload = String.fromEnvironment(
  'REVIEW_REMINDER_PAYLOAD',
  defaultValue: 'daily_review',
);

/// Fallback timezone name used when local timezone lookup fails.
const String reviewReminderFallbackTimezone = String.fromEnvironment(
  'REVIEW_REMINDER_FALLBACK_TIMEZONE',
  defaultValue: 'UTC',
);
