import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/comms.dart';
import 'views/menu/menu.dart';
import 'views/news/news.dart';
import 'views/the_city/the_city.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<CommsProvider>(
        create: (_) => CommsProvider(),
      ),
    ],
    child: App(),
  ));
}

class App extends StatelessWidget {
  static const String _title = 'Law App';

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.amber);
    return MaterialApp(
        title: _title,
        home: MainNavigator(),
        theme: Theme.of(context).copyWith(
            colorScheme: colorScheme,
          primaryColor: colorScheme.primary,
          accentColor: colorScheme.primaryVariant
        ));
  }
}

class MainNavigator extends StatefulWidget {
  MainNavigator({Key key}) : super(key: key);

  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class MainNavLocation {
  final String title;
  final IconData navIcon;
  final Widget view;

  const MainNavLocation(this.title, this.navIcon, {this.view});
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;
  bool _animating = false;

  final PageController _pageController = PageController(
    initialPage: 0,
  );

  static final List<MainNavLocation> _navLocations = [
    MainNavLocation('News', Icons.description, view: NewsView()),
    MainNavLocation('The City', Icons.business, view: TheCityView()),
    MainNavLocation('Menu', Icons.menu, view: MenuView())
  ];

  _MainNavigatorState() {
    _pageController.addListener(() {
      if (_animating) return;
      setState(() {
        _selectedIndex = _pageController.page.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          for (var location in _navLocations)
            location.view ?? Center(child: Text(location.title))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          for (var location in _navLocations)
            BottomNavigationBarItem(
                icon: Icon(location.navIcon), title: Text(location.title))
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: (int index) async {
          setState(() {
            _selectedIndex = index;
            _animating = true;
          });
          await _pageController.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
          setState(() {
            _animating = false;
          });
        },
        showUnselectedLabels: false,
        type: BottomNavigationBarType.shifting,
      ),
    );
  }
}
