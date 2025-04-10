import 'dart:convert';

import 'package:coin_cap/models/app_config.dart';
import 'package:coin_cap/pages/HomePage.dart';
import 'package:coin_cap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async {
  // When Flutter starts, it needs to:
  // Set up the connection between Dart code and native code (Android/iOS).
  // Initialize system services like plugins, fonts, assets, and rendering, local storage.
  // Prepare platform channels to communicate with Firebase, SharedPreferences, databases, etc.
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
  registerHTTPService();
  await GetIt.instance.get<HttpService>().get("/coins/bitcoin");
  runApp(const MyApp());
}

Future<void> loadConfig() async {
  // The assets in the root folder are bundled into rootBundle as declared in pubspec
  String configContent = await rootBundle
      .loadString("assets/config/main.json"); // loaded as a string
  Map configData = jsonDecode(
      configContent); // json is a sent as a string and then decoded into actual objects that we can access properties of
  // print(configData);

  // AppConfig Instance
  // Can be accessed from anywhere, won't have to pass/access context
  // Won't have to create new instances in each widget, global access instance
  GetIt.instance.registerSingleton<AppConfig>(AppConfig(
    COIN_BASE_API_URL: configData["COIN_API_BASE_URL"],
  ));
}

void registerHTTPService() {
  GetIt.instance.registerSingleton<HttpService>(
    HttpService(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: Color.fromRGBO(88, 68, 197, 1)),
      home: const HomePage(),
    );
  }
}
