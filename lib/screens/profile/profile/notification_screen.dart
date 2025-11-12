import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../services/mock_notification_service.dart';
import 'package:sabore_app/providers/auth_provider.dart';
import 'package:sabore_app/providers/notification_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Configurar locale brasileiro para timeago
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final currentUser = ref.watch(currentUserDataProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF7CB342),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'Notificações',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF3C4D18),
          ),
        ),
        actions: [
          notificationsAsync.when(
            data: (notifications) {
              final hasUnread = notifications.any((n) => !n.isRead);
              if (!hasUnread) return SizedBox.shrink();

              return TextButton(
                onPressed: () => _markAllAsRead(),
                child: Text(
                  'Marcar tudo',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFFFA9500),
                  ),
                ),
              );
            },
            loading: () => SizedBox.shrink(),
            error: (_, __) => SizedBox.shrink(),
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(notificationsProvider);
            },
            color: Color(0xFFFA9500),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationCard(context, notification);
              },
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: Color(0xFFFA9500)),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade300,
              ),
              SizedBox(height: 16),
              Text(
                'Erro ao carregar notificações',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Color(0xFFFFF8F0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: 80,
              color: Color(0xFFFA9500),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Nenhuma notificação',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Você será notificado quando houver\natividades em suas receitas!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: Color(0xFF999999),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, AppNotification notification) {
    final iconData = _getIconForType(notification.type);
    final iconColor = _getColorForType(notification.type);
    final timeAgo = timeago.format(notification.timestamp, locale: 'pt_BR');

    return Dismissible(
      key: Key('notification_${notification.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Colors.red.shade400,
        child: Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        _deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notificação removida'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF666666),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : Color(0xFFFFF8F0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead
                ? Color(0xFFE0E0E0)
                : Color(0xFFFA9500).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFFFF3E0),
                backgroundImage: notification.fromUserImage != null
                    ? AssetImage(notification.fromUserImage!)
                    : null,
                child: notification.fromUserImage == null
                    ? Text(
                  notification.fromUserName[0].toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color(0xFFFA9500),
                  ),
                )
                    : null,
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    iconData,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          title: RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: Color(0xFF3C4D18),
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: notification.fromUserName,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: ' ${notification.message}',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 12,
                  color: Color(0xFF999999),
                ),
                SizedBox(width: 4),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          trailing: !notification.isRead
              ? Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Color(0xFFFA9500),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFA9500).withOpacity(0.3),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          )
              : null,
          onTap: () => _handleNotificationTap(notification),
        ),
      ),
    );
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.comment:
        return Icons.comment;
      case NotificationType.follow:
        return Icons.person_add;
      case NotificationType.rating:
        return Icons.star;
      case NotificationType.save:
        return Icons.bookmark;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.mention:
        return Icons.alternate_email;
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Color(0xFFE91E63);
      case NotificationType.comment:
        return Color(0xFFFA9500);
      case NotificationType.follow:
        return Color(0xFF7CB342);
      case NotificationType.rating:
        return Color(0xFFFFB300);
      case NotificationType.save:
        return Color(0xFF00BCD4);
      case NotificationType.message:
        return Color(0xFF9C27B0);
      case NotificationType.mention:
        return Color(0xFF3F51B5);
    }
  }

  void _handleNotificationTap(AppNotification notification) async {
    final currentUser = ref.read(currentUserDataProvider);
    if (currentUser == null) return;

    final userId = currentUser['id'] as int;
    final service = ref.read(notificationServiceProvider);

    // Marcar como lida
    if (!notification.isRead) {
      await service.markAsRead(userId, notification.id);
      ref.invalidate(notificationsProvider);
      ref.invalidate(unreadNotificationCountProvider);
    }

    // Navegar baseado no tipo
    if (notification.recipeId != null) {
      context.push('/recipe/${notification.recipeId}');
    } else if (notification.type == NotificationType.follow) {
      context.push('/profile/${notification.fromUserId}');
    }
  }

  void _deleteNotification(int notificationId) async {
    final currentUser = ref.read(currentUserDataProvider);
    if (currentUser == null) return;

    final userId = currentUser['id'] as int;
    final service = ref.read(notificationServiceProvider);

    await service.deleteNotification(userId, notificationId);
    ref.invalidate(notificationsProvider);
    ref.invalidate(unreadNotificationCountProvider);
  }

  void _markAllAsRead() async {
    final currentUser = ref.read(currentUserDataProvider);
    if (currentUser == null) return;

    final userId = currentUser['id'] as int;
    final service = ref.read(notificationServiceProvider);

    await service.markAllAsRead(userId);
    ref.invalidate(notificationsProvider);
    ref.invalidate(unreadNotificationCountProvider);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Todas notificações marcadas como lidas'),
        backgroundColor: Color(0xFF7CB342),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}