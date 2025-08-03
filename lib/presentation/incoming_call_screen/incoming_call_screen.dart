import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../services/openai_service.dart';
import '../../services/openai_client.dart';
import './widgets/ai_processing_status.dart';
import './widgets/call_action_buttons.dart';
import './widgets/call_timer.dart';
import './widgets/caller_info_card.dart';
import './widgets/purpose_card.dart';
import './widgets/quick_action_buttons.dart';
import './widgets/voice_to_text_display.dart';

class IncomingCallScreen extends StatefulWidget {
  const IncomingCallScreen({Key? key}) : super(key: key);

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // OpenAI Integration
  late OpenAIClient _openAIClient;
  bool _openAIAvailable = false;

  // Real call data with OpenAI integration
  final List<Map<String, dynamic>> realCallData = [
    {
      "callerId": "+1 (555) 123-4567",
      "callerName": "Sarah Johnson",
      "location": "New York, NY",
      "transcribedText": "",
      "aiPurpose": "",
      "category": "unknown",
      "confidence": 0.0,
      "callStartTime": DateTime.now().subtract(const Duration(seconds: 15)),
      "aiProcessingStartTime":
          DateTime.now().subtract(const Duration(seconds: 8)),
    }
  ];

  // State variables
  bool _isListening = true;
  bool _isTyping = false;
  bool _showPurpose = false;
  bool _isAIMuted = false;
  bool _isAnalyzing = false;
  String _currentTranscript = "";
  late Map<String, dynamic> _currentCall;

  @override
  void initState() {
    super.initState();

    _currentCall = realCallData.first;
    _initializeOpenAI();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _startCallSimulation();
    _slideController.forward();
    _fadeController.forward();
  }

  void _initializeOpenAI() {
    try {
      final openAIService = OpenAIService();
      _openAIClient = OpenAIClient(openAIService.dio);
      _openAIAvailable = true;
    } catch (e) {
      print('OpenAI not available: $e');
      _openAIAvailable = false;
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _startCallSimulation() {
    // Simulate AI processing and transcription
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });

        if (_openAIAvailable) {
          _simulateRealTranscriptionWithOpenAI();
        } else {
          _simulateTyping();
        }
      }
    });
  }

  void _simulateRealTranscriptionWithOpenAI() {
    // Simulate real incoming speech transcription
    final simulatedSpeech = [
      "Hi, this is Sarah from ABC Marketing.",
      " I'm calling about the special promotion we discussed last week",
      " regarding your business insurance needs.",
      " We have a limited-time offer that could save you up to 30%",
      " on your current policy. Would you be interested in hearing more?"
    ];

    int sentenceIndex = 0;
    String currentText = "";

    void addNextSentence() {
      if (sentenceIndex < simulatedSpeech.length && mounted) {
        currentText += simulatedSpeech[sentenceIndex];
        setState(() {
          _currentTranscript = currentText;
          _currentCall["transcribedText"] = currentText;
        });
        sentenceIndex++;

        Future.delayed(
          Duration(
              milliseconds: simulatedSpeech[sentenceIndex - 1].length * 30),
          addNextSentence,
        );
      } else if (mounted) {
        setState(() {
          _isTyping = false;
          _isListening = false;
          _isAnalyzing = true;
        });

        // Analyze with OpenAI
        _analyzeCallWithOpenAI();
      }
    }

    addNextSentence();
  }

  Future<void> _analyzeCallWithOpenAI() async {
    if (!_openAIAvailable || !mounted) {
      _fallbackAnalysis();
      return;
    }

    try {
      final analysis = await _openAIClient.analyzeCallPurpose(
        transcribedText: _currentCall["transcribedText"],
        callerNumber: _currentCall["callerId"],
        callerName: _currentCall["callerName"],
      );

      if (mounted) {
        setState(() {
          _currentCall["aiPurpose"] = analysis.purpose;
          _currentCall["confidence"] = analysis.confidence;
          _currentCall["category"] = analysis.category;
          _isAnalyzing = false;
          _showPurpose = true;
        });
      }
    } catch (e) {
      print('OpenAI analysis failed: $e');
      _fallbackAnalysis();
    }
  }

  void _fallbackAnalysis() {
    // Fallback analysis without OpenAI
    if (mounted) {
      setState(() {
        _currentCall["aiPurpose"] =
            "Business insurance consultation follow-up call";
        _currentCall["confidence"] = 85.0;
        _currentCall["category"] = "business";
        _isAnalyzing = false;
        _showPurpose = true;
      });
    }
  }

  void _simulateTyping() {
    // Fallback typing simulation
    final fullText =
        "Hi, this is Sarah from ABC Marketing. I'm calling about the special promotion we discussed last week regarding your business insurance needs.";
    int currentIndex = 0;

    void typeNextCharacter() {
      if (currentIndex < fullText.length && mounted) {
        setState(() {
          _currentTranscript = fullText.substring(0, currentIndex + 1);
        });
        currentIndex++;

        Future.delayed(const Duration(milliseconds: 50), typeNextCharacter);
      } else if (mounted) {
        setState(() {
          _isTyping = false;
          _isListening = false;
        });

        // Show purpose after transcription is complete
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _showPurpose = true;
            });
          }
        });
      }
    }

    typeNextCharacter();
  }

  void _handleAcceptCall() {
    HapticFeedback.heavyImpact();
    _dismissScreen();
    // In real implementation, this would accept the call
  }

  void _handleDeclineCall() {
    HapticFeedback.heavyImpact();
    _dismissScreen();
    // In real implementation, this would decline the call
  }

  void _handleSendToVoicemail() {
    HapticFeedback.mediumImpact();
    _dismissScreen();
    // In real implementation, this would send to voicemail
  }

  void _handleMuteAI() {
    setState(() {
      _isAIMuted = !_isAIMuted;
      if (_isAIMuted) {
        _isListening = false;
      }
    });
  }

  void _handleEmergencyOverride() {
    HapticFeedback.heavyImpact();
    _dismissScreen();
    // In real implementation, this would immediately accept the call
  }

  void _handleBlockNumber() {
    HapticFeedback.mediumImpact();
    _dismissScreen();
    // In real implementation, this would block the number and decline
  }

  void _dismissScreen() {
    _slideController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_slideAnimation, _fadeAnimation]),
          builder: (context, child) {
            return SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.softOffWhite,
                        AppTheme.softOffWhite.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      children: [
                        // Call Timer
                        Align(
                          alignment: Alignment.centerRight,
                          child: CallTimer(
                            callStartTime:
                                _currentCall["callStartTime"] as DateTime,
                            aiProcessingStartTime:
                                _currentCall["aiProcessingStartTime"]
                                    as DateTime,
                          ),
                        ),
                        SizedBox(height: 2.h),

                        // Caller Information Card
                        CallerInfoCard(
                          callerNumber: _currentCall["callerId"] as String,
                          callerName: _currentCall["callerName"] as String?,
                          location: _currentCall["location"] as String?,
                        ),
                        SizedBox(height: 3.h),

                        // AI Processing Status
                        AiProcessingStatus(
                          isListening: _isListening && !_isAIMuted,
                          statusText: _isAIMuted
                              ? 'AI Muted'
                              : _isAnalyzing
                                  ? 'Analyzing call with AI...'
                                  : _isListening
                                      ? 'Listening to caller...'
                                      : _showPurpose
                                          ? 'Analysis complete'
                                          : 'Processing...',
                        ),
                        SizedBox(height: 3.h),

                        // Voice to Text Display
                        VoiceToTextDisplay(
                          transcribedText: _currentTranscript,
                          isTyping: _isTyping,
                        ),
                        SizedBox(height: 3.h),

                        // Purpose Card (shown after AI analysis)
                        if (_showPurpose)
                          AnimatedOpacity(
                            opacity: _showPurpose ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 500),
                            child: Column(
                              children: [
                                PurposeCard(
                                  purpose: _currentCall["aiPurpose"] as String,
                                  confidenceLevel:
                                      _currentCall["confidence"] as double,
                                  category: _currentCall["category"] as String,
                                ),
                                SizedBox(height: 3.h),
                              ],
                            ),
                          ),

                        // Main Action Buttons
                        if (_showPurpose)
                          CallActionButtons(
                            onAccept: _handleAcceptCall,
                            onDecline: _handleDeclineCall,
                            onVoicemail: _handleSendToVoicemail,
                          ),

                        SizedBox(height: 2.h),

                        // Quick Action Buttons
                        QuickActionButtons(
                          onMuteAI: _handleMuteAI,
                          onEmergencyOverride: _handleEmergencyOverride,
                          onBlockNumber: _handleBlockNumber,
                          isAIMuted: _isAIMuted,
                        ),

                        SizedBox(height: 2.h),

                        // AI Status Indicator
                        if (_openAIAvailable)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.successGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.successGreen
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppTheme.successGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'OpenAI Connected',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.successGreen,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.warningAmber.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.warningAmber
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppTheme.warningAmber,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Using Fallback AI',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.warningAmber,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        SizedBox(height: 1.h),

                        // Dismiss Hint
                        Text(
                          'Swipe down to dismiss',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color:
                                AppTheme.textSecondary.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
