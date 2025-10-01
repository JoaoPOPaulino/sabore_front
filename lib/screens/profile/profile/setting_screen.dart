import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),

            // Card do perfil
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFFA9500),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/images/chef.jpg'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tayse Virgulino',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Palmas - TO',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navegar para edição de perfil
                      context.push('/edit-profile');
                    },
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
            ),

            SizedBox(height: 30),

            // Opções de configuração
            _buildSettingsOption(
              context,
              icon: Icons.info_outline,
              title: 'Info',
              onTap: () {
                print('Info tapped');
                context.push('/user-info');
              },
            ),

            SizedBox(height: 12),

            _buildSettingsOption(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notificações',
              onTap: () {
                print('Notifications tapped');
                context.push('/notifications');
              },
            ),

            SizedBox(height: 12),

            _buildSettingsOption(
              context,
              icon: Icons.lock_outline,
              title: 'Privacidade',
              onTap: () {
                print('Privacy tapped');
                // Navegar para tela de privacidade
              },
            ),

            SizedBox(height: 12),

            _buildSettingsOption(
              context,
              icon: Icons.help_outline,
              title: 'Suporte',
              onTap: () {
                print('Support tapped');
                // Navegar para tela de suporte
              },
            ),

            SizedBox(height: 12),

            _buildSettingsOption(
              context,
              icon: Icons.logout,
              title: 'Logout',
              isDestructive: true,
              onTap: () {
                // Mostrar confirmação de logout
                _showLogoutDialog(context, ref);
              },
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        bool isDestructive = false,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : Color(0xFF3C4D18),
              size: 24,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: isDestructive ? Colors.red : Color(0xFF3C4D18),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDestructive ? Colors.red : Color(0xFF3C4D18),
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
            onPressed: () => context.pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Color(0xFF666666),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Fazer logout
              // ref.read(authProvider.notifier).logout();
              context.pop();
              context.go('/onboarding');
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