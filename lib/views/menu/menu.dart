import 'package:flutter/material.dart';
import 'package:law_app/views/menu/home.dart';
import '../titled_navigator.dart';

class MenuView extends StatelessWidget {

  @override
  Widget build(BuildContext context) => TitledNavigator(
    initialTitle: 'Menu',
    routeViewBuilders: {
      '/': (context, _) => MenuHomeView()
    },
    buildTitle: (_, title) => Center(
      child: Text(title),
    ),
  );
}
