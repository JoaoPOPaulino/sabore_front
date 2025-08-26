import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class SetupProfileScreen extends ConsumerStatefulWidget {
  @override
  _SetupProfileScreenState createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends ConsumerState<SetupProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  String? _usernameError;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _checkUsernameAvailability(String username) async {
    // Simula uma chamada de API para verificar unicidade (substitua pelo Dio)
    await Future.delayed(Duration(seconds: 1)); // Simulação
    // Aqui você faria uma requisição para verificar se o username já existe
    // Exemplo: _dio.get('/check-username?username=$username')
    // Se existir, define _usernameError
    if (username == 'joao' || username == 'maria') {
      setState(() {
        _usernameError = 'Este username já está em uso';
      });
    } else {
      setState(() {
        _usernameError = null;
      });
    }
  }

  void _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      if (_usernameError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_usernameError!)),
        );
        return;
      }
      // Salva o perfil (simulação)
      await ref.read(authProvider.notifier).completeProfileSetup();
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Lógica para selecionar foto (opcional)
                  // Exemplo: image_picker
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.camera_alt, size: 40, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                label: 'Username',
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username é obrigatório';
                  }
                  return null;
                },
                onChanged: _checkUsernameAvailability,
              ),
              if (_usernameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(_usernameError!, style: TextStyle(color: Colors.red)),
                ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Salvar',
                onPressed: _submitProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}