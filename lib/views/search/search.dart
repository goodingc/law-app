import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';

import 'results.dart';

class SearchFrame<R> extends StatefulWidget {
  final String title;
  final Map<String, Widget Function(BuildContext, Object)> routeViewBuilders;
  final String initialRoute;
  final List<R> Function(String) searchDelegate;
  final Widget Function(BuildContext, R) buildResult;

  SearchFrame(
      {@required this.title,
      @required this.routeViewBuilders,
      this.initialRoute,
      @required this.searchDelegate,
      @required this.buildResult});

  @override
  _SearchFrameState<R> createState() => _SearchFrameState<R>();
}

class _SearchFrameState<R> extends State<SearchFrame<R>> {
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  bool _searching = false;

  Route _resolveRoute(String name, [Object arguments]) => MaterialPageRoute(
      builder: (context) => widget.routeViewBuilders.containsKey(name)
          ? widget.routeViewBuilders[name](context, arguments)
          : Center(child: Text(name)));

  void cancelSearch() {
    _textController.clear();
    FocusScope.of(context).unfocus();
    _navigator.currentState.pop();
    setState(() {
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                        unawaited(_navigator.currentState.push(
                            ResultsView(buildResult: widget.buildResult)));
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
                        widget.title,
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
            initialRoute: widget.initialRoute,
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
