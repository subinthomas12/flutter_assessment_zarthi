import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs =>
      SharedPreferences.getInstance();

  @lazySingleton
  InternetConnection get internetConnection =>
      InternetConnection();
}