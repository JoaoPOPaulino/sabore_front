import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/profile_image_widget.dart';

class UserInfoScreen extends ConsumerWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(currentUserDataProvider);

    if (userData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFFFA9500))),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color(0xFFFAFAFA),
            elevation: 0,
            pinned: true,
            // ✨ CORREÇÃO AQUI: Aumentado de 250 para 260
            expandedHeight: 260.0,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF7CB342),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back, // Ícone padrão
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            title: Text(
              'Informações',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Color(0xFF3C4D18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80.0), // Ajusta para baixo do appbar
                  child: Column(
                    children: [
                      ProfileImageWidget(userData: userData, radius: 50),
                      SizedBox(height: 16),
                      Text(
                        userData['name'] ?? 'Usuário',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Color(0xFF3C4D18),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '@${userData['username'] ?? 'username'}',
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
            ),
          ),

          // O resto do seu conteúdo
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildInfoSection(
                  'Email',
                  userData['email'] ?? 'Não informado',
                  Icons.email_outlined,
                ),
                _buildInfoSection(
                  'Telefone',
                  userData['phone'] ?? 'Não informado',
                  Icons.phone_outlined,
                ),
                _buildInfoSection(
                  'Username',
                  userData['username'] ?? 'Não definido',
                  Icons.alternate_email,
                ),
                _buildInfoSection(
                  'Membro desde',
                  'Recentemente', // TODO: Formatar data
                  Icons.calendar_today_outlined,
                ),
                SizedBox(height: 30),
                Text(
                  'Estatísticas',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFF3C4D18),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('0', 'Receitas\npublicadas'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard('0', 'Total de\nseguidores'),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('0', 'Receitas\nsalvas'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard('⭐', 'Avaliação\nmédia'),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFFA9500).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Color(0xFFFA9500),
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF3C4D18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFA9500).withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color(0xFFFA9500).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Color(0xFFFA9500),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              color: Color(0xFF666666),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}