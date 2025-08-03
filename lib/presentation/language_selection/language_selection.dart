import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_header_widget.dart';
import './widgets/continue_button_widget.dart';
import './widgets/language_card_widget.dart';
import './widgets/preview_text_widget.dart';
import './widgets/voice_recognition_toggle_widget.dart';

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({Key? key}) : super(key: key);

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  String _selectedLanguageCode = '';
  bool _voiceRecognitionOptimization = true;
  bool _showDifferentVoiceOption = false;

  final List<Map<String, dynamic>> _languages = [
    {
      'code': 'en',
      'name': 'English',
      'nativeName': 'English',
      'flag': '🇺🇸',
    },
    {
      'code': 'tr',
      'name': 'Turkish',
      'nativeName': 'Türkçe',
      'flag': '🇹🇷',
    },
    {
      'code': 'fr',
      'name': 'French',
      'nativeName': 'Français',
      'flag': '🇫🇷',
    },
    {
      'code': 'de',
      'name': 'German',
      'nativeName': 'Deutsch',
      'flag': '🇩🇪',
    },
  ];

  void _selectLanguage(String languageCode) {
    setState(() {
      _selectedLanguageCode = languageCode;
      _showDifferentVoiceOption = true;
    });
    HapticFeedback.selectionClick();
  }

  void _toggleVoiceRecognition(bool value) {
    setState(() {
      _voiceRecognitionOptimization = value;
    });
  }

  void _continueToNextScreen() {
    if (_selectedLanguageCode.isNotEmpty) {
      HapticFeedback.lightImpact();
      Navigator.pushNamed(context, '/ai-service-configuration');
    }
  }

  String _getSelectedLanguageName() {
    final selectedLang = _languages.firstWhere(
      (lang) => (lang['code'] as String) == _selectedLanguageCode,
      orElse: () => {'name': 'English'},
    );
    return selectedLang['name'] as String;
  }

  String _getSettingsText() {
    switch (_selectedLanguageCode) {
      case 'tr':
        return 'Dil ayarları daha sonra Ayarlar menüsünden değiştirilebilir.';
      case 'fr':
        return 'Les paramètres de langue peuvent être modifiés ultérieurement dans les Paramètres.';
      case 'de':
        return 'Spracheinstellungen können später in den Einstellungen geändert werden.';
      default:
        return 'Language settings can be changed later in Settings.';
    }
  }

  String _getDifferentVoiceText() {
    switch (_selectedLanguageCode) {
      case 'tr':
        return 'Farklı bir ses tanıma dili kullanmak istiyor musunuz?';
      case 'fr':
        return 'Souhaitez-vous utiliser une langue de reconnaissance vocale différente?';
      case 'de':
        return 'Möchten Sie eine andere Spracherkennungssprache verwenden?';
      default:
        return 'Want to use a different voice recognition language?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header with DEACON AI branding
          const AppHeaderWidget(),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3.h),

                  // Title and description
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose Your Language',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Select your preferred interface language and voice recognition settings for optimal call screening experience.',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Language selection cards
                  ...(_languages
                      .map((language) => LanguageCardWidget(
                            languageCode: language['code'] as String,
                            languageName: language['name'] as String,
                            nativeName: language['nativeName'] as String,
                            flagEmoji: language['flag'] as String,
                            isSelected:
                                _selectedLanguageCode == language['code'],
                            onTap: () =>
                                _selectLanguage(language['code'] as String),
                          ))
                      .toList()),

                  SizedBox(height: 2.h),

                  // Voice recognition optimization toggle
                  if (_selectedLanguageCode.isNotEmpty) ...[
                    VoiceRecognitionToggleWidget(
                      isEnabled: _voiceRecognitionOptimization,
                      selectedLanguage: _getSelectedLanguageName(),
                      onToggle: _toggleVoiceRecognition,
                    ),

                    // Preview text
                    PreviewTextWidget(
                      selectedLanguageCode: _selectedLanguageCode,
                    ),

                    // Different voice recognition language option
                    if (_showDifferentVoiceOption) ...[
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        child: TextButton.icon(
                          onPressed: () {
                            // Show language picker for voice recognition
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              builder: (context) => Container(
                                padding: EdgeInsets.all(4.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Voice Recognition Language',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    ...(_languages
                                        .map((lang) => ListTile(
                                              leading: Text(
                                                lang['flag'] as String,
                                                style:
                                                    TextStyle(fontSize: 18.sp),
                                              ),
                                              title:
                                                  Text(lang['name'] as String),
                                              subtitle: Text(
                                                  lang['nativeName'] as String),
                                              onTap: () =>
                                                  Navigator.pop(context),
                                            ))
                                        .toList()),
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: CustomIconWidget(
                            iconName: 'settings_voice',
                            color: AppTheme.primaryOrange,
                            size: 18,
                          ),
                          label: Text(
                            _getDifferentVoiceText(),
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.primaryOrange,
                            ),
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: 2.h),

                    // Settings note
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info_outline',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              _getSettingsText(),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Continue button
                    ContinueButtonWidget(
                      selectedLanguageCode: _selectedLanguageCode,
                      onPressed: _continueToNextScreen,
                      isEnabled: _selectedLanguageCode.isNotEmpty,
                    ),
                  ],

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
