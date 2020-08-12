import 'package:flutter/material.dart';

import '../../models/news/article.dart';
import '../search/search.dart';
import '../titled_navigator.dart';
import 'article.dart';
import 'feed.dart';

class NewsView extends StatefulWidget {
  @override
  NewsViewState createState() => NewsViewState();
}

class NewsViewState extends State<NewsView> {

  @override
  Widget build(BuildContext context) => SearchFrame<NewsArticleSearchResult>(
        initialTitle: 'News',
        routeViewBuilders: {
          '/feed': (_, __) => NewsFeedView(),
          '/article': (_, id) => NewsArticleView(id: id)
        },
        initialRoute: '/feed',
        searchDelegate: (_) => List<NewsArticleSearchResult>.generate(
            2, (id) => generateArticle(id)),
        buildResult: (context, articleResult) => Card(
            child: InkWell(
          onTap: () {
            TitledNavigator.of(context).pushReplacementNamed('/article', arguments: articleResult.id, newTitle: articleResult.title);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(articleResult.title,
                style: Theme.of(context).textTheme.headline5),
          ),
        )),
      );
}
