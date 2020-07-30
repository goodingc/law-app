import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

import '../../models/commercial_awareness/search.dart';
import '../../providers/commercial_awareness/search.dart';
import 'commercial_awareness.dart';

class FrostTransition extends AnimatedWidget {
  final Widget child;
  final Animation<double> animation;

  FrostTransition({this.animation, this.child}) : super(listenable: animation);

  @override
  Widget build(BuildContext context) => BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: animation.value, sigmaY: animation.value),
        child: Container(
          child: child,
        ),
      );
}

class OverlayMenuPage extends PopupRoute<Null> {
  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      FrostTransition(
        animation: Tween<double>(
          begin: 0,
          end: 10,
        ).animate(animation),
        child: child,
      );

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      ListView(
        children: [
          for (var result in context
              .findAncestorStateOfType<CommercialAwarenessViewState>()
              .searchResults)
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(result.category.viewRoute, arguments: result.id);
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
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
        ],
      );
}
