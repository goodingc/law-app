import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:law_app/views/titled_navigator.dart';

class MenuHomeView extends StatelessWidget {

  static final List<MenuItem> _items = [
    MenuItem(name: 'Settings', icon: Icons.settings),
    MenuItem(name: 'About', icon: Icons.info),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for(var item in _items)
          Card(
              child: InkWell(
                onTap: () {
                  TitledNavigator.of(context).pushNamed('/profile');
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(item.name,
                            style: Theme.of(context).textTheme.headline5),
                      ),
                      Icon(item.icon)
                    ],
                  ),
                ),
              ))
      ],
    );
  }
}

class MenuItem {
  final String name;
  final IconData icon;
  final String target;

  MenuItem({
    @required this.name,
    @required this.icon,
    this.target
});
}