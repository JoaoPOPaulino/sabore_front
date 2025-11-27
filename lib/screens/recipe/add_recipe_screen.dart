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
import '../../providers/category_provider.dart';
import '../../utils/responsive_utils.dart';

class AddRecipeScreen extends ConsumerStatefulWidget {
  final Recipe? recipeToEdit;

  const AddRecipeScreen({Key? key, this.recipeToEdit}) : super(key: key);

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends ConsumerState<AddRecipeScreen> {
  int currentStep = 1;
  final PageController _pageController = PageController();
  bool _isLoading = false;
  bool get isEditMode => widget.recipeToEdit != null; // ✅ NOVO

  // Controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImageFile;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;

  // Estados brasileiros
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
    'categories': <String>[], // Lista de categorias
    'state': 'Nenhum',
  };

  @override
  void initState() {
    super.initState();

    // ✅ NOVO: Preencher dados se for modo edição
    if (isEditMode) {
      _loadRecipeData();
    }

    _nameController.addListener(() => setState(() { recipeData['name'] = _nameController.text; }));
    _descriptionController.addListener(() => setState(() { recipeData['description'] = _descriptionController.text; }));
  }

  // ✅ NOVO: Carregar dados da receita para edição
  void _loadRecipeData() {
    final recipe = widget.recipeToEdit!;

    _nameController.text = recipe.title;
    _descriptionController.text = recipe.description;

    recipeData['name'] = recipe.title;
    recipeData['description'] = recipe.description;
    recipeData['prepTime'] = recipe.preparationTime ~/ 2; // Aproximação
    recipeData['cookTime'] = recipe.preparationTime ~/ 2;
    recipeData['servings'] = recipe.servings;

    // ✅ Reconstruir ingredientes
    recipeData['ingredients'] = recipe.ingredients.map((ing) {
      final parts = ing.split(' ');
      return {
        'name': parts.length > 2 ? parts.sublist(2).join(' ') : ing,
        'amount': parts.length > 1 ? '${parts[0]} ${parts[1]}' : parts.isNotEmpty ? parts[0] : '',
      };
    }).toList();

    // ✅ Reconstruir etapas
    recipeData['preparations'] = List<String>.from(recipe.steps);

    // ✅ Reconstruir categorias
    if (recipe.category != null) {
      recipeData['categories'] = recipe.category!.split(' - ').where((c) => c != 'Nenhum').toList();
    }

    // ✅ Estado
    recipeData['state'] = recipe.state ?? 'Nenhum';

    // ✅ Imagem
    if (recipe.imageBytes != null) {
      _selectedImageBytes = recipe.imageBytes;
      _selectedImageName = 'recipe_image.jpg';
    }

    print('✏️ Modo edição ativado - Dados carregados');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: _buildAppBar(),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildStep1(),
          _buildStep2(),
          _buildStep3Improved(),
          _buildStep4(),
          _buildStep5(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
        isEditMode ? 'Editar Receita' : 'Adicionar Receita', // ✅ MUDANÇA
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
    );
  }

  // ============================================================================
  // STEP 1: INFORMAÇÕES BÁSICAS
  // ============================================================================

  Widget _buildStep1() {
    bool canProceed = _nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _hasSelectedImage();

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditMode ? 'Editar receita' : 'Nova receita', // ✅ MUDANÇA
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 32,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 30),

          _buildTextField(
            controller: _nameController,
            labelText: 'Nome da Receita',
            prefixIcon: Icons.edit,
          ),
          SizedBox(height: 20),

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

          if (canProceed)
            _buildNextButton(onPressed: _nextStep),
        ],
      ),
    );
  }

  // ============================================================================
  // STEP 2: CATEGORIAS E DETALHES
  // ============================================================================

  Widget _buildStep2() {
    final availableCategories = ref.watch(availableCategoriesProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detalhes',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 32,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 30),

          // Seletor de categorias múltiplas
          Text(
            'Categorias',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Selecione todas que se aplicam',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
              color: Color(0xFF999999),
            ),
          ),
          SizedBox(height: 16),

          // Grid de categorias
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: availableCategories.map((category) {
              final isSelected = (recipeData['categories'] as List<String>)
                  .contains(category['name']);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      (recipeData['categories'] as List<String>)
                          .remove(category['name']);
                    } else {
                      (recipeData['categories'] as List<String>)
                          .add(category['name']);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color(category['color']).withOpacity(0.2)
                        : Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Color(category['color'])
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        category['emoji'],
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 8),
                      Text(
                        category['name'],
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? Color(category['color'])
                              : Color(0xFF666666),
                        ),
                      ),
                      if (isSelected) ...[
                        SizedBox(width: 4),
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Color(category['color']),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 32),
          Divider(),
          SizedBox(height: 24),

          // Tempos e porções
          _buildTimeRow('Tempo de preparação', 'prepTime', recipeData['prepTime']),
          SizedBox(height: 16),
          _buildTimeRow('Tempo de cozimento', 'cookTime', recipeData['cookTime']),
          SizedBox(height: 16),
          _buildTimeRow('Porções', 'servings', recipeData['servings'], step: 1, min: 1, labelSufix: ' pessoas'),

          SizedBox(height: 32),
          Divider(),
          SizedBox(height: 24),

          // ✅ DROPDOWN CORRIGIDO
          _buildDropdown(
            label: 'Estado (Opcional)',
            value: recipeData['state'],
            items: states,
            onChanged: (value) {
              setState(() {
                recipeData['state'] = value ?? 'Nenhum';
              });
            },
            icon: Icons.map,
          ),

          SizedBox(height: 40),
          _buildNextButton(onPressed: _nextStep),
        ],
      ),
    );
  }

  // ============================================================================
  // STEP 3: INGREDIENTES
  // ============================================================================

  Widget _buildStep3Improved() {
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
          SizedBox(height: 8),
          Text(
            '${(recipeData['ingredients'] as List).length} ${(recipeData['ingredients'] as List).length == 1 ? 'ingrediente' : 'ingredientes'}',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
          SizedBox(height: 30),

          Expanded(
            child: ListView.builder(
              itemCount: recipeData['ingredients'].length,
              itemBuilder: (context, index) {
                final ingredient = recipeData['ingredients'][index];

                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Color(0xFFFA9500).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Color(0xFFFA9500),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () => setState(() {
                                recipeData['ingredients'].removeAt(index);
                              }),
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        // Nome do ingrediente
                        TextFormField(
                          initialValue: ingredient['name'],
                          decoration: InputDecoration(
                            hintText: 'Ex: Farinha de trigo',
                            hintStyle: TextStyle(
                              color: Color(0xFFCCCCCC),
                              fontSize: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xFFFA9500),
                                width: 2,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.egg_outlined,
                              color: Color(0xFFFA9500),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              recipeData['ingredients'][index]['name'] = value;
                            });
                          },
                        ),
                        SizedBox(height: 12),

                        // Quantidade
                        TextFormField(
                          initialValue: ingredient['amount'],
                          decoration: InputDecoration(
                            hintText: 'Ex: 2 xícaras',
                            hintStyle: TextStyle(
                              color: Color(0xFFCCCCCC),
                              fontSize: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xFF7CB342),
                                width: 2,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.scale_outlined,
                              color: Color(0xFF7CB342),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) {
                            recipeData['ingredients'][index]['amount'] = value;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          _buildAddButton(
            onPressed: _addIngredient,
            label: 'Adicionar ingrediente',
            icon: Icons.add_circle_outline,
          ),
          SizedBox(height: 20),

          if (canProceed)
            _buildNextButton(onPressed: _nextStep),
        ],
      ),
    );
  }

  // ============================================================================
  // STEP 4: MODO DE PREPARO
  // ============================================================================

  Widget _buildStep4() {
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
                final step = recipeData['preparations'][index];

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
                            onTap: () => setState(() {
                              recipeData['preparations'].removeAt(index);
                            }),
                            child: Icon(Icons.close, color: Colors.grey[400], size: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        initialValue: step,
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
          _buildAddButton(
            onPressed: _addPreparation,
            label: 'Adicionar etapa',
            icon: Icons.add,
          ),
          SizedBox(height: 20),

          if (canProceed)
            _buildNextButton(onPressed: _nextStep),
        ],
      ),
    );
  }

  // ============================================================================
  // STEP 5: REVISÃO
  // ============================================================================

  Widget _buildStep5() {
    final selectedCategories = (recipeData['categories'] as List<String>);

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

          // Categorias selecionadas
          if (selectedCategories.isNotEmpty) ...[
            Text(
              'Categorias',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF3C4D18),
              ),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedCategories.map((cat) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFFFA9500).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Color(0xFFFA9500),
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFA9500),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
          ],

          // Estado
          if (recipeData['state'] != 'Nenhum')
            _buildSummaryCard(
              icon: Icons.map,
              label: 'Estado',
              value: recipeData['state'],
            ),
          SizedBox(height: 20),

          // Imagem
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
                        isEditMode ? 'Atualizar' : 'Confirmar', // ✅ MUDANÇA
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

  // ============================================================================
  // WIDGETS HELPER
  // ============================================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    int maxLines = 1,
  }) {
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
          labelStyle: TextStyle(color: Color(0xFF999999)),
          prefixIcon: Icon(prefixIcon, color: Color(0xFFFA9500)),
        ),
      ),
    );
  }

  Widget _buildTimeRow(
      String label,
      String key,
      int value, {
        int step = 5,
        int min = 5,
        String labelSufix = ' min',
      }) {
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
                onTap: () => setState(() {
                  recipeData[key] = (recipeData[key] - step).clamp(min, 300);
                }),
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
                onTap: () => setState(() {
                  recipeData[key] = (recipeData[key] + step).clamp(min, 300);
                }),
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

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    final uniqueItems = <String>[];
    final seen = <String>{};

    for (final item in items) {
      if (!seen.contains(item)) {
        uniqueItems.add(item);
        seen.add(item);
      }
    }

    final validValue = uniqueItems.contains(value) ? value : null;

    return Container(
      padding: ResponsiveUtils.padding(context, all: 16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color(0xFFFA9500).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFFA9500).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Color(0xFFFA9500),
              size: ResponsiveUtils.iconSize(context, 20),
            ),
          ),
          SizedBox(width: ResponsiveUtils.spacing(context, 12)),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: validValue,
                hint: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                    color: Color(0xFF999999),
                  ),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFFFA9500),
                  size: ResponsiveUtils.iconSize(context, 24),
                ),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3C4D18),
                ),
                dropdownColor: Colors.white,
                items: uniqueItems.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                        color: Color(0xFF3C4D18),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildAddButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
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
            Icon(icon, color: Colors.white),
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

  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
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

  // ============================================================================
  // MÉTODOS
  // ============================================================================

  void _nextStep() {
    if (currentStep < 5) {
      setState(() { currentStep++; });
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
        setState(() {
          _selectedImageFile = File(pickedFile.path);
        });
      }
    }
  }

  void _addIngredient() {
    setState(() {
      recipeData['ingredients'].add({'name': '', 'amount': ''});
    });
  }

  void _addPreparation() {
    setState(() {
      recipeData['preparations'].add('');
    });
  }

  Future<void> _confirmRecipe() async {
    setState(() => _isLoading = true);

    try {
      String? imageUrl;
      Uint8List? imageBytes;

      if (kIsWeb && _selectedImageBytes != null) {
        imageUrl = isEditMode && widget.recipeToEdit!.image != null
            ? widget.recipeToEdit!.image
            : 'recipe_${DateTime.now().millisecondsSinceEpoch}.jpg';
        imageBytes = _selectedImageBytes;
        print("📸 Imagem web: $imageUrl (${imageBytes!.length} bytes)");
      } else if (!kIsWeb && _selectedImageFile != null) {
        imageUrl = _selectedImageFile!.path;
        print("📸 Imagem mobile: $imageUrl");
      } else if (isEditMode) {
        // Manter imagem existente
        imageUrl = widget.recipeToEdit!.image;
        imageBytes = widget.recipeToEdit!.imageBytes;
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

      List<String> finalCategories = List<String>.from(recipeData['categories']);
      if (recipeData['state'] != 'Nenhum') {
        finalCategories.add(recipeData['state']);
      }

      final categoryString = finalCategories.join(' - ');

      final recipe = Recipe(
        id: isEditMode ? widget.recipeToEdit!.id : 0,
        title: recipeData['name'],
        description: recipeData['description'],
        image: imageUrl,
        preparationTime: preparationTime,
        servings: recipeData['servings'],
        ingredients: ingredientsList,
        steps: stepsList,
        category: categoryString,
        userId: userIdAsInt,
        createdAt: isEditMode ? widget.recipeToEdit!.createdAt : DateTime.now(),
        imageBytes: imageBytes,
      );

      if (isEditMode) {
        // ✅ MODO EDIÇÃO
        await ref.read(recipesProvider.notifier).updateRecipe(
          widget.recipeToEdit!.id,
          recipe,
          imageBytes: imageBytes,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Receita atualizada com sucesso!'),
              backgroundColor: Color(0xFF7CB342),
            ),
          );
          context.pop(); // Voltar para a tela anterior
        }
      } else {
        // ✅ MODO CRIAÇÃO
        await ref.read(recipesProvider.notifier).addRecipe(recipe, imageBytes: imageBytes);

        // Invalidar providers
        ref.invalidate(userRecipesProvider(userIdAsInt));
        ref.invalidate(userProfileProvider(userIdAsInt));
        ref.invalidate(allRecipesProvider);
        ref.invalidate(categoriesWithCountProvider);

        if (mounted) context.push('/recipe-success');
      }

    } catch (e) {
      print('❌ Erro ao salvar receita: $e');
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

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}