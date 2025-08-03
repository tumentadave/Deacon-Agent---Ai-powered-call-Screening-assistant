import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/openai_service.dart';
import './widgets/language_flag_widget.dart';
import './widgets/settings_row_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/slider_setting_widget.dart';
import './widgets/status_indicator_widget.dart';
import './widgets/toggle_setting_widget.dart';
import './widgets/user_profile_widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
    "isPremium": true,
    "subscriptionExpiry": "2024-12-31",
  };

  // Mock settings state
  bool _callScreeningEnabled = true;
  bool _emergencyBypassEnabled = true;
  bool _screeningAlertsEnabled = true;
  bool _callSummariesEnabled = false;
  bool _systemNotificationsEnabled = true;
  bool _voiceRecordingEnabled = true;
  double _screeningSensitivity = 3.0;
  String _currentLanguage = "English";
  String _currentRegion = "United States";
  String _aiProvider = "OpenAI GPT-4";
  bool _aiServiceActive = true;
  int _blockedNumbersCount = 47;

  // OpenAI Integration
  bool _openAIConnected = false;

  @override
  void initState() {
    super.initState();
    _checkOpenAIConnection();
  }

  void _checkOpenAIConnection() {
    try {
      OpenAIService();
      setState(() {
        _openAIConnected = true;
        _aiServiceActive = true;
      });
    } catch (e) {
      setState(() {
        _openAIConnected = false;
        _aiServiceActive = false;
      });
    }
  }

  // Available languages
  final List<Map<String, String>> _languages = [
    {"code": "en", "name": "English"},
    {"code": "tr", "name": "Türkçe"},
    {"code": "fr", "name": "Français"},
    {"code": "de", "name": "Deutsch"},
  ];

  void _showLanguageSelection() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Language",
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ..._languages
                .map((lang) => ListTile(
                      leading: Text(
                        lang["code"] == "en"
                            ? "🇺🇸"
                            : lang["code"] == "tr"
                                ? "🇹🇷"
                                : lang["code"] == "fr"
                                    ? "🇫🇷"
                                    : "🇩🇪",
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(lang["name"]!),
                      trailing: _currentLanguage == lang["name"]
                          ? CustomIconWidget(
                              iconName: 'check',
                              color: AppTheme.primaryOrange,
                              size: 20,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _currentLanguage = lang["name"]!;
                        });
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showEmergencyBypassWarning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Emergency Bypass",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Disabling emergency bypass may prevent important calls from reaching you during emergencies. Are you sure?",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _emergencyBypassEnabled = false;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
            ),
            child: const Text("Disable"),
          ),
        ],
      ),
    );
  }

  void _showDeleteDataConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Delete All Data",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.accentRed,
          ),
        ),
        content: Text(
          "This will permanently delete all your call history, AI analysis data, and preferences. This action cannot be undone.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("All data has been deleted"),
                  backgroundColor: AppTheme.accentRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
            ),
            child: const Text("Delete All"),
          ),
        ],
      ),
    );
  }

  String _formatSensitivity(double value) {
    switch (value.round()) {
      case 1:
        return "Low";
      case 2:
        return "Medium-Low";
      case 3:
        return "Medium";
      case 4:
        return "Medium-High";
      case 5:
        return "High";
      default:
        return "Medium";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softOffWhite,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.deepSlate,
            size: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 1.h),

              // User Profile Section
              UserProfileWidget(userData: userData),

              // Call Screening Section
              SettingsSectionWidget(
                title: "CALL SCREENING",
                children: [
                  ToggleSettingWidget(
                    title: "Enable Call Screening",
                    subtitle: "Automatically screen incoming calls with AI",
                    initialValue: _callScreeningEnabled,
                    leading: CustomIconWidget(
                      iconName: 'phone_callback',
                      color: AppTheme.primaryOrange,
                      size: 24,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _callScreeningEnabled = value;
                      });
                    },
                  ),
                  SliderSettingWidget(
                    title: "Screening Sensitivity",
                    subtitle:
                        "How strict should the AI be when screening calls",
                    initialValue: _screeningSensitivity,
                    min: 1.0,
                    max: 5.0,
                    divisions: 4,
                    valueFormatter: _formatSensitivity,
                    onChanged: (value) {
                      setState(() {
                        _screeningSensitivity = value;
                      });
                    },
                  ),
                  ToggleSettingWidget(
                    title: "Emergency Bypass",
                    subtitle: "Allow emergency calls to bypass screening",
                    initialValue: _emergencyBypassEnabled,
                    leading: CustomIconWidget(
                      iconName: 'local_hospital',
                      color: AppTheme.accentRed,
                      size: 24,
                    ),
                    showDivider: false,
                    onChanged: (value) {
                      if (!value) {
                        _showEmergencyBypassWarning();
                      } else {
                        setState(() {
                          _emergencyBypassEnabled = value;
                        });
                      }
                    },
                  ),
                ],
              ),

              // AI Services Section
              SettingsSectionWidget(
                title: "AI SERVICES",
                children: [
                  SettingsRowWidget(
                    title: "AI Provider",
                    subtitle: _openAIConnected
                        ? "OpenAI GPT-4 (Connected)"
                        : "OpenAI GPT-4 (Not Configured)",
                    leading: CustomIconWidget(
                      iconName: 'psychology',
                      color: _openAIConnected
                          ? AppTheme.successGreen
                          : AppTheme.primaryOrange,
                      size: 24,
                    ),
                    trailing: StatusIndicatorWidget(
                      isActive: _openAIConnected,
                      activeText: "Connected",
                      inactiveText: "Configure",
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/ai-service-configuration');
                    },
                  ),
                  SettingsRowWidget(
                    title: "API Configuration",
                    subtitle: _openAIConnected
                        ? "OpenAI API configured and ready"
                        : "Set up your OpenAI API key",
                    leading: CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.textSecondary,
                      size: 24,
                    ),
                    showDivider: false,
                    onTap: () {
                      Navigator.pushNamed(context, '/ai-service-configuration');
                    },
                  ),
                ],
              ),

              // Language & Region Section
              SettingsSectionWidget(
                title: "LANGUAGE & REGION",
                children: [
                  SettingsRowWidget(
                    title: "Language",
                    subtitle: _currentLanguage,
                    leading: CustomIconWidget(
                      iconName: 'language',
                      color: AppTheme.primaryOrange,
                      size: 24,
                    ),
                    trailing: LanguageFlagWidget(
                      languageCode: _currentLanguage == "English"
                          ? "en"
                          : _currentLanguage == "Türkçe"
                              ? "tr"
                              : _currentLanguage == "Français"
                                  ? "fr"
                                  : "de",
                      languageName: _currentLanguage,
                    ),
                    onTap: _showLanguageSelection,
                  ),
                  SettingsRowWidget(
                    title: "Region",
                    subtitle: _currentRegion,
                    leading: CustomIconWidget(
                      iconName: 'public',
                      color: AppTheme.textSecondary,
                      size: 24,
                    ),
                    showDivider: false,
                    onTap: () {
                      Navigator.pushNamed(context, '/language-selection');
                    },
                  ),
                ],
              ),

              // Notifications Section
              SettingsSectionWidget(
                title: "NOTIFICATIONS",
                children: [
                  ToggleSettingWidget(
                    title: "Screening Alerts",
                    subtitle: "Get notified when calls are screened",
                    initialValue: _screeningAlertsEnabled,
                    leading: CustomIconWidget(
                      iconName: 'notifications',
                      color: AppTheme.primaryOrange,
                      size: 24,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _screeningAlertsEnabled = value;
                      });
                    },
                  ),
                  ToggleSettingWidget(
                    title: "Call Summaries",
                    subtitle: "Receive AI-generated call summaries",
                    initialValue: _callSummariesEnabled,
                    leading: CustomIconWidget(
                      iconName: 'summarize',
                      color: AppTheme.textSecondary,
                      size: 24,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _callSummariesEnabled = value;
                      });
                    },
                  ),
                  ToggleSettingWidget(
                    title: "System Notifications",
                    subtitle: "Allow system-level notifications",
                    initialValue: _systemNotificationsEnabled,
                    leading: CustomIconWidget(
                      iconName: 'notification_important',
                      color: AppTheme.textSecondary,
                      size: 24,
                    ),
                    showDivider: false,
                    onChanged: (value) {
                      setState(() {
                        _systemNotificationsEnabled = value;
                      });
                    },
                  ),
                ],
              ),

              // Privacy Section
              SettingsSectionWidget(
                title: "PRIVACY",
                children: [
                  ToggleSettingWidget(
                    title: "Voice Recording",
                    subtitle: "Allow temporary voice recording for AI analysis",
                    initialValue: _voiceRecordingEnabled,
                    leading: CustomIconWidget(
                      iconName: 'mic',
                      color: AppTheme.primaryOrange,
                      size: 24,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _voiceRecordingEnabled = value;
                      });
                    },
                  ),
                  SettingsRowWidget(
                    title: "Data Retention",
                    subtitle: "Manage how long data is stored",
                    leading: CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.textSecondary,
                      size: 24,
                    ),
                    onTap: () {
                      // Navigate to data retention settings
                    },
                  ),
                  SettingsRowWidget(
                    title: "Delete All Data",
                    subtitle: "Permanently remove all stored data",
                    leading: CustomIconWidget(
                      iconName: 'delete_forever',
                      color: AppTheme.accentRed,
                      size: 24,
                    ),
                    showDivider: false,
                    onTap: _showDeleteDataConfirmation,
                  ),
                ],
              ),

              // Blocked Numbers Section
              SettingsSectionWidget(
                title: "BLOCKED NUMBERS",
                children: [
                  SettingsRowWidget(
                    title: "Manage Blocked Numbers",
                    subtitle: "\$_blockedNumbersCount numbers blocked",
                    leading: CustomIconWidget(
                      iconName: 'block',
                      color: AppTheme.accentRed,
                      size: 24,
                    ),
                    showDivider: false,
                    onTap: () {
                      // Navigate to blocked numbers management
                    },
                  ),
                ],
              ),

              // Help & Support Section
              SettingsSectionWidget(
                title: "HELP & SUPPORT",
                children: [
                  SettingsRowWidget(
                    title: "FAQ",
                    subtitle: "Frequently asked questions",
                    leading: CustomIconWidget(
                      iconName: 'help',
                      color: AppTheme.primaryOrange,
                      size: 24,
                    ),
                    onTap: () {
                      // Navigate to FAQ
                    },
                  ),
                  SettingsRowWidget(
                    title: "Contact Support",
                    subtitle: "Get help from our team",
                    leading: CustomIconWidget(
                      iconName: 'support_agent',
                      color: AppTheme.textSecondary,
                      size: 24,
                    ),
                    onTap: () {
                      // Navigate to support
                    },
                  ),
                  SettingsRowWidget(
                    title: "App Tutorial",
                    subtitle: "Learn how to use DEACON AI",
                    leading: CustomIconWidget(
                      iconName: 'school',
                      color: AppTheme.textSecondary,
                      size: 24,
                    ),
                    showDivider: false,
                    onTap: () {
                      Navigator.pushNamed(context, '/permission-setup');
                    },
                  ),
                ],
              ),

              // About Section
              SettingsSectionWidget(
                title: "ABOUT",
                children: [
                  SettingsRowWidget(
                    title: "App Version",
                    subtitle: "2.1.4 (Build 2024080320)",
                    leading: CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.primaryOrange,
                      size: 24,
                    ),
                    onTap: () {
                      // Show version details
                    },
                  ),
                  SettingsRowWidget(
                    title: "Privacy Policy",
                    subtitle: "Read our privacy policy",
                    leading: CustomIconWidget(
                      iconName: 'privacy_tip',
                      color: AppTheme.textSecondary,
                      size: 24,
                    ),
                    onTap: () {
                      // Open privacy policy
                    },
                  ),
                  SettingsRowWidget(
                    title: "Terms of Service",
                    subtitle: "View terms and conditions",
                    leading: CustomIconWidget(
                      iconName: 'description',
                      color: AppTheme.textSecondary,
                      size: 24,
                    ),
                    showDivider: false,
                    onTap: () {
                      // Open terms of service
                    },
                  ),
                ],
              ),

              // Account Section
              if (userData["isPremium"] as bool)
                SettingsSectionWidget(
                  title: "ACCOUNT",
                  children: [
                    SettingsRowWidget(
                      title: "Subscription",
                      subtitle:
                          "Premium - Expires ${userData["subscriptionExpiry"]}",
                      leading: CustomIconWidget(
                        iconName: 'star',
                        color: AppTheme.primaryOrange,
                        size: 24,
                      ),
                      onTap: () {
                        // Navigate to subscription management
                      },
                    ),
                    SettingsRowWidget(
                      title: "Billing History",
                      subtitle: "View payment history",
                      leading: CustomIconWidget(
                        iconName: 'receipt',
                        color: AppTheme.textSecondary,
                        size: 24,
                      ),
                      showDivider: false,
                      onTap: () {
                        // Navigate to billing history
                      },
                    ),
                  ],
                )
              else
                SettingsSectionWidget(
                  title: "UPGRADE",
                  children: [
                    SettingsRowWidget(
                      title: "Upgrade to Premium",
                      subtitle: "Unlock advanced AI features",
                      leading: CustomIconWidget(
                        iconName: 'upgrade',
                        color: AppTheme.primaryOrange,
                        size: 24,
                      ),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "NEW",
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.pureWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      showDivider: false,
                      onTap: () {
                        // Navigate to upgrade screen
                      },
                    ),
                  ],
                ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
