import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/select_recipe_book_modal.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isBookmarked = false;
  bool showFullIngredients = false;

  final Map<String, dynamic> recipe = {
    'name': 'Canjica zero lactose',
    'author': 'hemchrsz',
    'authorImage': 'assets/images/chef.jpg',
    'recipesCount': '8 Receitas',
    'rating': 4.5,
    'image': 'assets/images/chef.jpg',
    'calories': 300,
    'salt': 'Sem',
    'lactose': 'Zero',
    'ingredients': [
      {'amount': '1000g', 'name': 'Leite zero lactose'},
      {'amount': '1', 'name': 'Milho de canjica'},
      {'amount': '100g', 'name': 'Açúcar'},
      {'amount': '20g', 'name': 'Canela'},
      {'amount': '50g', 'name': 'Leite condensado zero lactose'},
      {'amount': '1 colher', 'name': 'Essência de baunilha'},
    ],
    'preparation': [
      'Deixe a canjica de molho na água por 24 horas.',
      'Transfira a receita de canjica embebida para uma panela grande junto com a água do molho.',
      'Adicione o cravo e a canela e cozinhe sua canjica até milho ficar macio.',
      'Acrescente o açúcar, o leite, o leite condensado e o coco. Com a panela destampada, cozinhe até engrossar.',
      'Desligue o fogo e acrescente o creme de leite. Misture até a canjica ficar doce.',
      'Pronto, agora você já sabe como fazer canjica cremosa!'
    ],
    'gallery': [
      'assets/images/chef.jpg',
      'assets/images/chef.jpg',
      'assets/images/chef.jpg',
    ],
    'comments': [
      {
        'user': 'hem_brinaa',
        'text': 'Usei um xicara não soleou receita fiz e ficou maravilhosa obrigada',
        'likes': 5,
        'avatar': 'assets/images/chef.jpg',
      },
      {
        'user': 'Maria Clara',
        'text': 'Receita muito simples de entender, amei',
        'likes': 3,
        'avatar': 'assets/images/chef.jpg',
      },
      {
        'user': 'Danilo Belém',
        'text': 'Estou começando agora e adoro, me faz!',
        'likes': 2,
        'avatar': 'assets/images/chef.jpg',
      },
      {
        'user': 'Ana Paula',
        'text': 'Bom dia de fiz para meu restaurante, é um sucesso',
        'likes': 8,
        'avatar': 'assets/images/chef.jpg',
      },
      {
        'user': 'hemchrsz',
        'text': 'Fico contente que deu certo!',
        'likes': 12,
        'avatar': 'assets/images/chef.jpg',
      },
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRecipeHeader(),
                _buildNutritionalInfo(),
                _buildIngredientsSection(),
                if (showFullIngredients) _buildFullRecipeContent(),
                SizedBox(height: 20),
                _buildCookButton(),
                if (!showFullIngredients) ...[
                  SizedBox(height: 30),
                  _buildGallerySection(),
                  SizedBox(height: 30),
                  _buildCommentsSection(),
                ],
                SizedBox(height: 100),
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
            color: isBookmarked ? Color(0xFFFA9500) : Color(0xFF3C4D18),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              if (!isBookmarked) {
                _showBookmarkModal();
              } else {
                setState(() {
                  isBookmarked = false;
                });
              }
            },
          ),
        ),
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF7CB342),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.star, color: Colors.white, size: 20),
            onPressed: () {},
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(recipe['image']),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe['name'],
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(recipe['authorImage']),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe['author'],
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF3C4D18),
                  ),
                ),
                Text(
                  recipe['recipesCount'],
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
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
                  '${recipe['rating']}',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
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

  Widget _buildNutritionalInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNutritionalItem(
            Icons.local_fire_department,
            '${recipe['calories']}',
            'Calorias',
          ),
          _buildNutritionalItem(
            Icons.grain,
            recipe['salt'],
            'Sal',
          ),
          _buildNutritionalItem(
            Icons.opacity,
            recipe['lactose'],
            'Lactose',
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFFFA9500), size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF3C4D18),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    final displayIngredients = showFullIngredients
        ? recipe['ingredients']
        : recipe['ingredients'].take(1).toList();

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredientes',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 16),
          ...displayIngredients.map((ingredient) => Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  ingredient['amount'],
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFFFA9500),
                  ),
                ),
                Container(
                  width: 2,
                  height: 20,
                  color: Color(0xFFFA9500),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                ),
                Expanded(
                  child: Text(
                    ingredient['name'],
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildFullRecipeContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'Modo de preparo',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 16),
          ...recipe['preparation'].asMap().entries.map((entry) {
            int index = entry.key;
            String step = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFFFA9500),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF666666),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCookButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            showFullIngredients = !showFullIngredients;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFA9500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
          minimumSize: Size(double.infinity, 50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              showFullIngredients ? 'Voltar' : 'Começar a cozinhar',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            if (!showFullIngredients) ...[
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGallerySection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Galeria',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF3C4D18),
                ),
              ),
              TextButton(
                onPressed: () {},
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
          SizedBox(height: 12),
          Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recipe['gallery'].length,
              itemBuilder: (context, index) {
                return Container(
                  width: 80,
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(recipe['gallery'][index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Comentários',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF3C4D18),
                ),
              ),
              TextButton(
                onPressed: () {},
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
          SizedBox(height: 12),
          ...recipe['comments'].take(5).map((comment) => _buildCommentItem(comment)).toList(),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Comentar',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                Icon(Icons.favorite_border, color: Colors.grey[500]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(comment['avatar']),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment['user'],
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF3C4D18),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  comment['text'],
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.favorite_border, size: 16, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      '${comment['likes']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Reply',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBookmarkModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectRecipeBookModal(),
    ).then((selectedBook) {
      if (selectedBook != null) {
        setState(() {
          isBookmarked = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Receita salva em "${selectedBook['title']}"!'),
            backgroundColor: Color(0xFF7CB342),
          ),
        );
      }
    });
  }
}