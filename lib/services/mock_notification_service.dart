import 'dart:async';

enum NotificationType {
  like,
  comment,
  follow,
  message,
  save,
  rating,
  mention,
}

class AppNotification {
  final int id;
  final NotificationType type;
  final int fromUserId;
  final String fromUserName;
  final String? fromUserImage;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final int? recipeId;
  final String? recipeName;

  AppNotification({
    required this.id,
    required this.type,
    required this.fromUserId,
    required this.fromUserName,
    this.fromUserImage,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.recipeId,
    this.recipeName,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      type: type,
      fromUserId: fromUserId,
      fromUserName: fromUserName,
      fromUserImage: fromUserImage,
      message: message,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      recipeId: recipeId,
      recipeName: recipeName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'fromUserId': fromUserId,
      'fromUserName': fromUserName,
      'fromUserImage': fromUserImage,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'recipeId': recipeId,
      'recipeName': recipeName,
    };
  }
}

class MockNotificationService {
  // Mapa: userId -> lista de notificações
  static final Map<int, List<AppNotification>> _notifications = {
    1: [
      AppNotification(
        id: 1,
        type: NotificationType.follow,
        fromUserId: 4,
        fromUserName: 'Ana Beatriz Costa',
        fromUserImage: 'assets/images/chef.jpg',
        message: 'começou a seguir você',
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        isRead: false,
      ),
      AppNotification(
        id: 2,
        type: NotificationType.like,
        fromUserId: 6,
        fromUserName: 'Juliana Ferreira',
        message: 'curtiu sua receita "Bolo de milho sem açúcar"',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isRead: false,
        recipeId: 1,
        recipeName: 'Bolo de milho sem açúcar',
      ),
      AppNotification(
        id: 3,
        type: NotificationType.comment,
        fromUserId: 10,
        fromUserName: 'Fernanda Gomes',
        message: 'comentou: "Receita incrível! Vou fazer hoje!"',
        timestamp: DateTime.now().subtract(Duration(hours: 5)),
        isRead: true,
        recipeId: 1,
        recipeName: 'Bolo de milho sem açúcar',
      ),
    ],
  };

  static int _notificationIdCounter = 100;
  static final _notificationStreamController = StreamController<AppNotification>.broadcast();

  Stream<AppNotification> get notificationStream => _notificationStreamController.stream;

  Future<List<AppNotification>> getNotifications(int userId) async {
    await Future.delayed(Duration(milliseconds: 300));
    final userNotifications = _notifications[userId] ?? [];
    return List.from(userNotifications)..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<int> getUnreadCount(int userId) async {
    await Future.delayed(Duration(milliseconds: 100));
    final userNotifications = _notifications[userId] ?? [];
    return userNotifications.where((n) => !n.isRead).length;
  }

  Future<void> markAsRead(int userId, int notificationId) async {
    await Future.delayed(Duration(milliseconds: 200));
    final userNotifications = _notifications[userId];
    if (userNotifications == null) return;

    final index = userNotifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      userNotifications[index] = userNotifications[index].copyWith(isRead: true);
    }
  }

  Future<void> markAllAsRead(int userId) async {
    await Future.delayed(Duration(milliseconds: 300));
    final userNotifications = _notifications[userId];
    if (userNotifications == null) return;

    for (int i = 0; i < userNotifications.length; i++) {
      userNotifications[i] = userNotifications[i].copyWith(isRead: true);
    }
  }

  Future<void> deleteNotification(int userId, int notificationId) async {
    await Future.delayed(Duration(milliseconds: 200));
    _notifications[userId]?.removeWhere((n) => n.id == notificationId);
  }

  // Criar notificação quando alguém segue
  void createFollowNotification({
    required int targetUserId,
    required int fromUserId,
    required String fromUserName,
    String? fromUserImage,
  }) {
    if (!_notifications.containsKey(targetUserId)) {
      _notifications[targetUserId] = [];
    }

    final notification = AppNotification(
      id: _notificationIdCounter++,
      type: NotificationType.follow,
      fromUserId: fromUserId,
      fromUserName: fromUserName,
      fromUserImage: fromUserImage,
      message: 'começou a seguir você',
      timestamp: DateTime.now(),
    );

    _notifications[targetUserId]!.insert(0, notification);
    _notificationStreamController.add(notification);
    print('🔔 Notificação criada: $fromUserName seguiu usuário $targetUserId');
  }

  // Criar notificação quando alguém curte
  void createLikeNotification({
    required int targetUserId,
    required int fromUserId,
    required String fromUserName,
    String? fromUserImage,
    required int recipeId,
    required String recipeName,
  }) {
    if (targetUserId == fromUserId) return; // Não notificar a si mesmo

    if (!_notifications.containsKey(targetUserId)) {
      _notifications[targetUserId] = [];
    }

    final notification = AppNotification(
      id: _notificationIdCounter++,
      type: NotificationType.like,
      fromUserId: fromUserId,
      fromUserName: fromUserName,
      fromUserImage: fromUserImage,
      message: 'curtiu sua receita "$recipeName"',
      timestamp: DateTime.now(),
      recipeId: recipeId,
      recipeName: recipeName,
    );

    _notifications[targetUserId]!.insert(0, notification);
    _notificationStreamController.add(notification);
    print('🔔 Notificação criada: $fromUserName curtiu receita "$recipeName"');
  }

  // Criar notificação quando alguém comenta
  void createCommentNotification({
    required int targetUserId,
    required int fromUserId,
    required String fromUserName,
    String? fromUserImage,
    required int recipeId,
    required String recipeName,
    required String commentText,
  }) {
    if (targetUserId == fromUserId) return;

    if (!_notifications.containsKey(targetUserId)) {
      _notifications[targetUserId] = [];
    }

    final shortComment = commentText.length > 50
        ? '${commentText.substring(0, 50)}...'
        : commentText;

    final notification = AppNotification(
      id: _notificationIdCounter++,
      type: NotificationType.comment,
      fromUserId: fromUserId,
      fromUserName: fromUserName,
      fromUserImage: fromUserImage,
      message: 'comentou: "$shortComment"',
      timestamp: DateTime.now(),
      recipeId: recipeId,
      recipeName: recipeName,
    );

    _notifications[targetUserId]!.insert(0, notification);
    _notificationStreamController.add(notification);
    print('🔔 Notificação criada: $fromUserName comentou na receita "$recipeName"');
  }

  // Criar notificação quando alguém salva
  void createSaveNotification({
    required int targetUserId,
    required int fromUserId,
    required String fromUserName,
    String? fromUserImage,
    required int recipeId,
    required String recipeName,
  }) {
    if (targetUserId == fromUserId) return;

    if (!_notifications.containsKey(targetUserId)) {
      _notifications[targetUserId] = [];
    }

    final notification = AppNotification(
      id: _notificationIdCounter++,
      type: NotificationType.save,
      fromUserId: fromUserId,
      fromUserName: fromUserName,
      fromUserImage: fromUserImage,
      message: 'salvou sua receita "$recipeName"',
      timestamp: DateTime.now(),
      recipeId: recipeId,
      recipeName: recipeName,
    );

    _notifications[targetUserId]!.insert(0, notification);
    _notificationStreamController.add(notification);
    print('🔔 Notificação criada: $fromUserName salvou receita "$recipeName"');
  }

  // Criar notificação de avaliação
  void createRatingNotification({
    required int targetUserId,
    required int fromUserId,
    required String fromUserName,
    String? fromUserImage,
    required int recipeId,
    required String recipeName,
    required double rating,
  }) {
    if (targetUserId == fromUserId) return;

    if (!_notifications.containsKey(targetUserId)) {
      _notifications[targetUserId] = [];
    }

    final stars = '⭐' * rating.toInt();
    final notification = AppNotification(
      id: _notificationIdCounter++,
      type: NotificationType.rating,
      fromUserId: fromUserId,
      fromUserName: fromUserName,
      fromUserImage: fromUserImage,
      message: 'avaliou sua receita "$recipeName" com $stars',
      timestamp: DateTime.now(),
      recipeId: recipeId,
      recipeName: recipeName,
    );

    _notifications[targetUserId]!.insert(0, notification);
    _notificationStreamController.add(notification);
    print('🔔 Notificação criada: $fromUserName avaliou receita "$recipeName"');
  }

  void dispose() {
    _notificationStreamController.close();
  }
}