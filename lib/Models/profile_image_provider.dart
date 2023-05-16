import 'package:flutter/material.dart';

class ProfileImageProvider extends ChangeNotifier {
  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  void setImageUrl(String? url) {
    _imageUrl = url;
    notifyListeners();
  }
}
