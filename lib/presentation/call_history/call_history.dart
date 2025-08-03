import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/call_detail_modal.dart';
import './widgets/call_history_empty_state.dart';
import './widgets/call_history_filter_chips.dart';
import './widgets/call_history_item.dart';
import './widgets/call_history_search_bar.dart';
import './widgets/call_history_section_header.dart';

class CallHistory extends StatefulWidget {
  const CallHistory({Key? key}) : super(key: key);

  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedFilter = 'all';
  bool _isLoading = false;
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> _mockCallHistory = [
    {
      "id": 1,
      "callerName": "Sarah Johnson",
      "phoneNumber": "+1 (555) 123-4567",
      "purpose":
          "Calling about the marketing proposal we discussed last week. I have some additional questions about the budget allocation and timeline.",
      "fullTranscript":
          "Hi, this is Sarah Johnson from Digital Marketing Solutions. I'm calling about the marketing proposal we discussed last week. I have some additional questions about the budget allocation and timeline. Could you please call me back when you have a moment? Thank you.",
      "timestamp": "Today, 2:30 PM",
      "duration": "0:45",
      "status": "accepted",
      "confidenceScore": 0.92,
      "aiAnalysis": [
        {
          "category": "Intent Classification",
          "description":
              "Business follow-up call regarding previously discussed marketing proposal"
        },
        {
          "category": "Urgency Level",
          "description":
              "Medium priority - requesting callback for clarification"
        },
        {
          "category": "Caller Verification",
          "description":
              "Verified business contact with established relationship"
        }
      ],
      "dateGroup": "today"
    },
    {
      "id": 2,
      "callerName": "",
      "phoneNumber": "+1 (800) 555-0199",
      "purpose":
          "Telemarketing call offering extended car warranty services. Automated system with promotional content.",
      "fullTranscript":
          "Hello! This is an important call about your vehicle's extended warranty. Your warranty is about to expire and we want to help you avoid costly repairs. Press 1 to speak with a representative or press 2 to be removed from our list.",
      "timestamp": "Today, 11:15 AM",
      "duration": "",
      "status": "declined",
      "confidenceScore": 0.98,
      "aiAnalysis": [
        {
          "category": "Intent Classification",
          "description": "Automated telemarketing/promotional call"
        },
        {
          "category": "Spam Detection",
          "description":
              "High probability spam call based on content and caller pattern"
        },
        {
          "category": "Caller Verification",
          "description": "Unknown number with typical spam characteristics"
        }
      ],
      "dateGroup": "today"
    },
    {
      "id": 3,
      "callerName": "Dr. Michael Chen",
      "phoneNumber": "+1 (555) 987-6543",
      "purpose":
          "Medical appointment reminder for tomorrow's consultation at 3 PM. Please confirm attendance.",
      "fullTranscript":
          "Hello, this is Dr. Chen's office calling to remind you about your appointment tomorrow at 3 PM for your consultation. Please call us back to confirm your attendance or if you need to reschedule. Thank you.",
      "timestamp": "Yesterday, 4:45 PM",
      "duration": "1:12",
      "status": "accepted",
      "confidenceScore": 0.89,
      "aiAnalysis": [
        {
          "category": "Intent Classification",
          "description": "Medical appointment reminder and confirmation request"
        },
        {
          "category": "Urgency Level",
          "description":
              "High priority - requires confirmation for upcoming appointment"
        },
        {
          "category": "Caller Verification",
          "description": "Verified healthcare provider contact"
        }
      ],
      "dateGroup": "yesterday"
    },
    {
      "id": 4,
      "callerName": "",
      "phoneNumber": "+1 (202) 555-0147",
      "purpose":
          "Suspicious call claiming to be from IRS regarding tax issues. Potential scam attempt.",
      "fullTranscript":
          "This is an urgent call from the Internal Revenue Service. There is a problem with your tax return and legal action will be taken if you don't respond immediately. Please call back at this number to resolve this matter.",
      "timestamp": "Yesterday, 10:20 AM",
      "duration": "",
      "status": "blocked",
      "confidenceScore": 0.96,
      "aiAnalysis": [
        {
          "category": "Intent Classification",
          "description": "Fraudulent call impersonating government agency"
        },
        {
          "category": "Threat Detection",
          "description": "High-risk scam attempt with intimidation tactics"
        },
        {
          "category": "Caller Verification",
          "description": "Unverified caller using deceptive practices"
        }
      ],
      "dateGroup": "yesterday"
    },
    {
      "id": 5,
      "callerName": "Emma Rodriguez",
      "phoneNumber": "+1 (555) 456-7890",
      "purpose":
          "Personal call from friend asking about weekend plans and dinner arrangements.",
      "fullTranscript":
          "Hey! It's Emma. I was wondering if you're still free this weekend for dinner? I made reservations at that new Italian place we talked about. Let me know if Saturday at 7 PM still works for you!",
      "timestamp": "This Week, Mon 6:30 PM",
      "duration": "2:15",
      "status": "accepted",
      "confidenceScore": 0.85,
      "aiAnalysis": [
        {
          "category": "Intent Classification",
          "description": "Personal/social call regarding weekend plans"
        },
        {
          "category": "Urgency Level",
          "description": "Low priority - social coordination"
        },
        {
          "category": "Caller Verification",
          "description": "Known personal contact"
        }
      ],
      "dateGroup": "thisWeek"
    },
    {
      "id": 6,
      "callerName": "",
      "phoneNumber": "+1 (888) 555-0123",
      "purpose":
          "Automated survey call about political preferences. Declined due to privacy concerns.",
      "fullTranscript":
          "Hello, we are conducting a brief survey about your political preferences for the upcoming election. This will only take 5 minutes of your time. Would you be willing to participate in our survey?",
      "timestamp": "This Week, Sun 1:45 PM",
      "duration": "",
      "status": "declined",
      "confidenceScore": 0.91,
      "aiAnalysis": [
        {
          "category": "Intent Classification",
          "description": "Political survey/polling call"
        },
        {
          "category": "Privacy Assessment",
          "description": "Requesting personal political information"
        },
        {
          "category": "Caller Verification",
          "description": "Unknown polling organization"
        }
      ],
      "dateGroup": "thisWeek"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCallHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCallHistory() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshCallHistory() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });
  }

  List<Map<String, dynamic>> get _filteredCalls {
    List<Map<String, dynamic>> filtered = _mockCallHistory;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((call) {
        final callerName = (call['callerName'] as String).toLowerCase();
        final phoneNumber = (call['phoneNumber'] as String).toLowerCase();
        final purpose = (call['purpose'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return callerName.contains(query) ||
            phoneNumber.contains(query) ||
            purpose.contains(query);
      }).toList();
    }

    // Apply status filter
    if (_selectedFilter != 'all') {
      filtered = filtered
          .where((call) =>
              (call['status'] as String).toLowerCase() == _selectedFilter)
          .toList();
    }

    return filtered;
  }

  Map<String, int> get _filterCounts {
    return {
      'all': _mockCallHistory.length,
      'accepted':
          _mockCallHistory.where((call) => call['status'] == 'accepted').length,
      'declined':
          _mockCallHistory.where((call) => call['status'] == 'declined').length,
      'blocked':
          _mockCallHistory.where((call) => call['status'] == 'blocked').length,
    };
  }

  Map<String, List<Map<String, dynamic>>> get _groupedCalls {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final call in _filteredCalls) {
      final String dateGroup = call['dateGroup'] as String;
      if (!grouped.containsKey(dateGroup)) {
        grouped[dateGroup] = [];
      }
      grouped[dateGroup]!.add(call);
    }

    return grouped;
  }

  String _getGroupTitle(String dateGroup) {
    switch (dateGroup) {
      case 'today':
        return 'Today';
      case 'yesterday':
        return 'Yesterday';
      case 'thisWeek':
        return 'This Week';
      default:
        return dateGroup;
    }
  }

  void _showCallDetail(Map<String, dynamic> callData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CallDetailModal(callData: callData),
    );
  }

  void _handleVoiceSearch() {
    // Implement voice search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice search feature coming soon'),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }

  void _exportCallHistory() {
    // Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting call history...'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softOffWhite,
      appBar: AppBar(
        title: Text(
          'Call History',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.pureWhite,
        elevation: 2,
        shadowColor: AppTheme.shadowLight,
        actions: [
          IconButton(
            onPressed: _exportCallHistory,
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: AppTheme.deepSlate,
              size: 6.w,
            ),
            tooltip: 'Export History',
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.deepSlate,
              size: 6.w,
            ),
            tooltip: 'Settings',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'history',
                    color: AppTheme.primaryOrange,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text('All Calls'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'analytics',
                    color: AppTheme.primaryOrange,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text('Analytics'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCallHistoryTab(),
          _buildAnalyticsTab(),
        ],
      ),
    );
  }

  Widget _buildCallHistoryTab() {
    return Column(
      children: [
        CallHistorySearchBar(
          onSearchChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
          onVoiceSearch: _handleVoiceSearch,
        ),
        CallHistoryFilterChips(
          selectedFilter: _selectedFilter,
          onFilterChanged: (filter) {
            setState(() {
              _selectedFilter = filter;
            });
          },
          filterCounts: _filterCounts,
        ),
        Expanded(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryOrange,
                  ),
                )
              : _filteredCalls.isEmpty
                  ? CallHistoryEmptyState(
                      onSetupTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshCallHistory,
                      color: AppTheme.primaryOrange,
                      child: _buildCallList(),
                    ),
        ),
      ],
    );
  }

  Widget _buildCallList() {
    final groupedCalls = _groupedCalls;
    final groups = groupedCalls.keys.toList();

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 2.h),
      itemCount: groups.length,
      itemBuilder: (context, groupIndex) {
        final String groupKey = groups[groupIndex];
        final List<Map<String, dynamic>> groupCalls = groupedCalls[groupKey]!;
        final String groupTitle = _getGroupTitle(groupKey);

        return Column(
          children: [
            CallHistorySectionHeader(
              title: groupTitle,
              callCount: groupCalls.length,
            ),
            ...groupCalls
                .map((call) => CallHistoryItem(
                      callData: call,
                      onTap: () => _showCallDetail(call),
                      onCallBack: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Calling ${call['phoneNumber']}...'),
                            backgroundColor: AppTheme.successGreen,
                          ),
                        );
                      },
                      onMessage: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening messages...'),
                            backgroundColor: AppTheme.primaryOrange,
                          ),
                        );
                      },
                      onAddContact: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Adding to contacts...'),
                            backgroundColor: AppTheme.successGreen,
                          ),
                        );
                      },
                      onDelete: () {
                        setState(() {
                          _mockCallHistory
                              .removeWhere((item) => item['id'] == call['id']);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Call deleted'),
                            backgroundColor: AppTheme.accentRed,
                          ),
                        );
                      },
                      onBlock: () {
                        setState(() {
                          final index = _mockCallHistory
                              .indexWhere((item) => item['id'] == call['id']);
                          if (index != -1) {
                            _mockCallHistory[index]['status'] = 'blocked';
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Number blocked'),
                            backgroundColor: AppTheme.errorOrangeRed,
                          ),
                        );
                      },
                    ))
                .toList(),
          ],
        );
      },
    );
  }

  Widget _buildAnalyticsTab() {
    final totalCalls = _mockCallHistory.length;
    final acceptedCalls =
        _mockCallHistory.where((call) => call['status'] == 'accepted').length;
    final declinedCalls =
        _mockCallHistory.where((call) => call['status'] == 'declined').length;
    final blockedCalls =
        _mockCallHistory.where((call) => call['status'] == 'blocked').length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Call Statistics',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Calls',
                  totalCalls.toString(),
                  'list',
                  AppTheme.primaryOrange,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  'Accepted',
                  acceptedCalls.toString(),
                  'call_received',
                  AppTheme.successGreen,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Declined',
                  declinedCalls.toString(),
                  'call_end',
                  AppTheme.accentRed,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  'Blocked',
                  blockedCalls.toString(),
                  'block',
                  AppTheme.errorOrangeRed,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'AI Performance',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.pureWhite,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'psychology',
                      color: AppTheme.primaryOrange,
                      size: 6.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Average Confidence Score',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  '91%',
                  style: AppTheme.lightTheme.textTheme.displayMedium?.copyWith(
                    color: AppTheme.successGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Excellent AI accuracy in call purpose detection',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.w),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
