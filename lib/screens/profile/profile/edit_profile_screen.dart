import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/profile_image_widget.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  final ImagePicker _picker = ImagePicker();

  String? _profileImagePath;
  Uint8List? _profileImageBytes;
  String? _coverImagePath;
  Uint8List? _coverImageBytes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userData = ref.read(currentUserDataProvider);
    _nameController = TextEditingController(text: userData?['name'] ?? '');
    _usernameController = TextEditingController(text: userData?['username'] ?? '');
    _profileImagePath = userData?['profileImage'];
    _profileImageBytes = userData?['profileImageBytes'];
    _coverImagePath = userData?['coverImage'];
    _coverImageBytes = userData?['coverImageBytes'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _profileImageBytes = bytes;
            _profileImagePath = null;
          });
        } else {
          setState(() {
            _profileImagePath = image.path;
            _profileImageBytes = null;
          });
        }
      }
    } catch (e) {
      print('Error picking profile image: $e');
      _showErrorMessage('Erro ao selecionar imagem de perfil');
    }
  }

  Future<void> _pickCoverImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _coverImageBytes = bytes;
            _coverImagePath = null;
          });
        } else {
          setState(() {
            _coverImagePath = image.path;
            _coverImageBytes = null;
          });
        }
      }
    } catch (e) {
      print('Error picking cover image: $e');
      _showErrorMessage('Erro ao selecionar imagem de capa');
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);

      // ✨ CORREÇÃO: Enviando TODOS os dados para o serviço
      await authService.updateProfile(
        name: _nameController.text,
        username: _usernameController.text,
        profileImagePath: _profileImagePath,
        profileImageBytes: _profileImageBytes,
        coverImagePath: _coverImagePath,
        coverImageBytes: _coverImageBytes,
      );

      // Atualiza o provider local
      final currentData = ref.read(currentUserDataProvider);
      if (currentData != null) {
        ref.read(currentUserDataProvider.notifier).state = {
          ...currentData,
          'name': _nameController.text,
          'username': _usernameController.text,
          'profileImage': _profileImagePath,
          'profileImageBytes': _profileImageBytes,
          'coverImage': _coverImagePath,
          'coverImageBytes': _coverImageBytes,
        };
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Perfil atualizado com sucesso!'),
            backgroundColor: Color(0xFF7CB342),
          ),
        );
        context.pop();
      }
    } catch (e) {
      print('Error saving profile: $e');
      if (mounted) {
        _showErrorMessage('Erro ao atualizar perfil');
      }
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✨ MUDANÇA: Fundo principal do app
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF7CB342),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back, // Ícone padrão
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'Editar Perfil',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF3C4D18),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✨ MUDANÇA: Stack agora controla a sobreposição
            Stack(
              clipBehavior: Clip.none, // Permite o overflow
              alignment: Alignment.center,
              children: [
                // Foto de Capa
                GestureDetector(
                  onTap: _pickCoverImage,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF3E0),
                    ),
                    child: _buildCoverImagePreview(),
                  ),
                ),
                // Botão de editar capa
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: _pickCoverImage,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFFA9500),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // ✨ MUDANÇA: Foto de Perfil sobreposta via Positioned
                Positioned(
                  bottom: -60, // Puxa para baixo, sobrepondo
                  child: _buildProfileImageEdit(),
                ),
              ],
            ),

            // Espaço para compensar a foto de perfil sobreposta
            SizedBox(height: 70),

            // Formulário
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                children: [
                  // Campo Nome
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: _nameController,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF3C4D18),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Nome',
                        labelStyle: TextStyle(
                          color: Color(0xFF999999),
                        ),
                        prefixIcon: Icon(Icons.person, color: Color(0xFFFA9500)),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Campo Username
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: _usernameController,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF3C4D18),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: Color(0xFF999999),
                        ),
                        prefixIcon: Icon(Icons.alternate_email, color: Color(0xFFFA9500)),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Email (read-only)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5), // Fundo cinza padrão
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.email, color: Color(0xFF999999)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ref.watch(currentUserDataProvider)?['email'] ?? '',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ),
                        Icon(Icons.lock, color: Color(0xFF999999), size: 18),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  // Botão Salvar
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFA9500),
                        disabledBackgroundColor: Color(0xFFE0E0E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 12),
                          Text(
                            'Salvar Alterações',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✨ NOVO: Widget extraído para clareza
  Widget _buildProfileImageEdit() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickProfileImage,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: _buildProfileImagePreview(),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFFA9500),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Toque para alterar foto de perfil',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            color: Color(0xFF999999),
          ),
        ),
      ],
    );
  }

  Widget _buildCoverImagePreview() {
    final hasCoverImage = (kIsWeb && _coverImageBytes != null) ||
        (!kIsWeb && _coverImagePath != null);

    if (!hasCoverImage) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFA9500).withOpacity(0.2),
              Color(0xFF7CB342).withOpacity(0.2),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 48,
              color: Color(0xFFFA9500),
            ),
            SizedBox(height: 8),
            Text(
              'Adicionar foto de capa',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xFF3C4D18),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Recomendado: 1920x1080',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      );
    }

    ImageProvider? imageProvider;
    if (kIsWeb && _coverImageBytes != null) {
      imageProvider = MemoryImage(_coverImageBytes!);
    } else if (!kIsWeb && _coverImagePath != null) {
      imageProvider = FileImage(File(_coverImagePath!));
    }

    return Container(
      decoration: BoxDecoration(
        image: imageProvider != null
            ? DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        )
            : null,
      ),
    );
  }

  Widget _buildProfileImagePreview() {
    final tempUserData = {
      'profileImage': _profileImagePath,
      'profileImageBytes': _profileImageBytes,
    };

    return ProfileImageWidget(userData: tempUserData, radius: 55);
  }
}