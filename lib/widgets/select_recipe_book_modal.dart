import 'package:flutter/material.dart';
import 'create_recipe_book_modal.dart';

class SelectRecipeBookModal extends StatefulWidget {
  @override
  _SelectRecipeBookModalState createState() => _SelectRecipeBookModalState();
}

class _SelectRecipeBookModalState extends State<SelectRecipeBookModal> {
  List<Map<String, dynamic>> recipeBooks = [
    {
      'title': 'Festa Junina',
      'count': '7 Receitas',
      'image': 'assets/images/chef.jpg',
    },
    {
      'title': 'Sobremesas',
      'count': '5 Receitas',
      'image': 'assets/images/chef.jpg',
    },
  ];

  String? selectedBookTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFA9500),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 50,
              height: 4,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Text(
              'Meus livros de receitas',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Qual livro deseja salvar a sua receita?',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            SizedBox(height: 20),

            // Lista de livros
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: recipeBooks.length,
                itemBuilder: (context, index) {
                  final book = recipeBooks[index];
                  final isSelected = selectedBookTitle == book['title'];

                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Color(0xFF7CB342)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          book['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        book['title'],
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF3C4D18),
                        ),
                      ),
                      subtitle: Text(
                        book['count'],
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                        Icons.check_circle,
                        color: Color(0xFF7CB342),
                      )
                          : null,
                      onTap: () {
                        setState(() {
                          selectedBookTitle = book['title'];
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            // Botões de ação
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      // Criar novo livro
                      final newBook = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => CreateRecipeBookModal(),
                      );

                      if (newBook != null) {
                        setState(() {
                          recipeBooks.add({
                            'title': newBook['title'],
                            'count': '0 Receitas',
                            'image': 'assets/images/chef.jpg',
                          });
                          selectedBookTitle = newBook['title'];
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Livro "${newBook['title']}" criado!'),
                            backgroundColor: Color(0xFF7CB342),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.add, color: Color(0xFFFA9500)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedBookTitle != null
                        ? () {
                      final selectedBook = recipeBooks.firstWhere(
                            (book) => book['title'] == selectedBookTitle,
                      );
                      Navigator.pop(context, selectedBook);
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7CB342),
                      disabledBackgroundColor: Colors.white.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Salvar',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: selectedBookTitle != null
                            ? Colors.white
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}