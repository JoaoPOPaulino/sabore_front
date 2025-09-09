import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/custom_button.dart';

class HomeScreen extends ConsumerWidget {
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

                // Título principal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'O que você quer\ncozinhar hoje?',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color(0xFF3C4D18),
                        height: 1.2,
                      ),
                    ),
                    Icon(
                      Icons.filter_list,
                      color: Color(0xFFFA9500),
                      size: 24,
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Botões de categoria
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryButton('Receitas Juninas'),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildCategoryButton('Brownie'),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildCategoryButton('Pizza'),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Receita do dia
                Text(
                  'Receita do dia',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF3C4D18),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage('assets/images/chef.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.darken
                      ),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Canjica zero lactose',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Estados Brasileiros
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estados Brasileiros',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/states'),
                      child: Text(
                        'Ver tudo',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xFF3C4D18),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStateCard('Tocantins', '50 receitas'),
                      SizedBox(width: 12),
                      _buildStateCard('Minas Gerais', '40 receitas'),
                      SizedBox(width: 12),
                      _buildStateCard('Goiás', '70 receitas'),
                      SizedBox(width: 12),
                      _buildStateCard('Maranhão', '30 receitas'),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                // Top Receitas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Receitas',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
                    Text(
                      'Ver tudo',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                // Cards de receitas
                _buildTopRecipeCard(
                  'Bolo de milho sem açúcar',
                  '1h20min • 9 ingredientes',
                  'assets/images/chef.jpg',
                ),
                SizedBox(height: 12),
                _buildTopRecipeCard(
                  'Brownie de chocolate',
                  '45min • 8 ingredientes',
                  'assets/images/chef.jpg',
                ),
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
                    icon: Icon(Icons.home, color: Color(0xFFFA9500), size: 28),
                    onPressed: () {},
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

  Widget _buildCategoryButton(String text) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Color(0xFFFA9500),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStateCard(String state, String recipeCount) {
    return Container(
      width: 120,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage('assets/images/chef.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2),
            Text(
              recipeCount,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                fontSize: 10,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRecipeCard(String title, String subtitle, String imagePath) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_border,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '1h20min',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.restaurant, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '9 ingredientes',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}