import 'package:bc4f/provider/tag-provider.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/router/router.dart';
import 'package:bc4f/widget/wrappers/is-auth.dart';
import 'package:bc4f/utils/app-status.dart';
import 'package:bc4f/widget/wrappers/firebase-app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FirebaseApplication(
      child: App(),
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
      child: ChangeNotifierProvider(
        create: (ctx) => TagProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: AppStatus().navKey,
          title: 'Bc4f',
          theme: ThemeData(
            textTheme: TextTheme(subtitle1: TextStyle(fontSize: 18)),
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: Routing.onGenerateRoute,
        ),
      ),
    );
  }
}
