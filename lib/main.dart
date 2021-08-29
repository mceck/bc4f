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
  // init local storage
  WidgetsFlutterBinding.ensureInitialized();
  Prefs();
  AppStatus();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FirebaseApplication(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: App(),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({
    Key key,
  }) : super(key: key);

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
            textTheme: TextTheme(subtitle1: TextStyle(fontSize: 18)),
            primarySwatch: Colors.red,
            primaryColor: Colors.redAccent,
            buttonTheme: ThemeData.dark()
                .buttonTheme
                .copyWith(buttonColor: Colors.redAccent),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: Routing.onGenerateRoute,
        ),
      ),
    );
  }
}
