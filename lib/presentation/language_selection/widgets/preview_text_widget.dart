import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PreviewTextWidget extends StatelessWidget {
  final String selectedLanguageCode;

  const PreviewTextWidget({
    Key? key,
    required this.selectedLanguageCode,
  }) : super(key: key);

  String _getPreviewText() {
    switch (selectedLanguageCode) {
      case 'en':
        return 'Preview: "Incoming call from +1 555-0123. Caller states: I\'m calling about your insurance policy renewal."';
      case 'tr':
        return 'Önizleme: "+90 555 0123 numarasından gelen arama. Arayan kişi: Sigorta poliçenizin yenilenmesi hakkında arıyorum."';
      case 'fr':
        return 'Aperçu: "Appel entrant de +33 1 23 45 67 89. L\'appelant déclare: J\'appelle concernant le renouvellement de votre police d\'assurance."';
      case 'de':
        return 'Vorschau: "Eingehender Anruf von +49 30 12345678. Anrufer sagt: Ich rufe wegen der Erneuerung Ihrer Versicherungspolice an."';
      default:
        return 'Preview: "Incoming call from +1 555-0123. Caller states: I\'m calling about your insurance policy renewal."';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'preview',
                color: AppTheme.primaryOrange,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                'Interface Preview',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.primaryOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            _getPreviewText(),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
