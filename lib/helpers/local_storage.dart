// ignore_for_file: non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

import 'app_logger.dart';

class LocalStorage {
  static final LocalStorage _singleton = LocalStorage._internal();

  factory LocalStorage() {
    return _singleton;
  }

  LocalStorage._internal();

  Future<String?> getFavouriteList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('FAVOURITE_LIST');
  }

  Future<void> saveFavouriteList(String list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('FAVOURITE_LIST', list);
  }
}
