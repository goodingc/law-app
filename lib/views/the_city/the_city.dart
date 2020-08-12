import 'package:flutter/material.dart';
import 'package:law_app/views/the_city/home.dart';
import '../search/search.dart';

class TheCityView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SearchFrame(
      initialTitle: 'The City',
      routeViewBuilders: {
        '/': (_, __) => TheCityHomeView(),
      },
      searchDelegate: (_) => [],
      buildResult: (_, __) => Container(),
    );
  }
}
