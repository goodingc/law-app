import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

import '../../models/commercial_awareness/search.dart';
import '../../providers/commercial_awareness/search.dart';
import 'event.dart';
import 'events_feed.dart';

class CommercialAwarenessView extends StatefulWidget {
  @override
  _CommercialAwarenessViewState createState() =>
      _CommercialAwarenessViewState();
}

class _CommercialAwarenessViewState extends State<CommercialAwarenessView>
    with AutomaticKeepAliveClientMixin<CommercialAwarenessView> {
  final TextEditingController _controller = TextEditingController();
  bool _searching = false;
  List<CommercialAwarenessSearchResult> _searchResults = [];
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      Provider.of<CommercialAwarenessSearchProvider>(context, listen: false)
          .search(_controller.text)
          .then((results) => setState(() {
                _searchResults = results;
              }));
      setState(() {
        _searching = _controller.text.isNotEmpty;
      });
    });
  }

  void _cancelSearch() {
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  Route _resolveRoute(String name, [Object arguments]) {
    Widget view;
    switch (name) {
      case '/event-feed':
        view = EventsFeedView();
        break;
      case '/event':
        view = EventView(id: arguments);
        break;
      default:
        view = Center(child: Text(name));
    }
    return MaterialPageRoute(
        builder: (_) => view
    );
    return PageRouteBuilder(
        pageBuilder: (_, __, ___) => view,
        transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) =>
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child:
              child, // child is the value returned by pageBuilder
            )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Chip(
                  backgroundColor: Colors.white,
                  label: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                      )),
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  visualDensity: const VisualDensity(vertical: -4),
                ),
              ),
              AnimatedContainer(
                width: _searching ? 27 : 0,
                curve: Curves.ease,
                duration: const Duration(milliseconds: 500),
                child: AnimatedOpacity(
                  opacity: _searching ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 40,
                    ),
                    padding: const EdgeInsets.all(0),
                    visualDensity: const VisualDensity(horizontal: -4),
                    onPressed: _cancelSearch,
                  ),
                ),
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            WillPopScope(
                onWillPop: () async {
                  _navigator.currentState.pop();
                  return false;
                },
                child: Navigator(
                  key: _navigator,
                  initialRoute: '/event-feed',
                  onGenerateInitialRoutes: (state, initialRoute) {
                    return [_resolveRoute(initialRoute)];
                  },
                  onGenerateRoute: (settings) {
                    return _resolveRoute(settings.name, settings.arguments);
                  },
                )),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  AnimatedContainer(
//                color: Color.fromRGBO(255, 255, 255, 0.5),
                height: _searching ? constraints.maxHeight : 0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: ListView(
                    children: [
                      for (var result in _searchResults)
                        Card(
                          child: InkWell(
                            onTap: () {
                              _navigator.currentState.pushNamed(
                                  result.category.viewRoute,
                                  arguments: result.id);
                              _cancelSearch();
                            },
                            child: ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    result.title,
                                    style: Theme.of(context).textTheme.headline5,
                                  )),
                                  Chip(
                                    label: Text(
                                      result.category.name.titleCase,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
