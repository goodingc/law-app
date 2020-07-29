import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:law_app/views/commercial_awareness/event.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

import '../../models/commercial_awareness/search.dart';
import '../../providers/commercial_awareness/search.dart';
import 'events_feed.dart';

class CommercialAwarenessView extends StatefulWidget {
  @override
  _CommercialAwarenessViewState createState() =>
      _CommercialAwarenessViewState();
}

class _CommercialAwarenessViewState extends State<CommercialAwarenessView> with AutomaticKeepAliveClientMixin<CommercialAwarenessView> {
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                      decoration: InputDecoration(
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
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 40,
                    ),
                    padding: EdgeInsets.all(0),
                    visualDensity: VisualDensity(horizontal: -4),
                    onPressed: () {
                      _controller.clear();
                      FocusScope.of(context).unfocus();
                    },
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
                  onGenerateRoute: (settings) {
                    Widget view;
                    switch (settings.name) {
                      case '/event-feed':
                        view = EventsFeedView();
                        break;
                      case '/event':
                        view = EventView(id: settings.arguments);
                        break;
                      default:
                        view = Center(child: Text(settings.name));
                    }
                    return MaterialPageRoute(builder: (_) => view);
                  },
                )),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  AnimatedContainer(
                color: Colors.white,
                height: _searching ? constraints.maxHeight : 0,
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
                child: ListView(
                  children: [
                    for (var result in _searchResults)
                      Card(
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
                                  describeEnum(result.category).titleCase,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
