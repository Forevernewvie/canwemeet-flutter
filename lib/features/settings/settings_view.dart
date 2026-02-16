import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/ads/consent/consent_controller.dart';
import '../../ui_components/app_surfaces.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consent = ref.watch(consentControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            title: 'AI 기능',
            subtitle: '현재 준비 중입니다. 서버 연동 후 업데이트로 제공될 예정이에요.',
            badges: const ['결제 없음'],
          ),
          const SizedBox(height: 22),
          AppCard(
            title: '광고/개인정보(UMP)',
            subtitle:
                '상태: ${consent.statusLabel}\n광고 요청 가능: ${consent.canRequestAds ? '예' : '아니오'}\nPrivacy Options 필요: ${consent.isPrivacyOptionsRequired ? '예' : '아니오'}',
            badges: const ['AdMob 배너만', '동의 전 광고 요청 금지'],
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () async {
              final ok = await ref
                  .read(consentControllerProvider.notifier)
                  .showPrivacyOptionsForm();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(ok ? '동의 설정을 열었어요.' : '동의 설정을 열 수 없어요.'),
                ),
              );
            },
            child: const Text('동의 설정 열기 (Privacy Options)'),
          ),
          if ((consent.lastError ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              '동의 오류: ${consent.lastError}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.accent),
            ),
          ],
          if (kDebugMode) ...[
            const SizedBox(height: 22),
            AppCard(
              title: '디버그 동의 도구',
              subtitle: '릴리즈에는 포함되지 않습니다. EEA 강제 테스트와 동의 초기화를 제공합니다.',
              badges: const ['kDebugMode only'],
            ),
            const SizedBox(height: 10),
            SwitchListTile.adaptive(
              value: consent.debugForceEea,
              onChanged: (enabled) async {
                final ok = await ref
                    .read(consentControllerProvider.notifier)
                    .setDebugForceEea(enabled);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok ? 'EEA 디버그 강제 상태를 변경했어요.' : '변경 실패'),
                  ),
                );
              },
              title: const Text('EEA 디버그 강제'),
              subtitle: const Text('동의 폼 테스트용'),
            ),
            ListTile(
              title: const Text('테스트 디바이스 해시'),
              subtitle: Text(consent.debugDeviceHash ?? '불러오는 중...'),
              trailing: IconButton(
                icon: const Icon(Icons.copy_rounded),
                onPressed: consent.debugDeviceHash == null
                    ? null
                    : () async {
                        await Clipboard.setData(
                          ClipboardData(text: consent.debugDeviceHash!),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('해시를 복사했어요.')),
                        );
                      },
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () async {
                final ok = await ref
                    .read(consentControllerProvider.notifier)
                    .resetConsent();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ok ? '동의를 초기화했어요.' : '초기화 실패')),
                );
              },
              child: const Text('동의 리셋'),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            '개인정보처리방침: https://github.com/Forevernewvie/canwemeet-flutter/blob/main/docs/PRIVACY_POLICY_KO.md\n고객지원: dlfjs351@gmail.com',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.subText),
          ),
        ],
      ),
    );
  }
}
