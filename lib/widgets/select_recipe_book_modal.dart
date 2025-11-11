import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_book_provider.dart';
import '../providers/auth_provider.dart';

class SelectRecipeBookModal extends ConsumerStatefulWidget {
  final int? recipeId;

  const SelectRecipeBookModal({Key? key, this.recipeId}) : super(key: key);

  @override
  ConsumerState<SelectRecipeBookModal> createState() => _SelectRecipeBookModalState();
}

class _SelectRecipeBookModalState extends ConsumerState<SelectRecipeBookModal> {
  final TextEditingController _newBookController = TextEditingController();
  bool _isCreatingBook = false;

  @override
  void dispose() {
    _newBookController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(currentUserDataProvider)?['id'] as int?;

    if (currentUserId == null) {
      return _buildErrorModal('Usuário não autenticado');
    }

    final recipeBooksAsync = ref.watch(userRecipeBooksProvider(currentUserId));

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Salvar em',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3C4D18),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: recipeBooksAsync.when(
              data: (books) => _buildBooksList(books, currentUserId),
              loading: () => Center(
                child: CircularProgressIndicator(color: Color(0xFFFA9500)),
              ),
              error: (err, stack) => Center(
                child: Text('Erro ao carregar livros'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksList(List<String> books, int userId) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      children: [
        ...books.map((book) => _buildBookTile(book, userId)).toList(),
        SizedBox(height: 16),
        if (!_isCreatingBook)
          _buildAddBookButton()
        else
          _buildNewBookInput(userId),
      ],
    );
  }

  Widget _buildBookTile(String bookTitle, int userId) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFFFA9500).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.book,
            color: Color(0xFFFA9500),
            size: 24,
          ),
        ),
        title: Text(
          bookTitle,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF3C4D18),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF999999),
          size: 18,
        ),
        onTap: () async {
          if (widget.recipeId != null) {
            try {
              await ref.read(recipeBookActionsProvider).saveRecipe(
                userId,
                widget.recipeId!,
                bookTitle,
              );

              if (mounted) {
                Navigator.pop(context, {'title': bookTitle});
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao salvar receita'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          } else {
            Navigator.pop(context, {'title': bookTitle});
          }
        },
      ),
    );
  }

  Widget _buildAddBookButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isCreatingBook = true;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Color(0xFFFA9500),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: Color(0xFFFA9500)),
            SizedBox(width: 8),
            Text(
              'Criar novo livro',
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

  Widget _buildNewBookInput(int userId) {
    return Column(
      children: [
        TextField(
          controller: _newBookController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Nome do livro',
            filled: true,
            fillColor: Color(0xFFFFF8F0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Color(0xFFFA9500), width: 2),
            ),
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isCreatingBook = false;
                    _newBookController.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF999999),
                  side: BorderSide(color: Color(0xFFE0E0E0)),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  if (_newBookController.text.trim().isNotEmpty) {
                    try {
                      await ref.read(recipeBookActionsProvider).createBook(
                        userId,
                        _newBookController.text.trim(),
                      );

                      if (widget.recipeId != null) {
                        await ref.read(recipeBookActionsProvider).saveRecipe(
                          userId,
                          widget.recipeId!,
                          _newBookController.text.trim(),
                        );
                      }

                      if (mounted) {
                        Navigator.pop(context, {'title': _newBookController.text.trim()});
                      }
                    } catch (e) {
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
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFA9500),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Criar',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorModal(String message) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Center(
        child: Text(message),
      ),
    );
  }
}