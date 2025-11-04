import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final double radius;
  final BoxFit boxFit;

  const ProfileImageWidget({
    Key? key,
    required this.userData,
    this.radius = 25,
    this.boxFit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return _buildPlaceholder();
    }

    // Para usar como imagem de fundo (radius infinito)
    if (radius == double.infinity) {
      return _buildFullSizeImage();
    }

    // Para web
    if (kIsWeb && userData!['profileImageBytes'] != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: MemoryImage(userData!['profileImageBytes'] as Uint8List),
      );
    }

    // Para mobile
    if (!kIsWeb && userData!['profileImage'] != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: FileImage(File(userData!['profileImage'])),
      );
    }

    // Sem imagem
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    if (radius == double.infinity) {
      return Container(
        color: Color(0xFFF5F5F5),
        child: Center(
          child: Icon(Icons.person, size: 100, color: Color(0xFFFA9500)),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Color(0xFFF5F5F5),
      child: Icon(Icons.person, size: radius * 0.8, color: Color(0xFFFA9500)),
    );
  }

  Widget _buildFullSizeImage() {
    ImageProvider? imageProvider;

    if (kIsWeb && userData!['profileImageBytes'] != null) {
      imageProvider = MemoryImage(userData!['profileImageBytes'] as Uint8List);
    } else if (!kIsWeb && userData!['profileImage'] != null) {
      imageProvider = FileImage(File(userData!['profileImage']));
    }

    if (imageProvider == null) {
      return _buildPlaceholder();
    }

    return Image(
      image: imageProvider,
      fit: boxFit,
    );
  }
}