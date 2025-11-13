import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/recipe_book_provider.dart';

class RecipeBooksScreen extends ConsumerStatefulWidget {
  const RecipeBooksScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RecipeBooksScreen> createState() => _RecipeBooksScreenState();
}

class _RecipeBooksScreenState extends ConsumerState<RecipeBooksScreen> {
  final TextEditingController _bookNameController = TextEditingController();

  @override
  void dispose() {
    _bookNameController.dispose();
    super.dispose();
  }

  Future<void> _createNewBook(int userId) async {
    if (_bookNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, digite um nome para o livro'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final actions = ref.read(recipeBookActionsProvider);
      await actions.createBook(userId, _bookNameController.text.trim());

      _bookNameController.clear();

      if (mounted) {
        context.pop(); // Fechar o dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Livro criado com sucesso!',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xFF7CB342),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }

      // Invalidar providers para atualizar
      ref.invalidate(userRecipeBooksProvider(userId));
      ref.invalidate(savedRecipesByBookProvider(userId));
    } catch (e) {
      print('Erro ao criar livro: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar livro'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddBookDialog(int userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFFFF3E0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmarks,
                color: Color(0xFFFA9500),
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Novo livro de receitas',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xFF3C4D18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _bookNameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Nome do livro',
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Color(0xFF999999),
                ),
                filled: true,
                fillColor: Color(0xFFFFF3E0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.book, color: Color(0xFFFA9500)),
              ),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
              ),
              onSubmitted: (_) => _createNewBook(userId),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _bookNameController.clear();
              context.pop();
            },
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Color(0xFF666666),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _createNewBook(userId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFA9500),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Criar',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(currentUserDataProvider)?['id'] as int?;
    final userData = ref.watch(currentUserDataProvider);

    if (currentUserId == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('Usuário não autenticado'),
        ),
      );
    }

    final savedByBookAsync = ref.watch(savedRecipesByBookProvider(currentUserId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: EdgeInsets.all(12),
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
                  Text(
                    'Saborê',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      color: Color(0xFFFA9500),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/profile/${userData?['id'] ?? '1'}');
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/chef.jpg'),
                    ),
                  ),
                ],
              ),
            ),

            // Título
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Livros de receitas',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 32,
                            color: Color(0xFF3C4D18),
                          ),
                        ),
                        SizedBox(height: 4),
                        savedByBookAsync.when(
                          data: (books) => Text(
                            '${books.length} ${books.length == 1 ? 'livro' : 'livros'}',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: Color(0xFF999999),
                            ),
                          ),
                          loading: () => SizedBox.shrink(),
                          error: (_, __) => SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Grid de livros
            Expanded(
              child: savedByBookAsync.when(
                data: (savedByBook) {
                  if (savedByBook.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFF3E0),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.bookmarks_outlined,
                              size: 80,
                              color: Color(0xFFFA9500),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            'Nenhum livro criado',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Color(0xFF666666),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Crie seu primeiro livro de receitas',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: Color(0xFF999999),
                            ),
                          ),
                          SizedBox(height: 32),
                          ElevatedButton.icon(
                            onPressed: () => _showAddBookDialog(currentUserId),
                            icon: Icon(Icons.add),
                            label: Text('Criar livro'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFA9500),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: savedByBook.length + 1, // +1 para botão adicionar
                      itemBuilder: (context, index) {
                        if (index == savedByBook.length) {
                          return _buildAddBookCard(currentUserId);
                        }

                        final bookTitle = savedByBook.keys.elementAt(index);
                        final recipes = savedByBook[bookTitle] ?? [];

                        return _buildBookCard(
                          context,
                          bookTitle,
                          recipes.length,
                          recipes.isNotEmpty ? recipes.first.image : null,
                        );
                      },
                    ),
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFA9500)),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Erro ao carregar livros',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(savedRecipesByBookProvider(currentUserId));
                        },
                        child: Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(
      BuildContext context,
      String bookTitle,
      int recipesCount,
      String? coverImage,
      ) {
    return GestureDetector(
      onTap: () {
        print('📖 Book tapped: $bookTitle');
        // TODO: Navegar para tela de receitas do livro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Visualizar receitas de "$bookTitle"'),
            backgroundColor: Color(0xFF7CB342),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Imagem de fundo
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(coverImage ?? 'assets/images/chef.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),

            // Botão de bookmark no topo direito
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bookmark,
                  color: Color(0xFFFA9500),
                  size: 20,
                ),
              ),
            ),

            // Título e contagem na parte inferior
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bookTitle,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          color: Colors.white70,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '$recipesCount ${recipesCount == 1 ? 'receita' : 'receitas'}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddBookCard(int userId) {
    return GestureDetector(
      onTap: () {
        print('➕ Add new book tapped');
        _showAddBookDialog(userId);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFFFA9500),
            width: 2,
            style: BorderStyle.solid,
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFA9500).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Color(0xFFFA9500),
                size: 40,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Novo livro',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFFFA9500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}