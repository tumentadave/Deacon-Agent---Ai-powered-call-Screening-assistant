import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class VoiceToTextDisplay extends StatefulWidget {
  final String transcribedText;
  final bool isTyping;

  const VoiceToTextDisplay({
    Key? key,
    required this.transcribedText,
    required this.isTyping,
  }) : super(key: key);

  @override
  State<VoiceToTextDisplay> createState() => _VoiceToTextDisplayState();
}

class _VoiceToTextDisplayState extends State<VoiceToTextDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _typingController;
  late Animation<double> _typingAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _typingController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _typingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _typingController,
      curve: Curves.easeInOut,
    ));

    if (widget.isTyping) {
      _typingController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(VoiceToTextDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isTyping != oldWidget.isTyping) {
      if (widget.isTyping) {
        _typingController.repeat(reverse: true);
      } else {
        _typingController.stop();
        _typingController.reset();
      }
    }

    // Auto-scroll to bottom when new text is added
    if (widget.transcribedText != oldWidget.transcribedText &&
        widget.transcribedText.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _typingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      height: 25.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderGray.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'record_voice_over',
                color: AppTheme.primaryOrange,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Caller is saying:',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Transcribed Text Area
          Expanded(
            child: widget.transcribedText.isEmpty && !widget.isTyping
                ? Center(
                    child: Text(
                      'Waiting for caller to speak...',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.transcribedText.isNotEmpty)
                          Text(
                            widget.transcribedText,
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              height: 1.4,
                            ),
                          ),

                        // Typing Cursor Animation
                        if (widget.isTyping)
                          AnimatedBuilder(
                            animation: _typingAnimation,
                            builder: (context, child) {
                              return Container(
                                margin: EdgeInsets.only(top: 0.5.h),
                                child: Text(
                                  '|',
                                  style: AppTheme.lightTheme.textTheme.bodyLarge
                                      ?.copyWith(
                                    color: AppTheme.primaryOrange.withValues(
                                      alpha: _typingAnimation.value,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
