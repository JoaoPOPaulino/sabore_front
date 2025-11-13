// lib/screens/profile/followers_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sabore_app/providers/auth_provider.dart';
import 'package:sabore_app/widgets/profile_image_widget.dart';

class FollowersScreen extends ConsumerStatefulWidget {
  final int userId;
  final String userName;

  const FollowersScreen({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  ConsumerState<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends ConsumerState<FollowersScreen> {
  final Set<int> _loadingUsers = {};

  @override
  Widget build(BuildContext context) {
    final followersAsync = ref.watch(followersProvider(widget.userId));
    final currentUserId = ref.watch(currentUserDataProvider)?['id'] as int?;
    final isOwnProfile = widget.userId == currentUserId;

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF3C4D18)),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seguidores',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3C4D18),
              ),
            ),
            Text(
              widget.userName,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
      body: followersAsync.when(
        data: (followers) {
          if (followers.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: followers.length,
            itemBuilder: (context, index) {
              final follower = followers[index];
              final followerId = follower['id'] as int;
              final isLoading = _loadingUsers.contains(followerId);

              // Verifica se o usuário atual segue este seguidor
              final followStateAsync = currentUserId != null
                  ? ref.watch(followStateProvider(followerId))
                  : false;

              return _buildFollowerCard(
                follower,
                followStateAsync,
                isLoading,
                isOwnProfile,
              );
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFA9500),
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Erro ao carregar seguidores',
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

  Widget _buildFollowerCard(
      Map<String, dynamic> follower,
      bool isFollowing,
      bool isLoading,
      bool isOwnProfile,
      ) {
    return GestureDetector(
      onTap: () => context.push('/profile/${follower['id']}'),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ProfileImageWidget(
              userData: follower,
              radius: 28,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    follower['name'] ?? 'Usuário',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '@${follower['username'] ?? 'username'}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            // Mostrar botão apenas se não for o próprio perfil
            if (!isOwnProfile && follower['id'] != ref.watch(currentUserDataProvider)?['id'])
              _buildActionButton(follower['id'], isFollowing, isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(int userId, bool isFollowing, bool isLoading) {
    return SizedBox(
      width: 110,
      height: 36,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _handleFollowToggle(userId),
        style: ElevatedButton.styleFrom(
          backgroundColor: isFollowing ? Colors.white : Color(0xFF7CB342),
          foregroundColor: isFollowing ? Color(0xFF7CB342) : Colors.white,
          side: BorderSide(
            color: Color(0xFF7CB342),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              isFollowing ? Color(0xFF7CB342) : Colors.white,
            ),
          ),
        )
            : Text(
          isFollowing ? 'Seguindo' : 'Seguir',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Future<void> _handleFollowToggle(int userIdToFollow) async {
    final currentUserId = ref.read(currentUserDataProvider)?['id'] as int?;
    if (currentUserId == null) return;

    setState(() {
      _loadingUsers.add(userIdToFollow);
    });

    try {
      final authService = ref.read(authServiceProvider);
      final isNowFollowing = await authService.toggleFollow(userIdToFollow);

      // ✅ INVALIDAR TODOS OS PROVIDERS RELACIONADOS
      ref.invalidate(followersProvider(widget.userId));
      ref.invalidate(followersCountProvider(widget.userId));
      ref.invalidate(followingProvider(currentUserId));
      ref.invalidate(followingCountProvider(currentUserId));
      ref.invalidate(followStateProvider(userIdToFollow));
      ref.invalidate(userProfileProvider(widget.userId));
      ref.invalidate(userProfileProvider(currentUserId));
      ref.invalidate(userProfileProvider(userIdToFollow));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isNowFollowing
                  ? 'Você começou a seguir este chef!'
                  : 'Você deixou de seguir este chef',
            ),
            backgroundColor: isNowFollowing ? Color(0xFF7CB342) : Color(0xFF999999),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao seguir/deixar de seguir'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingUsers.remove(userIdToFollow);
        });
      }
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFFFFF3E0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 64,
              color: Color(0xFFFA9500),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Nenhum seguidor ainda',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Quando alguém seguir este perfil,\naparecerá aqui',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }
}