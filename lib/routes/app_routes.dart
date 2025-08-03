import 'package:flutter/material.dart';
import '../presentation/settings/settings.dart';
import '../presentation/language_selection/language_selection.dart';
import '../presentation/permission_setup/permission_setup.dart';
import '../presentation/ai_service_configuration/ai_service_configuration.dart';
import '../presentation/incoming_call_screen/incoming_call_screen.dart';
import '../presentation/call_history/call_history.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String settings = '/settings';
  static const String languageSelection = '/language-selection';
  static const String permissionSetup = '/permission-setup';
  static const String aiServiceConfiguration = '/ai-service-configuration';
  static const String incomingCall = '/incoming-call-screen';
  static const String callHistory = '/call-history';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const Settings(),
    settings: (context) => const Settings(),
    languageSelection: (context) => const LanguageSelection(),
    permissionSetup: (context) => const PermissionSetup(),
    aiServiceConfiguration: (context) => const AiServiceConfiguration(),
    incomingCall: (context) => const IncomingCallScreen(),
    callHistory: (context) => const CallHistory(),
    // TODO: Add your other routes here
  };
}
