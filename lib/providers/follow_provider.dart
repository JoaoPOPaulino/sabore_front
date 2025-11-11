import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import '../services/mock_auth_service.dart';

final followStateProvider = StateNotifierProvider<FollowStateNotifier, Map<int, bool>>((ref) {
  return FollowStateNotifier(ref);
});

class FollowStateNotifier extends StateNotifier<Map<int, bool>> {
  final Ref ref;

  FollowStateNotifier(this.ref) : super({});

  Future<void> loadFollowingStatus(int currentUserId, List<int> userIds) async {
    final authService = ref.read(authServiceProvider) as MockAuthService;
    final following = await authService.getFollowing(currentUserId);
    final followingIds = following.map((u) => u['id'] as int).toSet();

    final newState = <int, bool>{};
    for (final userId in userIds) {
      newState[userId] = followingIds.contains(userId);
    }
    state = {...state, ...newState};
  }

  Future<bool> toggleFollow(int userIdToFollow) async {
    final authService = ref.read(authServiceProvider) as MockAuthService;

    try {
      final isNowFollowing = await authService.toggleFollow(userIdToFollow);

      state = {
        ...state,
        userIdToFollow: isNowFollowing,
      };

      ref.invalidate(userProfileProvider);
      ref.invalidate(currentUserDataProvider);

      return isNowFollowing;
    } catch (e) {
      print('Erro ao seguir/deixar de seguir: $e');
      rethrow;
    }
  }

  bool isFollowing(int userId) {
    return state[userId] ?? false;
  }
}

final followersProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, userId) async {
  final authService = ref.read(authServiceProvider) as MockAuthService;
  return await authService.getFollowers(userId);
});

final followingProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, userId) async {
  final authService = ref.read(authServiceProvider) as MockAuthService;
  return await authService.getFollowing(userId);
});

final followersCountProvider = FutureProvider.family<int, int>((ref, userId) async {
  final followers = await ref.watch(followersProvider(userId).future);
  return followers.length;
});

final followingCountProvider = FutureProvider.family<int, int>((ref, userId) async {
  final following = await ref.watch(followingProvider(userId).future);
  return following.length;
});