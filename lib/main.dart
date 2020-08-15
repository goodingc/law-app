import 'package:flutter/material.dart';
import 'package:law_app/views/main_navigator.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainNavigator(),
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue, accentColor: Colors.lightBlueAccent)),
    );
  }
}
