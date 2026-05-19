import 'package:bc4f/provider/barcode-provider.dart';
import 'package:bc4f/provider/group-provider.dart';
import 'package:bc4f/provider/recent-barcode-provider.dart';
import 'package:bc4f/provider/tag-provider.dart';
import 'package:bc4f/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/router/router.dart';
import 'package:bc4f/widget/wrappers/is-auth.dart';
import 'package:bc4f/utils/app-status.dart';
import 'package:bc4f/widget/wrappers/firebase-app.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs();
  AppStatus();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FirebaseApplication(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: const App(),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return IsAuth(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => TagProvider()),
          ChangeNotifierProvider(create: (ctx) => BarcodeProvider()),
          ChangeNotifierProvider(create: (ctx) => GroupProvider()),
          ChangeNotifierProvider(create: (ctx) => RecentBarcodeProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: AppStatus().navKey,
          title: 'Bc4f',
          theme: ThemeData(
            useMaterial3: false,
            primarySwatch: Colors.red,
            primaryColor: Colors.redAccent,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: const TextTheme(
              titleMedium: TextStyle(fontSize: 18),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          onGenerateRoute: Routing.onGenerateRoute,
        ),
      ),
    );
  }
}
