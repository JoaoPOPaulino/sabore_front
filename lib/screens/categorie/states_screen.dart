import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Conteúdo principal
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/chef.jpg'),
                    ),
                    Text(
                      'Saborê',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                        color: Color(0xFFFA9500),
                      ),
                    ),
                    Icon(
                      Icons.search,
                      color: Color(0xFFFA9500),
                      size: 28,
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Título e filtro
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estados',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
                    Icon(
                      Icons.tune,
                      color: Color(0xFFFA9500),
                      size: 24,
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Grid de estados
                _buildStatesGrid(),
              ],
            ),
          ),

          // Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFF3C4D18),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.home, color: Colors.white, size: 28),
                    onPressed: () => context.go('/home'),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: Color(0xFFFA9500),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white, size: 28),
                      onPressed: () {},
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.person, color: Colors.white, size: 28),
                    onPressed: () => context.push('/setup-profile'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatesGrid() {
    return Column(
      children: [
        // Primeira linha - Tocantins e Minas Gerais
        Row(
          children: [
            // Tocantins (menor)
            Expanded(
              flex: 3,
              child: _buildStateCard(
                'Tocantins',
                '50 receitas',
                'assets/images/chef.jpg',
                height: 200,
              ),
            ),
            SizedBox(width: 12),
            // Minas Gerais (maior)
            Expanded(
              flex: 4,
              child: _buildStateCard(
                'Minas Gerais',
                '40 receitas',
                'assets/images/chef.jpg',
                height: 280,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),

        // Segunda linha - Goiás e Maranhão
        Row(
          children: [
            // Goiás (maior)
            Expanded(
              flex: 4,
              child: _buildStateCard(
                'Goiás',
                '70 receitas',
                'assets/images/chef.jpg',
                height: 200,
              ),
            ),
            SizedBox(width: 12),
            // Maranhão (menor)
            Expanded(
              flex: 3,
              child: _buildStateCard(
                'Maranhão',
                '30 receitas',
                'assets/images/chef.jpg',
                height: 280,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),

        // Terceira linha - Estados menores
        Row(
          children: [
            Expanded(
              child: _buildStateCard(
                'Bahia',
                '85 receitas',
                'assets/images/chef.jpg',
                height: 140,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStateCard(
                'São Paulo',
                '120 receitas',
                'assets/images/chef.jpg',
                height: 140,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),

        // Quarta linha
        Row(
          children: [
            Expanded(
              child: _buildStateCard(
                'Rio de Janeiro',
                '95 receitas',
                'assets/images/chef.jpg',
                height: 140,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStateCard(
                'Pernambuco',
                '60 receitas',
                'assets/images/chef.jpg',
                height: 140,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStateCard(String state, String recipeCount, String imagePath, {required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              recipeCount,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}