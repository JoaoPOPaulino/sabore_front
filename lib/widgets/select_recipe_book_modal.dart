import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/recipe_book_provider.dart';

class SelectRecipeBookModal extends ConsumerStatefulWidget {
  final int recipeId;

  const SelectRecipeBookModal({
    Key? key,
    required this.recipeId,
  }) : super(key: key);

  @override
  ConsumerState<SelectRecipeBookModal> createState() => _SelectRecipeBookModalState();
}

class _SelectRecipeBookModalState extends ConsumerState<SelectRecipeBookModal> {
  final TextEditingController _newBookController = TextEditingController();
  bool _isCreatingNewBook = false;

  @override
  void dispose() {
    _newBookController.dispose();
    super.dispose();
  }

  Future<void> _createNewBook() async {
    if (_newBookController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'Por favor, digite um nome para o livro',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final currentUserId = ref.read(currentUserDataProvider)?['id'] as int?;
    if (currentUserId == null) return;

    try {
      final actions = ref.read(recipeBookActionsProvider);
      await actions.createBook(currentUserId, _newBookController.text.trim());

      setState(() {
        _isCreatingNewBook = false;
        _newBookController.clear();
      });

      if (mounted) {
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
            duration: Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }

      // Invalidar providers para atualizar a lista
      ref.invalidate(userRecipeBooksProvider(currentUserId));
      ref.invalidate(savedRecipesByBookProvider(currentUserId));
    } catch (e) {
      print('❌ Erro ao criar livro: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Erro ao criar livro',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _toggleRecipeInBook(int userId, String bookTitle, bool isCurrentlySaved) async {
    try {
      final actions = ref.read(recipeBookActionsProvider);

      if (isCurrentlySaved) {
        // ❌ Remover da lista
        await actions.unsaveRecipe(userId, widget.recipeId, bookTitle);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.bookmark_remove, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Receita removida de "$bookTitle"',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Color(0xFFFF6B35),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } else {
        // ✅ Adicionar à lista
        await actions.saveRecipe(userId, widget.recipeId, bookTitle);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.bookmark_added, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Receita salva em "$bookTitle"',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Color(0xFF7CB342),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }

      // Invalidar providers para atualizar UI
      ref.invalidate(savedRecipesByBookProvider(userId));
      ref.invalidate(isRecipeSavedProvider(RecipeSaveParams(
        userId: userId,
        recipeId: widget.recipeId,
      )));
    } catch (e) {
      print('❌ Erro ao salvar/remover receita: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Erro ao processar solicitação',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(currentUserDataProvider)?['id'] as int?;

    if (currentUserId == null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Usuário não autenticado',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
    }

    final booksAsync = ref.watch(userRecipeBooksProvider(currentUserId));
    final savedByBookAsync = ref.watch(savedRecipesByBookProvider(currentUserId));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFA9500),
                        Color(0xFFFF6B35),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFA9500).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.bookmarks,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salvar receita',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Color(0xFF3C4D18),
                        ),
                      ),
                      Text(
                        'Escolha seus livros de receitas',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Color(0xFF666666)),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Color(0xFFE0E0E0)),

          // Lista de livros
          booksAsync.when(
            data: (books) {
              if (books.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF3E0),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.bookmarks_outlined,
                          size: 64,
                          color: Color(0xFFFA9500),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Nenhum livro criado',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return savedByBookAsync.when(
                data: (savedByBook) {
                  return Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: books.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        indent: 76,
                        color: Color(0xFFF5F5F5),
                      ),
                      itemBuilder: (context, index) {
                        final bookTitle = books[index];
                        final recipesInBook = savedByBook[bookTitle] ?? [];
                        final isRecipeInBook = recipesInBook.any((r) => r.id == widget.recipeId);
                        final recipeCount = recipesInBook.length;

                        return InkWell(
                          onTap: () => _toggleRecipeInBook(currentUserId, bookTitle, isRecipeInBook),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                // Ícone do livro
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: isRecipeInBook
                                        ? LinearGradient(
                                      colors: [
                                        Color(0xFF7CB342),
                                        Color(0xFF689F38),
                                      ],
                                    )
                                        : null,
                                    color: isRecipeInBook ? null : Color(0xFFFFF3E0),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: isRecipeInBook ? [
                                      BoxShadow(
                                        color: Color(0xFF7CB342).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ] : [],
                                  ),
                                  child: Icon(
                                    isRecipeInBook ? Icons.bookmark : Icons.bookmark_border,
                                    color: isRecipeInBook ? Colors.white : Color(0xFFFA9500),
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 12),

                                // Título e contagem
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bookTitle,
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Color(0xFF3C4D18),
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.restaurant_menu,
                                            size: 12,
                                            color: Color(0xFF999999),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '$recipeCount ${recipeCount == 1 ? 'receita' : 'receitas'}',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 12,
                                              color: Color(0xFF999999),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Ícone de status
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isRecipeInBook
                                        ? Color(0xFF7CB342).withOpacity(0.1)
                                        : Color(0xFFFA9500).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isRecipeInBook ? Icons.check : Icons.add,
                                    color: isRecipeInBook ? Color(0xFF7CB342) : Color(0xFFFA9500),
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFA9500)),
                  ),
                ),
                error: (e, s) => Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Erro ao carregar livros',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFA9500)),
              ),
            ),
            error: (error, stack) => Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Erro ao carregar livros',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Divider(height: 1, color: Color(0xFFE0E0E0)),

          // Criar novo livro
          if (_isCreatingNewBook) ...[
            Container(
              padding: EdgeInsets.all(16),
              color: Color(0xFFFFF8F0),
              child: Column(
                children: [
                  TextField(
                    controller: _newBookController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Nome do novo livro',
                      hintStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF999999),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFFA9500), width: 2),
                      ),
                      prefixIcon: Icon(Icons.book, color: Color(0xFFFA9500)),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear, color: Color(0xFF999999)),
                        onPressed: () {
                          _newBookController.clear();
                        },
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                    ),
                    onSubmitted: (_) => _createNewBook(),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _isCreatingNewBook = false;
                              _newBookController.clear();
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Color(0xFFE0E0E0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _createNewBook,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFA9500),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Criar livro',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isCreatingNewBook = true;
                    });
                  },
                  icon: Icon(Icons.add, color: Color(0xFFFA9500)),
                  label: Text(
                    'Criar novo livro',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFFFA9500),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Color(0xFFFA9500), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}