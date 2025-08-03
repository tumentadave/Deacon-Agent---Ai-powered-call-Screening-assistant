import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/openai_client.dart';
import '../../services/openai_service.dart';
import './widgets/advanced_settings_section.dart';
import './widgets/data_privacy_section.dart';
import './widgets/emergency_mode_toggle.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/service_provider_card.dart';

class AiServiceConfiguration extends StatefulWidget {
  const AiServiceConfiguration({Key? key}) : super(key: key);

  @override
  State<AiServiceConfiguration> createState() => _AiServiceConfigurationState();
}

class _AiServiceConfigurationState extends State<AiServiceConfiguration> {
  int _expandedProviderIndex = -1;
  bool _isLoading = false;
  bool _isSaving = false;
  Map<int, bool?> _connectionStatuses = {};
  Map<int, String> _apiKeys = {};

  // OpenAI Client instance
  late OpenAIClient _openAIClient;

  // Advanced settings
  double _accuracyPreference = 0.5;
  int _processingTimeout = 15;
  bool _offlineFallback = true;
  bool _emergencyMode = true;

  // Service providers data with OpenAI integration
  final List<Map<String, dynamic>> _serviceProviders = [
    {
      "id": 1,
      "name": "OpenAI Whisper",
      "description":
          "State-of-the-art speech recognition with exceptional multilingual capabilities and call analysis",
      "logo": "assets/images/1719591106162-1754251947068.png",
      "accuracy": 97,
      "pricing": "\$0.006/minute",
      "hasFreeTrial": false,
      "features": [
        "99+ languages",
        "Robust to accents",
        "Punctuation included",
        "AI call analysis",
        "Real-time transcription"
      ],
    },
    {
      "id": 2,
      "name": "Google Speech-to-Text",
      "description":
          "High-accuracy speech recognition with real-time processing and multi-language support",
      "logo":
          "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/google/google-original.svg",
      "accuracy": 95,
      "pricing": "Free tier available",
      "hasFreeTrial": true,
      "features": ["Real-time processing", "120+ languages", "Noise reduction"],
    },
    {
      "id": 3,
      "name": "Azure Cognitive Services",
      "description":
          "Microsoft's enterprise-grade speech services with advanced customization options",
      "logo":
          "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/azure/azure-original.svg",
      "accuracy": 94,
      "pricing": "\$1.00/hour",
      "hasFreeTrial": true,
      "features": ["Custom models", "Speaker recognition", "Batch processing"],
    },
    {
      "id": 4,
      "name": "AWS Transcribe",
      "description":
          "Amazon's scalable speech-to-text service with automatic punctuation and formatting",
      "logo":
          "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/amazonwebservices/amazonwebservices-original.svg",
      "accuracy": 92,
      "pricing": "\$0.024/minute",
      "hasFreeTrial": false,
      "features": [
        "Auto punctuation",
        "Custom vocabulary",
        "Channel identification"
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeApiKeys();
    _initializeOpenAI();
  }

  void _initializeApiKeys() {
    for (int i = 0; i < _serviceProviders.length; i++) {
      _apiKeys[i] = '';
    }
  }

  void _initializeOpenAI() {
    try {
      final openAIService = OpenAIService();
      _openAIClient = OpenAIClient(openAIService.dio);
    } catch (e) {
      // OpenAI service not configured
      print('OpenAI service initialization failed: $e');
    }
  }

  Future<void> _testConnection(int providerIndex) async {
    setState(() {
      _isLoading = true;
      _connectionStatuses[providerIndex] = null;
    });

    // Test OpenAI connection if this is the OpenAI provider
    if (providerIndex == 0 && _apiKeys[providerIndex]!.isNotEmpty) {
      try {
        // Test OpenAI connection by listing models
        final models = await _openAIClient.listModels();
        setState(() {
          _isLoading = false;
          _connectionStatuses[providerIndex] = models.isNotEmpty;
        });
        return;
      } catch (e) {
        setState(() {
          _isLoading = false;
          _connectionStatuses[providerIndex] = false;
        });
        return;
      }
    }

    // Simulate API connection test for other providers
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      // Mock connection result based on API key length (simple validation)
      _connectionStatuses[providerIndex] = _apiKeys[providerIndex]!.length > 10;
    });
  }

  Future<void> _saveConfiguration() async {
    setState(() {
      _isSaving = true;
    });

    // Simulate saving configuration
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSaving = false;
    });

    // Show success message and navigate
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('AI Service configured successfully!'),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate to call dashboard or next screen
    Navigator.pushReplacementNamed(context, '/incoming-call-screen');
  }

  bool get _hasValidConfiguration {
    return _apiKeys.values.any((key) => key.isNotEmpty) &&
        _connectionStatuses.values.any((status) => status == true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softOffWhite,
      appBar: AppBar(
        title: Text(
          'AI Service Configuration',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.deepSlate,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            ProgressIndicatorWidget(
              currentStep: 2,
              totalSteps: 4,
              stepLabels: ['Permissions', 'Language', 'AI Setup', 'Complete'],
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Header Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose Your AI Service',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Select and configure an AI service for intelligent call screening and analysis. OpenAI provides the most advanced features including call purpose detection.',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Featured OpenAI Banner
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryOrange.withValues(alpha: 0.1),
                            AppTheme.primaryOrange.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: AppTheme.pureWhite,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.shadowLight,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/1719591106162-1754251947068.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return CustomIconWidget(
                                    iconName: 'smart_toy',
                                    color: AppTheme.primaryOrange,
                                    size: 8.w,
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Recommended',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelMedium
                                          ?.copyWith(
                                        color: AppTheme.primaryOrange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 1.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1.5.w, vertical: 0.3.h),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryOrange,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'NEW',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: AppTheme.pureWhite,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'Advanced AI call analysis with OpenAI',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.deepSlate,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Service Provider Cards
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _serviceProviders.length,
                      itemBuilder: (context, index) {
                        return ServiceProviderCard(
                          provider: _serviceProviders[index],
                          isExpanded: _expandedProviderIndex == index,
                          apiKey: _apiKeys[index] ?? '',
                          connectionStatus: _connectionStatuses[index],
                          isLoading:
                              _isLoading && _expandedProviderIndex == index,
                          onTap: () {
                            setState(() {
                              _expandedProviderIndex =
                                  _expandedProviderIndex == index ? -1 : index;
                            });
                          },
                          onApiKeyChanged: (value) {
                            setState(() {
                              _apiKeys[index] = value;
                              _connectionStatuses[index] = null;
                            });
                          },
                          onTestConnection: () => _testConnection(index),
                        );
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Advanced Settings
                    AdvancedSettingsSection(
                      accuracyPreference: _accuracyPreference,
                      processingTimeout: _processingTimeout,
                      offlineFallback: _offlineFallback,
                      onAccuracyChanged: (value) {
                        setState(() {
                          _accuracyPreference = value;
                        });
                      },
                      onTimeoutChanged: (value) {
                        setState(() {
                          _processingTimeout = value;
                        });
                      },
                      onOfflineFallbackChanged: (value) {
                        setState(() {
                          _offlineFallback = value;
                        });
                      },
                    ),

                    // Emergency Mode Toggle
                    EmergencyModeToggle(
                      isEnabled: _emergencyMode,
                      onChanged: (value) {
                        setState(() {
                          _emergencyMode = value;
                        });
                      },
                    ),

                    // Data Privacy Section
                    const DataPrivacySection(),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),

            // Bottom Action Button
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.pureWhite,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (!_hasValidConfiguration) ...[
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.warningAmber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.warningAmber.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info',
                            color: AppTheme.warningAmber,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'Please configure at least one AI service to continue',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.warningAmber,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: _hasValidConfiguration && !_isSaving
                          ? _saveConfiguration
                          : null,
                      child: _isSaving
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.pureWhite,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Text('Saving Configuration...'),
                              ],
                            )
                          : Text(
                              'Save Configuration',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.pureWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
