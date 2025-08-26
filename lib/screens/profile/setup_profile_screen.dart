import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

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
    await Future.delayed(const Duration(seconds: 1)); // Simulação de API
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
      await ref.read(authProvider.notifier).completeProfileSetup();
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
          ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              // Cabeçalho
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFF3C4D18)),
                    onPressed: () => context.pop(),
                  ),
                  Text(
                    'Perfil',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
                  SizedBox(width: 40), // Placeholder para alinhamento
                ],
              ),
              SizedBox(height: 40),
              // Área de upload de foto
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload, size: 40, color: Color(0xFF3C4D18)),
                      SizedBox(height: 10),
                      Text(
                        'Faça upload da sua foto de perfil',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF3C4D18),
                        ),
                      ),
                      Text(
                        '*Tamanho máximo 2MB',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF3C4D18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Campo de username
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                  ],
                ),
              ),
              SizedBox(height: 40),
              // Botão Próximo
              Center(
                child: CustomButton(
                  text: 'Próximo',
                  onPressed: _submitProfile,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}