import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/auth_provider.dart';

class SetupProfileScreen extends ConsumerStatefulWidget {
  @override
  _SetupProfileScreenState createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends ConsumerState<SetupProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? _usernameError;
  File? _profileImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        // Verificar tamanho (máximo 2MB)
        final file = File(image.path);
        final fileSize = await file.length();

        if (fileSize > 2 * 1024 * 1024) {
          _showErrorMessage('A imagem deve ter no máximo 2MB');
          return;
        }

        setState(() {
          _profileImage = file;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      _showErrorMessage('Erro ao selecionar imagem');
    }
  }

  Future<void> _checkUsernameAvailability(String username) async {
    if (username.length < 3) return;

    setState(() => _isLoading = true);

    try {
      // Simular verificação de disponibilidade
      await Future.delayed(const Duration(milliseconds: 500));

      // Usernames reservados para teste
      final reservedUsernames = ['admin', 'test', 'sabore', 'joao', 'maria'];

      if (reservedUsernames.contains(username.toLowerCase())) {
        setState(() {
          _usernameError = 'Este username já está em uso';
        });
      } else {
        setState(() {
          _usernameError = null;
        });
      }
    } catch (e) {
      print('Error checking username: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_usernameError != null) {
      _showErrorMessage(_usernameError!);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Aqui você pode fazer upload da foto e salvar o username na API
      // Por enquanto, só completa o setup

      await ref.read(authProvider.notifier).completeProfileSetup();

      // Navegar para tela de sucesso
      if (mounted) {
        context.go('/setup-complete');
      }
    } catch (e) {
      _showErrorMessage('Erro ao salvar perfil. Tente novamente.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8F0),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
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
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo2.png',
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 48), // Para balancear o botão voltar
                    ],
                  ),

                  SizedBox(height: 40),

                  // Título
                  Text(
                    'Perfil',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                      color: Color(0xFF3C4D18),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Upload de foto
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: _profileImage != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            _profileImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload,
                              size: 48,
                              color: Color(0xFF3C4D18),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Faça upload da sua foto de perfil',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFF3C4D18),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '*Tamanho máximo 2MB',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Campo Username
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextFormField(
                            controller: _usernameController,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              color: Color(0xFF3C4D18),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Username',
                              hintStyle: TextStyle(
                                color: Color(0xFF999999),
                                fontFamily: 'Montserrat',
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                              suffixIcon: _isLoading
                                  ? Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF3C4D18),
                                    ),
                                  ),
                                ),
                              )
                                  : _usernameError == null && _usernameController.text.length > 2
                                  ? Icon(Icons.check_circle, color: Colors.green)
                                  : null,
                            ),
                            onChanged: _checkUsernameAvailability,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username é obrigatório';
                              }
                              if (value.length < 3) {
                                return 'Username deve ter pelo menos 3 caracteres';
                              }
                              if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                                return 'Use apenas letras, números e _';
                              }
                              return null;
                            },
                          ),
                        ),
                        if (_usernameError != null)
                          Padding(
                            padding: EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              _usernameError!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 60),

                  // Botão Próximo
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFA9500),
                        disabledBackgroundColor: Color(0xFFE0E0E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Próximo',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}