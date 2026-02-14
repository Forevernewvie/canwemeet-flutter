import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  return SharedPreferences.getInstance();
}
