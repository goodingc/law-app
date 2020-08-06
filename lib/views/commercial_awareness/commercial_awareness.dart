import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:law_app/views/commercial_awareness/search.dart';
import 'package:provider/provider.dart';

import '../../models/commercial_awareness/search.dart';
import '../../providers/commercial_awareness/search.dart';
import 'event.dart';
import 'events_feed.dart';

class CommercialAwarenessView extends StatefulWidget {
  @override
  CommercialAwarenessViewState createState() => CommercialAwarenessViewState();
}

class CommercialAwarenessViewState extends State<CommercialAwarenessView>
    with AutomaticKeepAliveClientMixin<CommercialAwarenessView> {
  final TextEditingController _controller = TextEditingController();
  bool searching = false;
  List<CommercialAwarenessSearchResult> searchResults = [];
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
                searchResults = results;
              }));
    });
  }

  void _cancelSearch() {
    _controller.clear();
    FocusScope.of(context).unfocus();
    _navigator.currentState.pop();
    setState(() {
      searching = false;
    });
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
    return MaterialPageRoute(builder: (_) => view);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                    width: searching ? constraints.maxWidth - 40 : 40,
                    child: GestureDetector(
                      onTap: () {
                        _navigator.currentState.push(OverlayMenuPage());
                        setState(() {
                          searching = true;
                        });
                      },
                      child: Chip(
                        backgroundColor: Colors.white,
                        label: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Theme.of(context).primaryColor,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _controller,
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
                      width: searching ? 0 : constraints.maxWidth - 80,
                      child: Center(
                          child: Text(
                        'News',
                        overflow: TextOverflow.fade,
                      ))),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                    opacity: searching ? 1 : 0,
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
                ],
              );
            },
          ),
        ),
        body: Stack(
          children: [
            WillPopScope(
                onWillPop: () {
                  _cancelSearch();
                  return Future.value(false);
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
          ],
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
