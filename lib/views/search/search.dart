import 'package:flutter/material.dart';
import 'package:law_app/views/titled_navigator.dart';
import 'package:pedantic/pedantic.dart';

import 'results.dart';

class SearchFrame<R> extends StatefulWidget {
  final List<R> Function(String) searchDelegate;
  final Widget Function(BuildContext, R) buildResult;
  final String initialTitle;
  final Map<String, Widget Function(BuildContext, Object)> routeViewBuilders;
  final String initialRoute;

  SearchFrame(
      {this.initialTitle,
      @required this.routeViewBuilders,
      this.initialRoute,
      @required this.searchDelegate,
      @required this.buildResult});

  @override
  SearchFrameState<R> createState() =>
      SearchFrameState<R>();

  static SearchFrameState<R> of<R>(BuildContext context) =>
      context.findAncestorStateOfType<SearchFrameState<R>>();
}

class SearchFrameState<R> extends State<SearchFrame<R>> {
  GlobalKey<TitledNavigatorState> _titledNavigator;
  TextEditingController _textController;
  FocusNode _textFocusNode;

  List<R> results = [];
  bool _searching = false;
  String _searchQuery;

  @override
  Widget build(BuildContext context) => TitledNavigator(
    key: _titledNavigator,
    initialTitle: widget.initialTitle,
    routeViewBuilders: widget.routeViewBuilders,
    initialRoute: widget.initialRoute,
    buildTitle: (context, title) => LayoutBuilder(
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
                  _titledNavigatorState.titleStack.add('Search');
                  unawaited(_titledNavigatorState.navigator.currentState
                      .push(ResultsView(
                    buildResult: widget.buildResult,
                  ))
                      .then((_) {
                    _textController.clear();
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _searching = false;
                    });
                  }));
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
                      title,
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
                onPressed: () => _titledNavigatorState.pop(),
              ),
            ),
          ],
        );
      },
    ),
  );

  TitledNavigatorState get _titledNavigatorState => _titledNavigator.currentState;

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _textFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textFocusNode = FocusNode();

    _textController.addListener(() {
      final searchQuery = _textController.value.text;
      if (searchQuery != _searchQuery) {
        setState(() {
          results = widget.searchDelegate(searchQuery);
          _searchQuery = searchQuery;
        });
      }
    });

    _titledNavigator = GlobalKey<TitledNavigatorState>();
  }

  @override
  SearchFrame<R> get widget => super.widget;
}
