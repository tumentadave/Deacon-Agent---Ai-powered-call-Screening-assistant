import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceProviderCard extends StatefulWidget {
  final Map<String, dynamic> provider;
  final bool isExpanded;
  final VoidCallback onTap;
  final Function(String) onApiKeyChanged;
  final VoidCallback onTestConnection;
  final bool isLoading;
  final bool? connectionStatus;
  final String apiKey;

  const ServiceProviderCard({
    Key? key,
    required this.provider,
    required this.isExpanded,
    required this.onTap,
    required this.onApiKeyChanged,
    required this.onTestConnection,
    required this.isLoading,
    this.connectionStatus,
    required this.apiKey,
  }) : super(key: key);

  @override
  State<ServiceProviderCard> createState() => _ServiceProviderCardState();
}

class _ServiceProviderCardState extends State<ServiceProviderCard> {
  bool _isPasswordVisible = false;
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiKeyController.text = widget.apiKey;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isExpanded
              ? AppTheme.primaryOrange
              : AppTheme.lightTheme.colorScheme.outline,
          width: widget.isExpanded ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomImageWidget(
                        imageUrl: widget.provider['logo'] as String,
                        width: 8.w,
                        height: 8.w,
                        fit: BoxFit.contain,
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
                            Expanded(
                              child: Text(
                                widget.provider['name'] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.provider['hasFreeTrial'] == true)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.successGreen,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Free Trial',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme.pureWhite,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          widget.provider['description'] as String,
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'star',
                              color: AppTheme.warningAmber,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${widget.provider['accuracy']}% accuracy',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              widget.provider['pricing'] as String,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.primaryOrange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: widget.isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.textSecondary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (widget.isExpanded) ...[
            Divider(
              color: AppTheme.lightTheme.colorScheme.outline,
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'API Key Configuration',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextFormField(
                    controller: _apiKeyController,
                    obscureText: !_isPasswordVisible,
                    onChanged: widget.onApiKeyChanged,
                    decoration: InputDecoration(
                      labelText: 'API Key',
                      hintText: 'Enter your ${widget.provider['name']} API key',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: _isPasswordVisible
                              ? 'visibility_off'
                              : 'visibility',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: widget.apiKey.isNotEmpty && !widget.isLoading
                          ? widget.onTestConnection
                          : null,
                      icon: widget.isLoading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.pureWhite,
                                ),
                              ),
                            )
                          : CustomIconWidget(
                              iconName: widget.connectionStatus == true
                                  ? 'check_circle'
                                  : widget.connectionStatus == false
                                      ? 'error'
                                      : 'wifi',
                              color: AppTheme.pureWhite,
                              size: 18,
                            ),
                      label: Text(
                        widget.isLoading
                            ? 'Testing Connection...'
                            : widget.connectionStatus == true
                                ? 'Connection Successful'
                                : widget.connectionStatus == false
                                    ? 'Connection Failed'
                                    : 'Test Connection',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.connectionStatus == true
                            ? AppTheme.successGreen
                            : widget.connectionStatus == false
                                ? AppTheme.accentRed
                                : AppTheme.primaryOrange,
                      ),
                    ),
                  ),
                  if (widget.connectionStatus == false) ...[
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.accentRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.accentRed.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'error_outline',
                            color: AppTheme.accentRed,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'Unable to connect. Please check your API key and try again.',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.accentRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 2.h),
                  TextButton.icon(
                    onPressed: () {
                      // Open help guide for this provider
                    },
                    icon: CustomIconWidget(
                      iconName: 'help_outline',
                      color: AppTheme.primaryOrange,
                      size: 18,
                    ),
                    label: Text('How to get API key'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
