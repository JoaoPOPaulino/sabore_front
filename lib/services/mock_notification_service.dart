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
  // ✅ NOTIFICAÇÕES REALISTAS POR USUÁRIO
  static final Map<int, List<AppNotification>> _notifications = {
    // ===== NOTIFICAÇÕES DO JOÃO (userId: 1) =====
    1: [
      // Follows recentes
      AppNotification(
        id: 1,
        type: NotificationType.follow,
        fromUserId: 4,
        fromUserName: 'Ana Beatriz Costa',
        fromUserImage: 'assets/images/chef.jpg',
        message: 'começou a seguir você',
        timestamp: DateTime.now().subtract(Duration(minutes: 15)),
        isRead: false,
      ),
      AppNotification(
        id: 2,
        type: NotificationType.follow,
        fromUserId: 6,
        fromUserName: 'Juliana Ferreira',
        message: 'começou a seguir você',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isRead: false,
      ),
      // Likes em receitas do João
      AppNotification(
        id: 3,
        type: NotificationType.like,
        fromUserId: 2,
        fromUserName: 'Maria Santos',
        message: 'curtiu sua receita "Bolo de milho sem açúcar"',
        timestamp: DateTime.now().subtract(Duration(hours: 3)),
        isRead: false,
        recipeId: 1,
        recipeName: 'Bolo de milho sem açúcar',
      ),
      AppNotification(
        id: 4,
        type: NotificationType.like,
        fromUserId: 4,
        fromUserName: 'Ana Beatriz Costa',
        fromUserImage: 'assets/images/chef.jpg',
        message: 'curtiu sua receita "Canjica zero lactose"',
        timestamp: DateTime.now().subtract(Duration(hours: 5)),
        isRead: true,
        recipeId: 2,
        recipeName: 'Canjica zero lactose',
      ),
      AppNotification(
        id: 5,
        type: NotificationType.save,
        fromUserId: 6,
        fromUserName: 'Juliana Ferreira',
        message: 'salvou sua receita "Paçoca Cremosa"',
        timestamp: DateTime.now().subtract(Duration(hours: 8)),
        isRead: true,
        recipeId: 3,
        recipeName: 'Paçoca Cremosa',
      ),
      // Comentários
      AppNotification(
        id: 6,
        type: NotificationType.comment,
        fromUserId: 10,
        fromUserName: 'Fernanda Gomes',
        message: 'comentou: "Ficou perfeito! Minha família adorou! 😍"',
        timestamp: DateTime.now().subtract(Duration(hours: 12)),
        isRead: true,
        recipeId: 1,
        recipeName: 'Bolo de milho sem açúcar',
      ),
      AppNotification(
        id: 7,
        type: NotificationType.like,
        fromUserId: 7,
        fromUserName: 'Usuario Teste',
        message: 'curtiu sua receita "Arroz Doce Especial"',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
        recipeId: 4,
        recipeName: 'Arroz Doce Especial',
      ),
      AppNotification(
        id: 8,
        type: NotificationType.save,
        fromUserId: 4,
        fromUserName: 'Ana Beatriz Costa',
        fromUserImage: 'assets/images/chef.jpg',
        message: 'salvou sua receita "Cocada de Forno"',
        timestamp: DateTime.now().subtract(Duration(days: 1, hours: 5)),
        isRead: true,
        recipeId: 5,
        recipeName: 'Cocada de Forno',
      ),
      AppNotification(
        id: 9,
        type: NotificationType.comment,
        fromUserId: 3,
        fromUserName: 'Carlos Eduardo',
        message: 'comentou: "Receita incrível! Vou fazer no fim de semana"',
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        isRead: true,
        recipeId: 2,
        recipeName: 'Canjica zero lactose',
      ),
      AppNotification(
        id: 10,
        type: NotificationType.rating,
        fromUserId: 9,
        fromUserName: 'Pedro Henrique',
        message: 'avaliou sua receita "Bolo de milho sem açúcar" com ⭐⭐⭐⭐⭐',
        timestamp: DateTime.now().subtract(Duration(days: 3)),
        isRead: true,
        recipeId: 1,
        recipeName: 'Bolo de milho sem açúcar',
      ),
    ],

    // ===== NOTIFICAÇÕES DA MARIA (userId: 2) =====
    2: [
      AppNotification(
        id: 11,
        type: NotificationType.follow,
        fromUserId: 1,
        fromUserName: 'João Pedro Silva',
        message: 'começou a seguir você',
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        isRead: false,
      ),
      AppNotification(
        id: 12,
        type: NotificationType.like,
        fromUserId: 4,
        fromUserName: 'Ana Beatriz Costa',
        fromUserImage: 'assets/images/chef.jpg',
        message: 'curtiu sua receita "Lasanha à Bolonhesa"',
        timestamp: DateTime.now().subtract(Duration(hours: 4)),
        isRead: false,
        recipeId: 6,
        recipeName: 'Lasanha à Bolonhesa',
      ),
      AppNotification(
        id: 13,
        type: NotificationType.like,
        fromUserId: 6,
        fromUserName: 'Juliana Ferreira',
        message: 'curtiu sua receita "Risoto de Camarão"',
        timestamp: DateTime.now().subtract(Duration(hours: 6)),
        isRead: true,
        recipeId: 7,
        recipeName: 'Risoto de Camarão',
      ),
      AppNotification(
        id: 14,
        type: NotificationType.comment,
        fromUserId: 3,
        fromUserName: 'Carlos Eduardo',
        message: 'comentou: "Melhor risoto que já comi!"',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
        recipeId: 7,
        recipeName: 'Risoto de Camarão',
      ),
      AppNotification(
        id: 15,
        type: NotificationType.save,
        fromUserId: 10,
        fromUserName: 'Fernanda Gomes',
        message: 'salvou sua receita "Nhoque ao Molho Branco"',
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        isRead: true,
        recipeId: 8,
        recipeName: 'Nhoque ao Molho Branco',
      ),
    ],

    // ===== NOTIFICAÇÕES DO CARLOS (userId: 3) =====
    3: [
      AppNotification(
        id: 16,
        type: NotificationType.follow,
        fromUserId: 4,
        fromUserName: 'Ana Beatriz Costa',
        fromUserImage: 'assets/images/chef.jpg',
        message: 'começou a seguir você',
        timestamp: DateTime.now().subtract(Duration(minutes: 45)),
        isRead: false,
      ),
      AppNotification(
        id: 17,
        type: NotificationType.like,
        fromUserId: 1,
        fromUserName: 'João Pedro Silva',
        message: 'curtiu sua receita "Churrasco Completo"',
        timestamp: DateTime.now().subtract(Duration(hours: 3)),
        isRead: false,
        recipeId: 9,
        recipeName: 'Churrasco Completo',
      ),
      AppNotification(
        id: 18,
        type: NotificationType.comment,
        fromUserId: 5,
        fromUserName: 'Rafael Oliveira',
        message: 'comentou: "Dicas perfeitas! Churrasco ficou no ponto"',
        timestamp: DateTime.now().subtract(Duration(hours: 8)),
        isRead: true,
        recipeId: 9,
        recipeName: 'Churrasco Completo',
      ),
      AppNotification(
        id: 19,
        type: NotificationType.save,
        fromUserId: 6,
        fromUserName: 'Juliana Ferreira',
        message: 'salvou sua receita "Farofa Completa"',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
        recipeId: 10,
        recipeName: 'Farofa Completa',
      ),
    ],

    // ===== NOTIFICAÇÕES DA ANA (userId: 4) =====
    4: [
      AppNotification(
        id: 20,
        type: NotificationType.follow,
        fromUserId: 2,
        fromUserName: 'Maria Santos',
        message: 'começou a seguir você',
        timestamp: DateTime.now().subtract(Duration(minutes: 30)),
        isRead: false,
      ),
      AppNotification(
        id: 21,
        type: NotificationType.follow,
        fromUserId: 9,
        fromUserName: 'Pedro Henrique',
        message: 'começou a seguir você',
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        isRead: false,
      ),
      AppNotification(
        id: 22,
        type: NotificationType.like,
        fromUserId: 1,
        fromUserName: 'João Pedro Silva',
        message: 'curtiu sua receita "Brownie de chocolate"',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isRead: false,
        recipeId: 11,
        recipeName: 'Brownie de chocolate',
      ),
      AppNotification(
        id: 23,
        type: NotificationType.like,
        fromUserId: 6,
        fromUserName: 'Juliana Ferreira',
        message: 'curtiu sua receita "Pão de Queijo"',
        timestamp: DateTime.now().subtract(Duration(hours: 4)),
        isRead: true,
        recipeId: 12,
        recipeName: 'Pão de Queijo',
      ),
      AppNotification(
        id: 24,
        type: NotificationType.comment,
        fromUserId: 10,
        fromUserName: 'Fernanda Gomes',
        message: 'comentou: "Esse brownie é divino! ❤️"',
        timestamp: DateTime.now().subtract(Duration(hours: 6)),
        isRead: true,
        recipeId: 11,
        recipeName: 'Brownie de chocolate',
      ),
      AppNotification(
        id: 25,
        type: NotificationType.save,
        fromUserId: 2,
        fromUserName: 'Maria Santos',
        message: 'salvou sua receita "Torta de Limão"',
        timestamp: DateTime.now().subtract(Duration(hours: 12)),
        isRead: true,
        recipeId: 14,
        recipeName: 'Torta de Limão',
      ),
      AppNotification(
        id: 26,
        type: NotificationType.like,
        fromUserId: 3,
        fromUserName: 'Carlos Eduardo',
        message: 'curtiu sua receita "Mousse de Maracujá"',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
        recipeId: 13,
        recipeName: 'Mousse de Maracujá',
      ),
      AppNotification(
        id: 27,
        type: NotificationType.rating,
        fromUserId: 5,
        fromUserName: 'Rafael Oliveira',
        message: 'avaliou sua receita "Pão de Queijo" com ⭐⭐⭐⭐⭐',
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        isRead: true,
        recipeId: 12,
        recipeName: 'Pão de Queijo',
      ),
    ],

    // ===== NOTIFICAÇÕES DO RAFAEL (userId: 5) =====
    5: [
      AppNotification(
        id: 28,
        type: NotificationType.follow,
        fromUserId: 1,
        fromUserName: 'João Pedro Silva',
        message: 'começou a seguir você',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isRead: false,
      ),
      AppNotification(
        id: 29,
        type: NotificationType.like,
        fromUserId: 4,
        fromUserName: 'Ana Beatriz Costa',
        fromUserImage: 'assets/images/chef.jpg',
        message: 'curtiu sua receita "Hambúrguer Artesanal"',
        timestamp: DateTime.now().subtract(Duration(hours: 5)),
        isRead: true,
        recipeId: 15,
        recipeName: 'Hambúrguer Artesanal',
      ),
      AppNotification(
        id: 30,
        type: NotificationType.comment,
        fromUserId: 3,
        fromUserName: 'Carlos Eduardo',
        message: 'comentou: "Melhor hambúrguer caseiro!"',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
        recipeId: 15,
        recipeName: 'Hambúrguer Artesanal',
      ),
      AppNotification(
        id: 31,
        type: NotificationType.save,
        fromUserId: 6,
        fromUserName: 'Juliana Ferreira',
        message: 'salvou sua receita "Batata Rosti"',
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        isRead: true,
        recipeId: 16,
        recipeName: 'Batata Rosti',
      ),
    ],

    // ===== NOTIFICAÇÕES DA JULIANA (userId: 6) =====
    6: [
      AppNotification(
        id: 32,
        type: NotificationType.follow,
        fromUserId: 4,
        fromUserName: 'Ana Beatriz Costa',
        fromUserImage: 'assets/images/chef.jpg',
        message: 'começou a seguir você',
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        isRead: false,
      ),
      AppNotification(
        id: 33,
        type: NotificationType.like,
        fromUserId: 1,
        fromUserName: 'João Pedro Silva',
        message: 'curtiu sua receita "Pizza Margherita"',
        timestamp: DateTime.now().subtract(Duration(hours: 3)),
        isRead: false,
        recipeId: 17,
        recipeName: 'Pizza Margherita',
      ),
      AppNotification(
        id: 34,
        type: NotificationType.like,
        fromUserId: 2,
        fromUserName: 'Maria Santos',
        message: 'curtiu sua receita "Suco Verde Detox"',
        timestamp: DateTime.now().subtract(Duration(hours: 7)),
        isRead: true,
        recipeId: 18,
        recipeName: 'Suco Verde Detox',
      ),
      AppNotification(
        id: 35,
        type: NotificationType.comment,
        fromUserId: 10,
        fromUserName: 'Fernanda Gomes',
        message: 'comentou: "Suco delicioso e saudável!"',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
        recipeId: 18,
        recipeName: 'Suco Verde Detox',
      ),
      AppNotification(
        id: 36,
        type: NotificationType.save,
        fromUserId: 4,
        fromUserName: 'Ana Beatriz Costa',
        fromUserImage: 'assets/images/chef.jpg',
        message: 'salvou sua receita "Salada Caesar"',
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        isRead: true,
        recipeId: 19,
        recipeName: 'Salada Caesar',
      ),
    ],

    // ===== NOTIFICAÇÕES DO TESTE (userId: 7) =====
    7: [
      AppNotification(
        id: 37,
        type: NotificationType.follow,
        fromUserId: 4,
        fromUserName: 'Ana Beatriz Costa',
        fromUserImage: 'assets/images/chef.jpg',
        message: 'começou a seguir você',
        timestamp: DateTime.now().subtract(Duration(hours: 6)),
        isRead: false,
      ),
      AppNotification(
        id: 38,
        type: NotificationType.like,
        fromUserId: 1,
        fromUserName: 'João Pedro Silva',
        message: 'curtiu sua receita "Omelete Simples"',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
        recipeId: 25,
        recipeName: 'Omelete Simples',
      ),
    ],

    // ===== NOTIFICAÇÕES DO PEDRO (userId: 9) =====
    9: [
      AppNotification(
        id: 39,
        type: NotificationType.follow,
        fromUserId: 4,
        fromUserName: 'Ana Beatriz Costa',
        fromUserImage: 'assets/images/chef.jpg',
        message: 'começou a seguir você',
        timestamp: DateTime.now().subtract(Duration(hours: 4)),
        isRead: false,
      ),
      AppNotification(
        id: 40,
        type: NotificationType.like,
        fromUserId: 1,
        fromUserName: 'João Pedro Silva',
        message: 'curtiu sua receita "Tapioca Recheada"',
        timestamp: DateTime.now().subtract(Duration(hours: 8)),
        isRead: true,
        recipeId: 20,
        recipeName: 'Tapioca Recheada',
      ),
      AppNotification(
        id: 41,
        type: NotificationType.save,
        fromUserId: 6,
        fromUserName: 'Juliana Ferreira',
        message: 'salvou sua receita "Açaí na Tigela"',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
        recipeId: 21,
        recipeName: 'Açaí na Tigela',
      ),
      AppNotification(
        id: 42,
        type: NotificationType.comment,
        fromUserId: 10,
        fromUserName: 'Fernanda Gomes',
        message: 'comentou: "Perfeito para o café da manhã!"',
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        isRead: true,
        recipeId: 20,
        recipeName: 'Tapioca Recheada',
      ),
    ],

    // ===== NOTIFICAÇÕES DA FERNANDA (userId: 10) =====
    10: [
      AppNotification(
        id: 43,
        type: NotificationType.follow,
        fromUserId: 1,
        fromUserName: 'João Pedro Silva',
        message: 'começou a seguir você',
        timestamp: DateTime.now().subtract(Duration(minutes: 20)),
        isRead: false,
      ),
      AppNotification(
        id: 44,
        type: NotificationType.follow,
        fromUserId: 6,
        fromUserName: 'Juliana Ferreira',
        message: 'começou a seguir você',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isRead: false,
      ),
      AppNotification(
        id: 45,
        type: NotificationType.like,
        fromUserId: 4,
        fromUserName: 'Ana Beatriz Costa',
        fromUserImage: 'assets/images/chef.jpg',
        message: 'curtiu sua receita "Brigadeiro Gourmet"',
        timestamp: DateTime.now().subtract(Duration(hours: 4)),
        isRead: true,
        recipeId: 22,
        recipeName: 'Brigadeiro Gourmet',
      ),
      AppNotification(
        id: 46,
        type: NotificationType.like,
        fromUserId: 2,
        fromUserName: 'Maria Santos',
        message: 'curtiu sua receita "Panqueca Americana"',
        timestamp: DateTime.now().subtract(Duration(hours: 10)),
        isRead: true,
        recipeId: 23,
        recipeName: 'Panqueca Americana',
      ),
      AppNotification(
        id: 47,
        type: NotificationType.comment,
        fromUserId: 1,
        fromUserName: 'João Pedro Silva',
        message: 'comentou: "Brigadeiro perfeito! 🍫"',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
        recipeId: 22,
        recipeName: 'Brigadeiro Gourmet',
      ),
      AppNotification(
        id: 48,
        type: NotificationType.save,
        fromUserId: 6,
        fromUserName: 'Juliana Ferreira',
        message: 'salvou sua receita "Smoothie de Frutas"',
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        isRead: true,
        recipeId: 24,
        recipeName: 'Smoothie de Frutas',
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
    if (targetUserId == fromUserId) return;

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