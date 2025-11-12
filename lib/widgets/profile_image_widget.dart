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

    return CircleAvatar(
      radius: radius,
      backgroundImage: _getImageProvider(),
      backgroundColor: Color(0xFFF5F5F5),
      child: _getImageProvider() == null
          ? Icon(Icons.person, size: radius * 0.8, color: Color(0xFFFA9500))
          : null,
    );
  }

  ImageProvider? _getImageProvider() {
    // Web: Verifica bytes
    if (kIsWeb && userData!['profileImageBytes'] != null) {
      return MemoryImage(userData!['profileImageBytes'] as Uint8List);
    }

    // Mobile/Web: Verifica path
    final profileImage = userData!['profileImage'];
    if (profileImage != null && profileImage is String && profileImage.isNotEmpty) {
      // Se for asset
      if (profileImage.startsWith('assets/')) {
        return AssetImage(profileImage);
      }
      // Se for arquivo local (mobile)
      if (!kIsWeb) {
        return FileImage(File(profileImage));
      }
    }

    return null;
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
    final imageProvider = _getImageProvider();

    if (imageProvider == null) {
      return _buildPlaceholder();
    }

    return Image(
      image: imageProvider,
      fit: boxFit,
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder();
      },
    );
  }
}