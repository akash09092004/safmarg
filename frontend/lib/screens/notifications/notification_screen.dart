import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../widgets/custom_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;

  final List<AppNotification> notifications = [];
  final ApiClient _api = ApiClient.instance;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _refreshNotifications(),
    );
  }

  int get unreadCount {
    return notifications.where((item) {
      return !item.isRead;
    }).length;
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      isLoading = true;
    });

    final response = await _api.get(
      ApiConstants.notifications,
      requiresAuth: true,
    );

    if (!mounted) return;

    setState(() {
      if (response.success && response.data is List) {
        notifications
          ..clear()
          ..addAll(
            (response.data as List).whereType<Map>().map(
              (item) =>
                  AppNotification.fromJson(Map<String, dynamic>.from(item)),
            ),
          );
        errorMessage = null;
      } else {
        errorMessage = response.message;
      }
      isLoading = false;
    });
  }

  Future<void> _markAsRead(AppNotification notification) async {
    if (notification.isRead) return;

    final response = await _api.patch(
      ApiConstants.markNotificationRead(notification.id),
      requiresAuth: true,
    );
    if (!mounted) return;
    if (response.success) {
      setState(() => notification.isRead = true);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.message)));
    }
  }

  Future<void> _markAllAsRead() async {
    final response = await _api.patch(
      ApiConstants.markAllNotificationsRead,
      requiresAuth: true,
    );
    if (!mounted) return;
    if (response.success) {
      setState(() {
        for (final notification in notifications) {
          notification.isRead = true;
        }
      });
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response.message)));
  }

  void _openNotification(AppNotification notification) {
    _markAsRead(notification);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _notificationIcon(notification),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        notification.title,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  notification.message,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDateTime(notification.createdAt),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: CustomAppBar(
        title: 'Notifications',
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'read') {
                _markAllAsRead();
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 'read',
                  child: Row(
                    children: [
                      Icon(Icons.done_all, size: 20),
                      SizedBox(width: 10),
                      Text('Mark all as read'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? _emptyState()
          : RefreshIndicator(
              onRefresh: _refreshNotifications,
              child: Column(
                children: [
                  _notificationSummary(),

                  Expanded(
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
                      itemCount: notifications.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];

                        return _notificationCard(notification);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _notificationSummary() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 15, 18, 15),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Notifications',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  unreadCount == 0
                      ? 'You have no unread notifications'
                      : '$unreadCount unread notification${unreadCount == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _notificationCard(AppNotification notification) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        _openNotification(notification);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead
                ? AppColors.border
                : AppColors.primary.withValues(alpha: .20),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _notificationIcon(notification),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w600
                                : FontWeight.w800,
                          ),
                        ),
                      ),

                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Text(
                    _timeAgo(notification.createdAt),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
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

  Widget _notificationIcon(AppNotification notification) {
    final data = _getTypeData(notification.type);

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(data.icon, color: data.color, size: 23),
    );
  }

  Widget _emptyState() {
    return RefreshIndicator(
      onRefresh: _refreshNotifications,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 160),
          Icon(
            Icons.notifications_none_outlined,
            size: 80,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 18),
          Text(
            'No Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 7),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Booking, payment, refund aur offers ke updates yahan dikhai denge.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  _NotificationTypeData _getTypeData(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return const _NotificationTypeData(
          icon: Icons.flight_takeoff,
          color: AppColors.primary,
        );

      case NotificationType.payment:
        return const _NotificationTypeData(
          icon: Icons.payments_outlined,
          color: Colors.green,
        );

      case NotificationType.refund:
        return const _NotificationTypeData(
          icon: Icons.currency_exchange,
          color: Colors.orange,
        );

      case NotificationType.offer:
        return const _NotificationTypeData(
          icon: Icons.local_offer_outlined,
          color: Colors.purple,
        );

      case NotificationType.system:
        return const _NotificationTypeData(
          icon: Icons.info_outline,
          color: Colors.blueGrey,
        );
    }
  }

  String _timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }

    return _formatDateTime(date);
  }

  String _formatDateTime(DateTime date) {
    String twoDigits(int value) {
      return value.toString().padLeft(2, '0');
    }

    final day = twoDigits(date.day);
    final month = twoDigits(date.month);
    final hour = twoDigits(date.hour);
    final minute = twoDigits(date.minute);

    return '$day/$month/${date.year} $hour:$minute';
  }
}

enum NotificationType { booking, payment, refund, offer, system }

class AppNotification {
  final int id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;

  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final typeName = json['type']?.toString().toLowerCase();
    final type = NotificationType.values.firstWhere(
      (value) => value.name == typeName,
      orElse: () => NotificationType.system,
    );
    final rawRead = json['is_read'];

    return AppNotification(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? 'Notification',
      message: json['message']?.toString() ?? '',
      type: type,
      createdAt:
          DateTime.tryParse(
            json['created_at']?.toString().replaceFirst(' ', 'T') ?? '',
          ) ??
          DateTime.now(),
      isRead: rawRead == true || rawRead == 1 || rawRead?.toString() == '1',
    );
  }
}

class _NotificationTypeData {
  final IconData icon;
  final Color color;

  const _NotificationTypeData({required this.icon, required this.color});
}
