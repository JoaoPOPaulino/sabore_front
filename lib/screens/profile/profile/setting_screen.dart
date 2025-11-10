import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/profile_image_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(currentUserDataProvider);

    if (userData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFFFA9500))),
      );
    }

    final phoneVerified = userData['phoneVerified'] ?? false;

    return Scaffold(
      // ✨ MUDANÇA: Fundo principal do app, igual da Home
      backgroundColor: Color(0xFFFAFAFA),

      // ✨ MUDANÇA: Substituído AppBar + SingleChildScrollView por CustomScrollView
      body: CustomScrollView(
        slivers: [
          // ✨ MUDANÇA: Header customizado que encolhe
          SliverAppBar(
            backgroundColor: Color(0xFFFAFAFA),
            elevation: 0,
            pinned: true, // Mantém o título no topo
            expandedHeight: 200.0, // Altura do card de perfil
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF7CB342),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back, // Mais padrão
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            title: Text(
              'Configurações',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Color(0xFF3C4D18),
              ),
            ),
            // ✨ MUDANÇA: O Card de Perfil agora vive dentro do header
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
                child: _buildProfileCard(context, userData),
              ),
            ),
          ),

          // ✨ MUDANÇA: Conteúdo agora é uma SliverList
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 30),

                // ✨ NOVO: Cabeçalho de seção
                _buildSectionHeader('Conta'),
                SizedBox(height: 12),

                _buildSettingsOption(
                  context,
                  icon: Icons.info_outline,
                  title: 'Info',
                  onTap: () => context.push('/user-info'),
                ),

                SizedBox(height: 12),

                // ✅ OPÇÃO DE VERIFICAR TELEFONE
                _buildSettingsOption(
                  context,
                  icon: Icons.phone_android,
                  title: phoneVerified ? 'Telefone Verificado ✓' : 'Verificar Telefone',
                  subtitle: phoneVerified ? null : 'Recomendado para recuperação de senha',
                  isVerified: phoneVerified,
                  onTap: () {
                    if (phoneVerified) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('✅ Telefone já verificado!'),
                          backgroundColor: Color(0xFF7CB342),
                        ),
                      );
                    } else {
                      context.push('/verify-phone');
                    }
                  },
                ),

                SizedBox(height: 24),

                // ✨ NOVO: Cabeçalho de seção
                _buildSectionHeader('Geral'),
                SizedBox(height: 12),

                _buildSettingsOption(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Notificações',
                  onTap: () => context.push('/notifications'),
                ),

                SizedBox(height: 12),

                _buildSettingsOption(
                  context,
                  icon: Icons.lock_outline,
                  title: 'Privacidade',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Em breve!')),
                    );
                  },
                ),

                SizedBox(height: 12),

                _buildSettingsOption(
                  context,
                  icon: Icons.help_outline,
                  title: 'Suporte',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Em breve!')),
                    );
                  },
                ),

                SizedBox(height: 24), // Mais espaço antes do Logout

                _buildSettingsOption(
                  context,
                  icon: Icons.logout,
                  title: 'Logout',
                  isDestructive: true,
                  onTap: () => _showLogoutDialog(context, ref),
                ),

                SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ✨ NOVO: Widget de cabeçalho
  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: Color(0xFF999999),
        letterSpacing: 1.2,
      ),
    );
  }

  // ✨ MUDANÇA: Extraí o card de perfil para um widget
  Widget _buildProfileCard(BuildContext context, Map<String, dynamic> userData) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Color(0xFFFA9500),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFA9500).withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 5),
            )
          ]
      ),
      child: Row(
        children: [
          ProfileImageWidget(userData: userData, radius: 35),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Para não quebrar no FlexibleSpace
              children: [
                Text(
                  userData['name'] ?? 'Usuário',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  userData['email'] ?? '',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/edit-profile'),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? subtitle,
        required VoidCallback onTap,
        bool isDestructive = false,
        bool isVerified = false,
      }) {
    // ✨ Cor de fundo base
    Color bgColor = Color(0xFFFFF3E0);
    // ✨ Cor do ícone e texto
    Color contentColor = Color(0xFF3C4D18);
    // ✨ Borda
    Border? border;

    if (isDestructive) {
      bgColor = Color(0xFFFFEBEE); // Vermelho claro
      contentColor = Color(0xFFD32F2F); // Vermelho escuro
    } else if (isVerified) {
      bgColor = Color(0xFFF1F8E9); // Verde bem claro
      contentColor = Color(0xFF7CB342); // Verde
      border = Border.all(color: Color(0xFF7CB342).withOpacity(0.3), width: 1.5);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: border,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: contentColor,
              size: 24,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: isVerified || isDestructive
                          ? FontWeight.w600
                          : FontWeight.w500,
                      fontSize: 16,
                      color: contentColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: contentColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Confirmar Logout',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            color: Color(0xFF3C4D18),
          ),
        ),
        content: Text(
          'Tem certeza que deseja sair?',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Color(0xFF666666),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Color(0xFF666666),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context).pop();
                context.go('/onboarding');
              }
            },
            child: Text(
              'Sair',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}