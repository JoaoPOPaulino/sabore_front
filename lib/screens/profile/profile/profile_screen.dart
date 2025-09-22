import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String selectedTab = 'Receitas';
  bool isLoading = false;

  // Dados simulados (substitua pela sua API)
  final Map<String, dynamic> userData = {
    'username': 'hemchrsz',
    'name': 'Hemilly',
    'location': 'Palmas - TO',
    'profileImage': 'assets/images/chef.jpg',
    'recipesCount': 8,
    'followersCount': 432,
    'followingCount': 100,
    'isFollowing': false,
    'averageRating': 4.5,
  };

  final List<Map<String, dynamic>> userRecipes = [
    {
      'name': 'Brownie zero açúcar',
      'time': '21 min',
      'image': 'assets/images/chef.jpg'
    },
    {
      'name': 'Lasanha de panela',
      'time': '27 min',
      'image': 'assets/images/chef.jpg'
    },
  ];

  final List<Map<String, dynamic>> userReviews = [
    {
      'user': 'Danilo Belém',
      'avatar': 'assets/images/chef.jpg',
      'rating': 4,
      'comment': 'Fiz a receita e gostei muito, o macarrão demora um pouco pra amolecer mas tudo ok, coloquei mais temperos e gostei muito.',
      'image': 'assets/images/chef.jpg',
    },
    {
      'user': 'hem_brinaa',
      'avatar': 'assets/images/chef.jpg',
      'rating': 5,
      'comment': 'Fiz a farofa natalina aqui em casa e todo mundo amou, to aqui avaliando só pra dizer que façaaammmmm!!',
      'image': null,
    },
    {
      'user': 'Maria',
      'avatar': 'assets/images/chef.jpg',
      'rating': 4,
      'comment': 'Adoro doce amei a receitaaa, só troquei a manteiga',
      'image': 'assets/images/chef.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(),
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

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
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
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFFA9500),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.share, color: Colors.white, size: 20),
            onPressed: () {
              // Implementar compartilhamento
              print('Share profile');
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/chef.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      transform: Matrix4.translationValues(0, -80, 0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(userData['profileImage']),
            backgroundColor: Colors.white,
          ),
          SizedBox(height: 12),
          Text(
            userData['username'],
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 28,
              color: Color(0xFFFA9500),
            ),
          ),
          Text(
            userData['location'],
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFFFA9500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn('${userData['recipesCount']}', 'Receitas'),
          _buildStatColumn('${userData['followersCount']}', 'Seguidores'),
          _buildStatColumn('${userData['followingCount']}', 'Seguindo'),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String number, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Seguidores') {
          print('Navigate to followers');
        } else if (label == 'Seguindo') {
          print('Navigate to following');
        }
      },
      child: Column(
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
      ),
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
        return _buildRecipesTab();
      case 'Galeria':
        return _buildGalleryTab();
      case 'Avaliações':
        return _buildReviewsTab();
      default:
        return _buildRecipesTab();
    }
  }

  Widget _buildRecipesTab() {
    return Container(
      padding: EdgeInsets.all(20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: userRecipes.length,
        itemBuilder: (context, index) {
          final recipe = userRecipes[index];
          return _buildRecipeCard(recipe);
        },
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return GestureDetector(
      onTap: () {
        print('Recipe tapped: ${recipe['name']}');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(recipe['image']),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    recipe['time'],
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                recipe['name'],
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryTab() {
    // Grid assimétrico como na imagem
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              // Card grande esquerda
              Expanded(
                flex: 2,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage('assets/images/chef.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              // Coluna direita
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      height: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage('assets/images/chef.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage('assets/images/chef.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage('assets/images/chef.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage('assets/images/chef.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage('assets/images/chef.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating header
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF7CB342),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${userData['averageRating']}',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              // Fotos das reviews
              Row(
                children: List.generate(4, (index) {
                  if (index == 3) {
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black54,
                      ),
                      child: Center(
                        child: Text(
                          '+23',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
                  return Container(
                    margin: EdgeInsets.only(right: 4),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage('assets/images/chef.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Reviews list
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: userReviews.length,
            itemBuilder: (context, index) {
              return _buildReviewCard(userReviews[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(review['avatar']),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['user'],
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review['rating'] ? Icons.star : Icons.star_border,
                          color: Color(0xFFFA9500),
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            review['comment'],
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.4,
            ),
          ),
          if (review['image'] != null) ...[
            SizedBox(height: 12),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(review['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}