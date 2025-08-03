import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class QuickActionButtons extends StatelessWidget {
  final VoidCallback onMuteAI;
  final VoidCallback onEmergencyOverride;
  final VoidCallback onBlockNumber;
  final bool isAIMuted;

  const QuickActionButtons({
    Key? key,
    required this.onMuteAI,
    required this.onEmergencyOverride,
    required this.onBlockNumber,
    required this.isAIMuted,
  }) : super(key: key);

  void _handleButtonPress(VoidCallback action) {
    HapticFeedback.lightImpact();
    action();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mute AI Button
          _QuickActionButton(
            onPressed: () => _handleButtonPress(onMuteAI),
            icon: isAIMuted ? Icons.volume_off : Icons.volume_up,
            label: isAIMuted ? 'Unmute AI' : 'Mute AI',
            backgroundColor: isAIMuted
                ? AppTheme.warningAmber
                : AppTheme.textSecondary.withValues(alpha: 0.8),
          ),

          // Emergency Override Button
          _QuickActionButton(
            onPressed: () => _handleButtonPress(onEmergencyOverride),
            icon: Icons.emergency,
            label: 'Emergency',
            backgroundColor: AppTheme.errorOrangeRed,
          ),

          // Block Number Button
          _QuickActionButton(
            onPressed: () => _handleButtonPress(onBlockNumber),
            icon: Icons.block,
            label: 'Block',
            backgroundColor: AppTheme.deepSlate,
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const _QuickActionButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 25.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: _isPressed
                    ? widget.backgroundColor.withValues(alpha: 0.7)
                    : widget.backgroundColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor.withValues(alpha: 0.2),
                    blurRadius: _isPressed ? 2 : 4,
                    offset: Offset(0, _isPressed ? 1 : 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: widget.icon.codePoint.toString(),
                    color: AppTheme.pureWhite,
                    size: 6.w,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    widget.label,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.pureWhite,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
