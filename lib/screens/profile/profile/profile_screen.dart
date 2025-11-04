import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/profile_image_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String selectedTab = 'Receitas';

  @override
  Widget build(BuildContext context) {
    final currentUserData = ref.watch(currentUserDataProvider);
    final bool isOwnProfile = widget.userId == currentUserData?['id'];

    if (!isOwnProfile) {
      return _buildOtherUserProfile();
    }

    if (currentUserData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(currentUserData),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(currentUserData),
                _buildStatsSection(),
                _buildTabButtons(),
                _buildTabContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(Map<String, dynamic> userData) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
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
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 8, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Color(0xFFFA9500),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.settings, color: Colors.white, size: 20),
            onPressed: () => context.push('/settings'),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildCoverImage(userData),
      ),
    );
  }

  Widget _buildCoverImage(Map<String, dynamic> userData) {
    final hasCoverImage = (kIsWeb && userData['coverImageBytes'] != null) ||
        (!kIsWeb && userData['coverImage'] != null);

    if (!hasCoverImage) {
      // Fundo padrão bonito quando não tem capa
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFA9500).withOpacity(0.3),
              Color(0xFF7CB342).withOpacity(0.3),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Padrão decorativo
            Positioned(
              top: 20,
              right: -30,
              child: Icon(
                Icons.restaurant,
                size: 150,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Positioned(
              bottom: 20,
              left: -20,
              child: Icon(
                Icons.local_dining,
                size: 120,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ],
        ),
      );
    }

    // Com imagem de capa
    ImageProvider? imageProvider;
    if (kIsWeb && userData['coverImageBytes'] != null) {
      imageProvider = MemoryImage(userData['coverImageBytes'] as Uint8List);
    } else if (!kIsWeb && userData['coverImage'] != null) {
      imageProvider = FileImage(File(userData['coverImage']));
    }

    return Container(
      decoration: BoxDecoration(
        image: imageProvider != null
            ? DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        )
            : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.white.withOpacity(0.3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> userData) {
    return Transform.translate(
      offset: Offset(0, -60),
      child: Column(
        children: [
          // Foto de perfil com borda branca
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ProfileImageWidget(userData: userData, radius: 55),
          ),
          SizedBox(height: 12),
          // Username
          Text(
            '@${userData['username'] ?? 'username'}',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Color(0xFFFA9500),
            ),
          ),
          SizedBox(height: 4),
          // Nome completo
          Text(
            userData['name'] ?? 'Usuário',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, -40, 20, 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFFFF8F0),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn('0', 'Receitas'),
          Container(
            height: 40,
            width: 1,
            color: Color(0xFFE0E0E0),
          ),
          _buildStatColumn('0', 'Seguidores'),
          Container(
            height: 40,
            width: 1,
            color: Color(0xFFE0E0E0),
          ),
          _buildStatColumn('0', 'Seguindo'),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Color(0xFF3C4D18),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildTabButton('Receitas')),
          SizedBox(width: 8),
          Expanded(child: _buildTabButton('Galeria')),
          SizedBox(width: 8),
          Expanded(child: _buildTabButton('Avaliações')),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title) {
    bool isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = title),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFA9500) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Color(0xFFFA9500) : Color(0xFFE0E0E0),
            width: 2,
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isSelected ? Colors.white : Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 'Receitas':
        return _buildEmptyState(
          icon: Icons.restaurant_menu,
          title: 'Nenhuma receita ainda',
          subtitle: 'Compartilhe suas receitas favoritas!',
          buttonText: 'Adicionar Receita',
          onPressed: () => context.push('/add-recipe'),
        );
      case 'Galeria':
        return _buildEmptyState(
          icon: Icons.photo_library,
          title: 'Galeria vazia',
          subtitle: 'Suas fotos aparecerão aqui',
        );
      case 'Avaliações':
        return _buildEmptyState(
          icon: Icons.star_border,
          title: 'Sem avaliações',
          subtitle: 'Suas avaliações aparecerão aqui',
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Color(0xFFE0E0E0)),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Color(0xFF666666),
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
          if (buttonText != null && onPressed != null) ...[
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFA9500),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOtherUserProfile() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 100, color: Color(0xFFE0E0E0)),
            SizedBox(height: 20),
            Text(
              'Perfil de outro usuário',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}