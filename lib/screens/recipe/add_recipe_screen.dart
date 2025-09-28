import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  int currentStep = 1;
  final PageController _pageController = PageController();

  // Controllers para os formulários
  final _nameController = TextEditingController();
  File? _selectedImageFile; // Para mobile
  Uint8List? _selectedImageBytes; // Para web
  String? _selectedImageName;

  // Dados da receita
  Map<String, dynamic> recipeData = {
    'name': '',
    'ingredients': <Map<String, String>>[],
    'preparations': <String>[],
    'prepTime': 15,
    'cookTime': 45,
    'restriction': 'Não',
    'category': 'Esfira zero glúten',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            if (currentStep > 1) {
              setState(() {
                currentStep--;
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            } else {
              context.pop();
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF7CB342),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          ),
        ),
        title: Text(
          'Adicionar Receita',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xFF3C4D18),
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFFFA9500),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '$currentStep/5',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildStep1(), // Nova receita
          _buildStep2(), // Informações
          _buildStep3(), // Ingredientes
          _buildStep4(), // Modo de preparo
          _buildStep5(), // Confirmar
        ],
      ),
    );
  }

  // Step 1: Nova receita
  Widget _buildStep1() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nova receita',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 32,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 30),

          // Campo nome
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Nome',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                recipeData['name'] = value;
              });
            },
          ),
          SizedBox(height: 20),

          // Upload de imagem - CORRIGIDO PARA WEB
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(15),
                image: _getImageProvider(),
              ),
              child: !_hasSelectedImage()
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload, size: 40, color: Color(0xFF666666)),
                  SizedBox(height: 16),
                  Text(
                    'Faça upload por aqui',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                  Text(
                    '*tamanho máximo 2MB',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              )
                  : null,
            ),
          ),

          Spacer(),

          // Botão Próximo
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nameController.text.isNotEmpty ? () => _nextStep() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFA9500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Próximo',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Métodos auxiliares para imagem
  bool _hasSelectedImage() {
    return (kIsWeb && _selectedImageBytes != null) ||
        (!kIsWeb && _selectedImageFile != null);
  }

  DecorationImage? _getImageProvider() {
    if (kIsWeb && _selectedImageBytes != null) {
      return DecorationImage(
        image: MemoryImage(_selectedImageBytes!),
        fit: BoxFit.cover,
      );
    } else if (!kIsWeb && _selectedImageFile != null) {
      return DecorationImage(
        image: FileImage(_selectedImageFile!),
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  // Step 2: Informações
  Widget _buildStep2() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informações',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 32,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 40),

          // Tempo de preparação
          _buildTimeRow('Tempo de preparação', recipeData['prepTime']),
          SizedBox(height: 20),

          // Tempo de cozimento
          _buildTimeRow('Tempo de cozimento', recipeData['cookTime']),
          SizedBox(height: 30),

          // Restrição
          Text(
            'Restrição',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<String>(
              value: recipeData['restriction'],
              isExpanded: true,
              underline: SizedBox(),
              items: ['Não', 'Zero Glúten', 'Zero Lactose', 'Vegano', 'Vegetariano']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  recipeData['restriction'] = newValue!;
                });
              },
            ),
          ),

          Spacer(),

          // Botão Próximo
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _nextStep(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFA9500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Próximo',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, int value) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF3C4D18),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (label.contains('preparação')) {
                      recipeData['prepTime'] = (recipeData['prepTime'] + 5).clamp(5, 300);
                    } else {
                      recipeData['cookTime'] = (recipeData['cookTime'] + 5).clamp(5, 300);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.add, color: Color(0xFFFA9500)),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$value min',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF3C4D18),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (label.contains('preparação')) {
                      recipeData['prepTime'] = (recipeData['prepTime'] - 5).clamp(5, 300);
                    } else {
                      recipeData['cookTime'] = (recipeData['cookTime'] - 5).clamp(5, 300);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.remove, color: Color(0xFFFA9500)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Step 3: Ingredientes
  Widget _buildStep3() {
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
              fontSize: 32,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 30),

          // Lista de ingredientes
          Expanded(
            child: ListView.builder(
              itemCount: recipeData['ingredients'].length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      // Campo quantidade + unidade
                      Container(
                        width: 100,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '1g',
                            filled: true,
                            fillColor: Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          onChanged: (value) {
                            setState(() {
                              recipeData['ingredients'][index]['amount'] = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12),

                      // Campo nome do ingrediente
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Ingrediente ${index + 1}',
                            filled: true,
                            fillColor: Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          onChanged: (value) {
                            setState(() {
                              recipeData['ingredients'][index]['name'] = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12),

                      // Botão remover
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            recipeData['ingredients'].removeAt(index);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close, color: Colors.red, size: 20),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Botão adicionar ingrediente
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: _addIngredient,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7CB342),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Adicionar ingrediente',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botão Próximo
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: recipeData['ingredients'].isNotEmpty ? () => _nextStep() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFA9500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Próximo',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step 4: Modo de preparo
  Widget _buildStep4() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Modo de preparo',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 32,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 30),

          // Lista de etapas
          Expanded(
            child: ListView.builder(
              itemCount: recipeData['preparations'].length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Etapa ${index + 1}',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                recipeData['preparations'].removeAt(index);
                              });
                            },
                            child: Icon(Icons.close, color: Colors.grey[400], size: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Descreva a etapa ${index + 1}...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (index < recipeData['preparations'].length) {
                              recipeData['preparations'][index] = value;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Botão adicionar modo de preparo
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: _addPreparation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7CB342),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Adicionar modo de preparo',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botão Próximo
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: recipeData['preparations'].isNotEmpty ? () => _nextStep() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFA9500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Próximo',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step 5: Confirmar
  Widget _buildStep5() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tudo certo?',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 32,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 20),

          // Categoria
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              recipeData['category'],
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Imagem da receita - CORRIGIDO PARA WEB
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFFF5F5F5),
              image: _getImageProvider() ?? DecorationImage(
                image: AssetImage('assets/images/chef.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Spacer(),

          // Botões
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFF7CB342),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      currentStep--;
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _confirmRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFA9500),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Confirmar',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (currentStep < 5) {
      setState(() {
        currentStep++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // Para web, converte para bytes
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageName = pickedFile.name;
        });
      } else {
        // Para mobile, usa File
        setState(() {
          _selectedImageFile = File(pickedFile.path);
        });
      }
    }
  }

  void _addIngredient() {
    setState(() {
      recipeData['ingredients'].add({
        'name': '',
        'amount': '1g',
      });
    });
  }

  void _addPreparation() {
    setState(() {
      recipeData['preparations'].add('');
    });
  }

  void _confirmRecipe() {
    // Salvar receita e ir para tela de sucesso
    context.push('/recipe-success');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}