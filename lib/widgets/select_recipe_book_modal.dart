import 'package:flutter/material.dart';
import 'create_recipe_book_modal.dart';

class SelectRecipeBookModal extends StatefulWidget {
  @override
  _SelectRecipeBookModalState createState() => _SelectRecipeBookModalState();
}

class _SelectRecipeBookModalState extends State<SelectRecipeBookModal> {
  final List<Map<String, dynamic>> recipeBooks = [
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
            ...recipeBooks.map((book) => Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                onTap: () {
                  Navigator.pop(context, book);
                },
              ),
            )).toList(),
            SizedBox(height: 20),
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
                    onPressed: () {
                      // Criar novo livro
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => CreateRecipeBookModal(),
                      );
                    },
                    icon: Icon(Icons.add, color: Color(0xFFFA9500)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Salvar receita
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7CB342),
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
    );
  }
}