import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';

import 'article.dart';
import 'feed.dart';
import 'search.dart';

class NewsView extends StatefulWidget {
  @override
  NewsViewState createState() => NewsViewState();
}

class NewsViewState extends State<NewsView> {
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  bool _searching = false;

  Route _resolveRoute(String name, [Object arguments]) {
    Widget view;
    switch (name) {
      case '/feed':
        view = NewsFeedView();
        break;
      case '/article':
        view = NewsArticleView(id: arguments);
        break;
      default:
        view = Center(child: Text(name));
    }
    return MaterialPageRoute(builder: (_) => view);
  }

  void cancelSearch() {
    _textController.clear();
    FocusScope.of(context).unfocus();
    _navigator.currentState.pop();
    setState(() {
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                  width: _searching ? constraints.maxWidth - 40 : 40,
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        _searching = true;
                      });
                      unawaited(_navigator.currentState.push(SearchView()));
                      await Future.delayed(Duration(milliseconds: 500));
                      _textFocusNode.requestFocus();
                    },
                    child: Chip(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      label: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _textFocusNode,
                              controller: _textController,
                            ),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(0),
                      visualDensity:
                          const VisualDensity(vertical: -4, horizontal: -4),
                    ),
                  ),
                ),
                AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                    width: _searching ? 0 : constraints.maxWidth - 80,
                    child: Center(
                        child: Text(
                      'News',
                      overflow: TextOverflow.fade,
                    ))),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                  opacity: _searching ? 1 : 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 40,
                    ),
                    padding: const EdgeInsets.all(0),
                    visualDensity: const VisualDensity(horizontal: -4),
                    onPressed: cancelSearch,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (_searching) {
            cancelSearch();
          } else {
            _navigator.currentState.pop();
          }
          return Future.value(false);
        },
        child: Navigator(
          key: _navigator,
          initialRoute: '/feed',
          onGenerateInitialRoutes: (state, initialRoute) {
            return [_resolveRoute(initialRoute)];
          },
          onGenerateRoute: (settings) {
            return _resolveRoute(settings.name, settings.arguments);
          },
        ),
      ),
    );
  }
}
