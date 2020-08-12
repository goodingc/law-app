import 'dart:developer';

import 'package:flutter/material.dart';

class TitledNavigator extends StatefulWidget {
  final String initialTitle;
  final Map<String, Widget Function(BuildContext, Object)> routeViewBuilders;
  final String initialRoute;
  final Widget Function(BuildContext, String) buildTitle;

  TitledNavigator(
      {Key key,
      this.initialTitle,
      @required this.routeViewBuilders,
      this.initialRoute,
      this.buildTitle})
      : super(key: key);

  @override
  TitledNavigatorState createState() =>
      TitledNavigatorState(initialTitle: initialTitle);

  static TitledNavigatorState of(BuildContext context) =>
      context.findAncestorStateOfType<TitledNavigatorState>();
}

class TitledNavigatorState extends State<TitledNavigator> {
  GlobalKey<NavigatorState> navigator;

  final List<String> titleStack;

  TitledNavigatorState({String initialTitle}) : titleStack = [initialTitle];

  String get title => titleStack.last;

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: widget.buildTitle(context, title)),
        body: WillPopScope(
          onWillPop: () {
            pop();
            return Future.value(false);
          },
          child: Navigator(
              key: navigator,
              initialRoute: widget.initialRoute,
              onGenerateInitialRoutes: (_, initialRoute) =>
                  [_resolveRoute(RouteSettings(name: initialRoute))],
              onGenerateRoute: _resolveRoute),
        ),
      );

  @optionalTypeArgs
  Future<T> pushNamed<T extends Object>(String routeName,
      {Object arguments, String newTitle}) {
    setState(() {
      titleStack.add(newTitle ?? title);
    });
    return navigator.currentState.pushNamed<T>(routeName, arguments: arguments);
  }

  @optionalTypeArgs
  void pop<T extends Object>([T result]) {
    setState(() {
      titleStack.removeLast();
    });
    return navigator.currentState.pop<T>(result);
  }

  @optionalTypeArgs
  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
      String routeName,
      {TO result,
      Object arguments,
      String newTitle}) {
    setState(() {
      titleStack.last = newTitle ?? title;
    });
    return navigator.currentState.pushReplacementNamed<T, TO>(routeName,
        result: result, arguments: arguments);
  }

  @override
  void initState() {
    super.initState();
    navigator = GlobalKey<NavigatorState>();
  }

  Route _resolveRoute(RouteSettings settings) => MaterialPageRoute(
        builder: (context) =>
            widget.routeViewBuilders.containsKey(settings.name)
                ? widget.routeViewBuilders[settings.name](
                    context, settings.arguments)
                : Center(child: Text(settings.name)));
}
