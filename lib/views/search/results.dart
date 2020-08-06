import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:law_app/models/news/article.dart';
import 'package:law_app/views/news/news.dart';

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

class ResultsView<R> extends PopupRoute<Null> {
  final Widget Function(BuildContext, R) buildResult;

  ResultsView({@required this.buildResult});

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
      Animation<double> secondaryAnimation, Widget child) {
    final curveTween = CurveTween(curve: Curves.ease);
    return FrostTransition(
        animation: Tween<double>(
          begin: 0,
          end: 10,
        ).chain(curveTween).animate(animation),
        child: Align(
          alignment: AlignmentDirectional.topCenter,
          child: SizeTransition(
            axisAlignment: -1,
            sizeFactor: Tween<double>(
              begin: 0,
              end: 1,
            ).chain(curveTween).animate(animation),
            child: child,
          ),
        ));
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      ListView(
        children: [
          for (var result in List<NewsArticleSearchResult>.generate(
              2, (id) => generateArticle(id)))
            Card(
              child: InkWell(
                onTap: () {
                  context
                      .findAncestorStateOfType<NewsViewState>()
                      .cancelSearch();
                  Navigator.of(context)
                      .pushNamed('/article', arguments: result.id);
                },
                child: ListTile(
                    title: Text(
                  result.title,
                  style: Theme.of(context).textTheme.headline5,
                )),
              ),
            )
        ],
      );
}
