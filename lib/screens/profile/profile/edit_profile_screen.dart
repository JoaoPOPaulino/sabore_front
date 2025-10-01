import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../providers/auth_provider.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userData = ref.read(currentUserDataProvider);
    _nameController = TextEditingController(text: userData?['name'] ?? '');
    _usernameController = TextEditingController(text: userData?['username'] ?? '');
    _profileImagePath = userData?['profileImage'];
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
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        setState(() {
          _profileImagePath = image.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao selecionar imagem'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);

      await authService.updateProfile(
        username: _usernameController.text,
        profileImagePath: _profileImagePath,
      );

      // Atualizar dados locais
      final currentData = ref.read(currentUserDataProvider);
      if (currentData != null) {
        ref.read(currentUserDataProvider.notifier).state = {
          ...currentData,
          'name': _nameController.text,
          'username': _usernameController.text,
          'profileImage': _profileImagePath,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar perfil'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(currentUserDataProvider);

    return Scaffold(
      backgroundColor: Color(0xFFFFF8F0),
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
              Icons.arrow_back_ios_new,
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
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Foto de perfil
            GestureDetector(
              onTap: _pickProfileImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImagePath != null
                        ? FileImage(File(_profileImagePath!))
                        : null,
                    backgroundColor: Color(0xFFF5F5F5),
                    child: _profileImagePath == null
                        ? Icon(Icons.person, size: 60, color: Color(0xFFFA9500))
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFFA9500),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

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
                ),
              ),
            ),

            SizedBox(height: 16),

            // Email (read-only)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(Icons.email, color: Color(0xFF999999)),
                  SizedBox(width: 12),
                  Text(
                    userData?['email'] ?? '',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Color(0xFF999999),
                    ),
                  ),
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
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Salvar Alterações',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}