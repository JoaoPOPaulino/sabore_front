// lib/screens/recipe/add_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/recipe_provider.dart';

class AddRecipeScreen extends ConsumerStatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends ConsumerState<AddRecipeScreen> {
  int currentStep = 1;
  final PageController _pageController = PageController();
  bool _isLoading = false;

  // Controllers para os formulários
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImageFile;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;

  // Lista de estados
  final List<String> states = [
    'Nenhum', 'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA',
    'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS',
    'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
  ];

  // Dados da receita
  Map<String, dynamic> recipeData = {
    'name': '',
    'description': '',
    'ingredients': <Map<String, String>>[],
    'preparations': <String>[],
    'prepTime': 15,
    'cookTime': 45,
    'servings': 4,
    'restriction': 'Não',
    'state': 'Nenhum',
  };

  @override
  void initState() {
    super.initState();
    // Listeners para atualizar o 'canProceed' em tempo real
    _nameController.addListener(() => setState(() { recipeData['name'] = _nameController.text; }));
    _descriptionController.addListener(() => setState(() { recipeData['description'] = _descriptionController.text; }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            if (_isLoading) return;
            if (currentStep > 1) {
              setState(() { currentStep--; });
              _pageController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
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
            child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
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
    // Verifica se pode avançar
    bool canProceed = _nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _hasSelectedImage();

    return SingleChildScrollView(
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
          _buildTextField(
            controller: _nameController,
            labelText: 'Nome da Receita',
            prefixIcon: Icons.edit,
          ),
          SizedBox(height: 20),

          // Campo Descrição
          _buildTextField(
            controller: _descriptionController,
            labelText: 'Descrição da Receita',
            prefixIcon: Icons.description,
            maxLines: 3,
          ),
          SizedBox(height: 20),

          // Upload de imagem
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(15),
                image: _getImageProvider(),
              ),
              child: !_hasSelectedImage()
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload, size: 40, color: Color(0xFFFA9500)),
                  SizedBox(height: 16),
                  Text(
                    'Faça upload da foto',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
                ],
              )
                  : null,
            ),
          ),
          SizedBox(height: 30),

          // Botão Próximo (só aparece se puder avançar)
          if (canProceed)
            _buildNextButton(onPressed: _nextStep),
        ],
      ),
    );
  }

  // Step 2: Informações
  Widget _buildStep2() {
    return SingleChildScrollView(
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
          _buildTimeRow('Tempo de preparação', 'prepTime', recipeData['prepTime']),
          SizedBox(height: 20),
          // Tempo de cozimento
          _buildTimeRow('Tempo de cozimento', 'cookTime', recipeData['cookTime']),
          SizedBox(height: 20),
          // Porções
          _buildTimeRow('Porções (Pessoas)', 'servings', recipeData['servings'], step: 1, min: 1, labelSufix: ''),

          SizedBox(height: 30),

          // Categoria
          _buildDropdown('Categoria / Restrição', 'restriction',
              ['Não', 'Zero Glúten', 'Zero Lactose', 'Vegano', 'Vegetariano']),

          SizedBox(height: 20),

          // Estado
          _buildDropdown('Estado (Opcional)', 'state', states),

          SizedBox(height: 50),
          _buildNextButton(onPressed: _nextStep),
        ],
      ),
    );
  }

  // Step 3: Ingredientes
  Widget _buildStep3() {
    // Verifica se pode avançar
    bool canProceed = recipeData['ingredients'].isNotEmpty &&
        (recipeData['ingredients'] as List).every((ing) => ing['name']!.isNotEmpty);

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
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Ex: 1 xícara',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            recipeData['ingredients'][index]['amount'] = value;
                          },
                        ),
                      ),
                      Container(width: 1, height: 20, color: Color(0xFFFA9500).withOpacity(0.3), margin: EdgeInsets.symmetric(horizontal: 8)),

                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Ingrediente ${index + 1}',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() { // setState aqui para atualizar o 'canProceed'
                              recipeData['ingredients'][index]['name'] = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => setState(() { recipeData['ingredients'].removeAt(index); }),
                        child: Icon(Icons.close, color: Colors.red[300], size: 20),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          _buildAddButton(onPressed: _addIngredient, label: 'Adicionar ingrediente'),
          SizedBox(height: 20),
          // Botão Próximo (só aparece se puder avançar)
          if(canProceed)
            _buildNextButton(onPressed: _nextStep),
        ],
      ),
    );
  }

  // Step 4: Modo de preparo
  Widget _buildStep4() {
    // Verifica se pode avançar
    bool canProceed = recipeData['preparations'].isNotEmpty &&
        (recipeData['preparations'] as List).every((step) => step.isNotEmpty);

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
          Expanded(
            child: ListView.builder(
              itemCount: recipeData['preparations'].length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF3E0),
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
                              color: Color(0xFFFA9500),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () => setState(() { recipeData['preparations'].removeAt(index); }),
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
          _buildAddButton(onPressed: _addPreparation, label: 'Adicionar modo de preparo'),
          SizedBox(height: 20),
          // Botão Próximo (só aparece se puder avançar)
          if(canProceed)
            _buildNextButton(onPressed: _nextStep),
        ],
      ),
    );
  }

  // Step 5: Confirmar
  Widget _buildStep5() {
    return SingleChildScrollView(
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
          _buildSummaryCard(
            icon: Icons.category,
            label: 'Categoria',
            value: recipeData['restriction'],
          ),
          SizedBox(height: 12),

          // Estado
          if(recipeData['state'] != 'Nenhum')
            _buildSummaryCard(
              icon: Icons.map,
              label: 'Estado',
              value: recipeData['state'],
            ),
          SizedBox(height: 20),

          // Imagem da receita
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFFFFF3E0),
              image: _getImageProvider() ?? DecorationImage(
                image: AssetImage('assets/images/chef.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 30),

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
                  onPressed: _isLoading ? null : () {
                    setState(() { currentStep--; });
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _confirmRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFA9500),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                      : Row(
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
                      Icon(Icons.check_circle, color: Colors.white, size: 18),
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

  // ---- WIDGETS DE UI REUTILIZÁVEIS ----

  Widget _buildTextField({required TextEditingController controller, required String labelText, required IconData prefixIcon, int maxLines = 1}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0xFF3C4D18),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
          labelStyle: TextStyle(
            color: Color(0xFF999999),
          ),
          prefixIcon: Icon(prefixIcon, color: Color(0xFFFA9500)),
        ),
      ),
    );
  }

  Widget _buildTimeRow(String label, String key, int value, {int step = 5, int min = 5, String labelSufix = ' min'}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFFFF3E0),
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
                onTap: () => setState(() { recipeData[key] = (recipeData[key] - step).clamp(min, 300); }),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.remove, color: Color(0xFFFA9500)),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$value$labelSufix',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF3C4D18),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() { recipeData[key] = (recipeData[key] + step).clamp(min, 300); }),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.add, color: Color(0xFFFA9500)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String key, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: recipeData[key],
            isExpanded: true,
            underline: SizedBox(),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) => setState(() { recipeData[key] = newValue!; }),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton({required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
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
    );
  }

  Widget _buildAddButton({required VoidCallback onPressed, required String label}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        onPressed: onPressed,
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
              label,
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
    );
  }

  Widget _buildSummaryCard({required IconData icon, required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFFA9500)),
          SizedBox(width: 12),
          Text(
            "$label: ",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF3C4D18),
            ),
          ),
        ],
      ),
    );
  }

  // ---- MÉTODOS DE LÓGICA ----


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
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageName = pickedFile.name;
        });
      } else {
        setState(() { _selectedImageFile = File(pickedFile.path); });
      }
    }
  }


  void _addIngredient() {
    setState(() {
      recipeData['ingredients'].add({ 'name': '', 'amount': '', });
    });
  }


  void _addPreparation() {
    setState(() {
      recipeData['preparations'].add('');
    });
  }


  void _confirmRecipe() async {
    setState(() => _isLoading = true);

    try {
      String? imageUrl;
      if (kIsWeb && _selectedImageBytes != null) {

        imageUrl = 'web_image_${DateTime.now().millisecondsSinceEpoch}';
        print("⚠️ Imagem web: A visualização não funcionará completamente no mock. Path: $imageUrl");
      } else if (!kIsWeb && _selectedImageFile != null) {

        imageUrl = _selectedImageFile!.path;
        print("📸 Imagem mobile salva: $imageUrl");
      }

      final ingredientsList = (recipeData['ingredients'] as List<Map<String, String>>)
          .map((ing) => "${ing['amount'] ?? ''} ${ing['name'] ?? ''}".trim())
          .where((val) => val.isNotEmpty)
          .toList();

      final stepsList = (recipeData['preparations'] as List<String>)
          .where((val) => val.isNotEmpty)
          .toList();

      final preparationTime = (recipeData['prepTime'] as int) + (recipeData['cookTime'] as int);

      final userId = ref.read(currentUserDataProvider)?['id'];
      if (userId == null) throw Exception('Usuário não autenticado.');
      final userIdAsInt = int.tryParse(userId.toString()) ?? 0;

      // IMPLEMENTAÇÃO DO ESTADO: Combina restrição e estado
      String category = recipeData['restriction'];
      if (recipeData['state'] != 'Nenhum') {
        category = "$category - ${recipeData['state']}";
      }

      final newRecipe = Recipe(
        id: 0,
        title: recipeData['name'],
        description: recipeData['description'], // USA A DESCRIÇÃO
        image: imageUrl,
        preparationTime: preparationTime,
        servings: recipeData['servings'], // USA AS PORÇÕES
        ingredients: ingredientsList,
        steps: stepsList,
        category: category, // USA A CATEGORIA COMBINADA
        userId: userIdAsInt,
        createdAt: DateTime.now(),
      );


      await ref.read(recipesProvider.notifier).addRecipe(newRecipe);
      ref.invalidate(userRecipesProvider(userIdAsInt));
      ref.invalidate(userProfileProvider(userIdAsInt));
      ref.invalidate(allRecipesProvider);

      if (mounted) context.push('/recipe-success');

    } catch (e) {
      print('Erro ao criar receita: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar receita: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  bool _hasSelectedImage() {
    return (kIsWeb && _selectedImageBytes != null) ||
        (!kIsWeb && _selectedImageFile != null);
  }


  DecorationImage? _getImageProvider() {
    if (kIsWeb && _selectedImageBytes != null) {
      return DecorationImage(image: MemoryImage(_selectedImageBytes!), fit: BoxFit.cover);
    } else if (!kIsWeb && _selectedImageFile != null) {
      return DecorationImage(image: FileImage(_selectedImageFile!), fit: BoxFit.cover);
    }
    return null;
  }


  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}