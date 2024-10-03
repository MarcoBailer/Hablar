import 'package:flutter/material.dart';
import 'package:hablar/src/pages/auth/genre_section_screen.dart';

import '../Widgets/genre_tile.dart';

class UserModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  String _name = '';
  String _secondName = '';
  String _userName = '';

  String get email => _email;
  String get password => _password;
  String get name => _name;
  String get secondName => _secondName;
  String get userName => _userName;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setSecondName(String secondName) {
    _secondName = secondName;
    notifyListeners();
  }

  void setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  List<Genre> _preferredGenres = [];

  List<Genre> get preferredGenres => _preferredGenres;

  void setPreferredGenres(List<Genre> genres) {
    _preferredGenres = genres;
    notifyListeners();
  }
}
