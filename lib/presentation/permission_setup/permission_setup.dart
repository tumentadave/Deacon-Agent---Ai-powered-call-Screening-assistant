import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/emergency_bypass_info_widget.dart';
import './widgets/permission_card_widget.dart';
import './widgets/privacy_statement_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/troubleshooting_guide_widget.dart';

class PermissionSetup extends StatefulWidget {
  const PermissionSetup({Key? key}) : super(key: key);

  @override
  State<PermissionSetup> createState() => _PermissionSetupState();
}

class _PermissionSetupState extends State<PermissionSetup>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Permission states
  bool _phonePermissionGranted = false;
  bool _microphonePermissionGranted = false;
  bool _systemOverlayPermissionGranted = false;
  bool _contactsPermissionGranted = false;
  bool _notificationPermissionGranted = false;

  bool _isLoading = false;
  bool _showTroubleshooting = false;

  final List<Map<String, dynamic>> _permissionData = [
    {
      "id": "phone",
      "iconName": "phone",
      "title": "Phone Access",
      "description":
          "Required for call interception and management. Enables DEACON AI to detect incoming calls and provide screening interface.",
      "isRequired": true,
      "permission": Permission.phone,
    },
    {
      "id": "microphone",
      "iconName": "mic",
      "title": "Microphone Access",
      "description":
          "Necessary for voice recording during call screening. Voice data is processed securely and never stored permanently.",
      "isRequired": true,
      "permission": Permission.microphone,
    },
    {
      "id": "system_overlay",
      "iconName": "layers",
      "title": "System Overlay",
      "description":
          "Enables call screening interface display over other apps. Shows caller information and AI analysis during incoming calls.",
      "isRequired": true,
      "permission": Permission.systemAlertWindow,
    },
    {
      "id": "contacts",
      "iconName": "contacts",
      "title": "Contacts Access",
      "description":
          "Optional access to manage whitelist and identify known callers. Helps improve call screening accuracy.",
      "isRequired": false,
      "permission": Permission.contacts,
    },
    {
      "id": "notification",
      "iconName": "notifications",
      "title": "Notifications",
      "description":
          "Shows call screening results and important alerts. Keeps you informed about blocked calls and system status.",
      "isRequired": false,
      "permission": Permission.notification,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkInitialPermissions();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  Future<void> _checkInitialPermissions() async {
    if (kIsWeb) {
      // Web doesn't support these permissions, set defaults
      setState(() {
        _phonePermissionGranted = false;
        _microphonePermissionGranted = false;
        _systemOverlayPermissionGranted = false;
        _contactsPermissionGranted = false;
        _notificationPermissionGranted =
            true; // Web notifications work differently
      });
      return;
    }

    try {
      final phoneStatus = await Permission.phone.status;
      final micStatus = await Permission.microphone.status;
      final overlayStatus = await Permission.systemAlertWindow.status;
      final contactsStatus = await Permission.contacts.status;
      final notificationStatus = await Permission.notification.status;

      setState(() {
        _phonePermissionGranted = phoneStatus.isGranted;
        _microphonePermissionGranted = micStatus.isGranted;
        _systemOverlayPermissionGranted = overlayStatus.isGranted;
        _contactsPermissionGranted = contactsStatus.isGranted;
        _notificationPermissionGranted = notificationStatus.isGranted;
      });
    } catch (e) {
      // Handle permission check errors gracefully
      _showErrorToast('Unable to check permissions. Please try again.');
    }
  }

  Future<void> _requestPermission(String permissionId) async {
    if (kIsWeb) {
      _showErrorToast('Permission management not available on web platform');
      return;
    }

    setState(() => _isLoading = true);

    try {
      Permission? permission;

      switch (permissionId) {
        case 'phone':
          permission = Permission.phone;
          break;
        case 'microphone':
          permission = Permission.microphone;
          break;
        case 'system_overlay':
          permission = Permission.systemAlertWindow;
          break;
        case 'contacts':
          permission = Permission.contacts;
          break;
        case 'notification':
          permission = Permission.notification;
          break;
      }

      if (permission != null) {
        final status = await permission.request();

        setState(() {
          switch (permissionId) {
            case 'phone':
              _phonePermissionGranted = status.isGranted;
              break;
            case 'microphone':
              _microphonePermissionGranted = status.isGranted;
              break;
            case 'system_overlay':
              _systemOverlayPermissionGranted = status.isGranted;
              break;
            case 'contacts':
              _contactsPermissionGranted = status.isGranted;
              break;
            case 'notification':
              _notificationPermissionGranted = status.isGranted;
              break;
          }
        });

        if (status.isGranted) {
          _showSuccessToast('Permission granted successfully');
        } else if (status.isPermanentlyDenied) {
          setState(() => _showTroubleshooting = true);
          _showErrorToast(
              'Permission denied. Please enable manually in settings.');
        } else {
          _showErrorToast(
              'Permission denied. This feature may not work properly.');
        }
      }
    } catch (e) {
      _showErrorToast('Failed to request permission. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _openAppSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      _showErrorToast('Unable to open settings. Please navigate manually.');
    }
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successGreen,
      textColor: AppTheme.pureWhite,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.errorOrangeRed,
      textColor: AppTheme.pureWhite,
    );
  }

  int get _grantedPermissionsCount {
    int count = 0;
    if (_phonePermissionGranted) count++;
    if (_microphonePermissionGranted) count++;
    if (_systemOverlayPermissionGranted) count++;
    if (_contactsPermissionGranted) count++;
    if (_notificationPermissionGranted) count++;
    return count;
  }

  bool get _canContinue {
    return _phonePermissionGranted &&
        _microphonePermissionGranted &&
        _systemOverlayPermissionGranted;
  }

  void _continueToNextScreen() {
    if (_canContinue) {
      Navigator.pushNamed(context, '/language-selection');
    } else {
      _showErrorToast('Please grant required permissions to continue');
    }
  }

  void _skipForNow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Skip Permission Setup?',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'DEACON AI requires phone and microphone permissions to function properly. You can enable them later in settings.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/language-selection');
              },
              child: Text(
                'Skip Anyway',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.pureWhite,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _getPermissionStatus(String permissionId) {
    switch (permissionId) {
      case 'phone':
        return _phonePermissionGranted;
      case 'microphone':
        return _microphonePermissionGranted;
      case 'system_overlay':
        return _systemOverlayPermissionGranted;
      case 'contacts':
        return _contactsPermissionGranted;
      case 'notification':
        return _notificationPermissionGranted;
      default:
        return false;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softOffWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.pureWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.deepSlate,
            size: 6.w,
          ),
        ),
        title: Text(
          'Permission Setup',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.deepSlate,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(
            children: [
              // Progress Indicator
              ProgressIndicatorWidget(
                currentStep: _grantedPermissionsCount,
                totalSteps: _permissionData.length,
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),

                      // Permission Cards
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _permissionData.length,
                        itemBuilder: (context, index) {
                          final permission = _permissionData[index];
                          return PermissionCardWidget(
                            iconName: permission["iconName"] as String,
                            title: permission["title"] as String,
                            description: permission["description"] as String,
                            isGranted: _getPermissionStatus(
                                permission["id"] as String),
                            isRequired: permission["isRequired"] as bool,
                            onGrantAccess: _isLoading
                                ? () {}
                                : () => _requestPermission(
                                    permission["id"] as String),
                          );
                        },
                      ),

                      SizedBox(height: 2.h),

                      // Emergency Bypass Info
                      const EmergencyBypassInfoWidget(),

                      // Privacy Statement
                      const PrivacyStatementWidget(),

                      // Troubleshooting Guide (shown when needed)
                      if (_showTroubleshooting)
                        TroubleshootingGuideWidget(
                          onOpenSettings: _openAppSettings,
                        ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),

              // Bottom Action Buttons
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
                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading || !_canContinue
                            ? null
                            : _continueToNextScreen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canContinue
                              ? AppTheme.primaryOrange
                              : AppTheme.borderGray,
                          foregroundColor: _canContinue
                              ? AppTheme.pureWhite
                              : AppTheme.textSecondary,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 5.w,
                                width: 5.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.pureWhite,
                                  ),
                                ),
                              )
                            : Text(
                                'Continue',
                                style: AppTheme.lightTheme.textTheme.labelLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Skip Button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _isLoading ? null : _skipForNow,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                        child: Text(
                          'Skip for Now',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
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
      ),
    );
  }
}
