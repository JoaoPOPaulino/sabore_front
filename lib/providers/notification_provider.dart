import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mock_notification_service.dart';
import 'auth_provider.dart';

final notificationServiceProvider = Provider<MockNotificationService>((ref) {
  return MockNotificationService();
});

final notificationsProvider = StreamProvider.autoDispose<List<AppNotification>>((ref) async* {
  final currentUser = ref.watch(currentUserDataProvider);
  if (currentUser == null) {
    yield [];
    return;
  }

  final userId = currentUser['id'] as int;
  final service = ref.watch(notificationServiceProvider);

  // Carregar notificações iniciais
  final initialNotifications = await service.getNotifications(userId);
  yield initialNotifications;

  // Escutar novas notificações
  await for (final newNotification in service.notificationStream) {
    final updatedNotifications = await service.getNotifications(userId);
    yield updatedNotifications;
  }
});

final unreadNotificationCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final currentUser = ref.watch(currentUserDataProvider);
  if (currentUser == null) return 0;

  final userId = currentUser['id'] as int;
  final service = ref.watch(notificationServiceProvider);

  return await service.getUnreadCount(userId);
});