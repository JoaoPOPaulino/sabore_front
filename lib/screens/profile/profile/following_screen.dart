// lib/screens/profile/following_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sabore_app/providers/auth_provider.dart';
import 'package:sabore_app/widgets/profile_image_widget.dart';

class FollowingScreen extends ConsumerStatefulWidget {
  final int userId;
  final String userName;

  const FollowingScreen({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  ConsumerState<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends ConsumerState<FollowingScreen> {
  final Set<int> _loadingUsers = {};

  @override
  Widget build(BuildContext context) {
    final followingAsync = ref.watch(followingProvider(widget.userId));

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
              'Seguindo',
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
      body: followingAsync.when(
        data: (following) {
          if (following.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: following.length,
            itemBuilder: (context, index) {
              final user = following[index];
              final userId = user['id'] as int;
              final isLoading = _loadingUsers.contains(userId);

              return _buildUserCard(user, isLoading);
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
                'Erro ao carregar lista',
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

  Widget _buildUserCard(Map<String, dynamic> user, bool isLoading) {
    final currentUserId = ref.watch(currentUserDataProvider)?['id'] as int?;
    final canUnfollow = widget.userId == currentUserId;

    return GestureDetector(
      onTap: () => context.push('/profile/${user['id']}'),
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
              userData: user,
              radius: 28,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['name'] ?? 'Usuário',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '@${user['username'] ?? 'username'}',
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
            if (canUnfollow)
              _buildUnfollowButton(user['id'], isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildUnfollowButton(int userId, bool isLoading) {
    return SizedBox(
      width: 130,
      height: 36,
      child: OutlinedButton(
        onPressed: isLoading ? null : () => _showUnfollowConfirmation(userId),
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFFE91E63),
          side: BorderSide(
            color: Color(0xFFE91E63),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
        ),
        child: isLoading
            ? SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
          ),
        )
            : Text(
          'Deixar de seguir',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _showUnfollowConfirmation(int userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Deixar de seguir?',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF3C4D18),
          ),
        ),
        content: Text(
          'Você tem certeza que deseja deixar de seguir este chef?',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: Color(0xFF999999),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleUnfollow(userId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE91E63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Deixar de seguir',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleUnfollow(int userIdToUnfollow) async {
    final currentUserId = ref.read(currentUserDataProvider)?['id'] as int?;
    if (currentUserId == null) return;

    setState(() {
      _loadingUsers.add(userIdToUnfollow);
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.toggleFollow(userIdToUnfollow);

      // ✅ INVALIDAR TODOS OS PROVIDERS RELACIONADOS
      ref.invalidate(followingProvider(widget.userId));
      ref.invalidate(followingCountProvider(widget.userId));
      ref.invalidate(followersProvider(userIdToUnfollow));
      ref.invalidate(followersCountProvider(userIdToUnfollow));
      ref.invalidate(followStateProvider(userIdToUnfollow));
      ref.invalidate(userProfileProvider(widget.userId));
      ref.invalidate(userProfileProvider(currentUserId));
      ref.invalidate(userProfileProvider(userIdToUnfollow));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Você deixou de seguir este chef'),
            backgroundColor: Color(0xFF999999),
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
            content: Text('Erro ao deixar de seguir'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingUsers.remove(userIdToUnfollow);
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
              Icons.person_add_outlined,
              size: 64,
              color: Color(0xFFFA9500),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Não está seguindo ninguém',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Quando seguir alguém,\naparecerá aqui',
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