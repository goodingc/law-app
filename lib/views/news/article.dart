import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../../models/news/article.dart';

class NewsArticleView extends StatelessWidget {
  final int id;

  NewsArticleView({this.id});

  @override
  Widget build(BuildContext context) {
    final article = generateArticle(id);
    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(article.title),
//              leading: IconButton(
//                icon: Icon(Icons.arrow_back),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
              floating: false,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    article.imageUrl,
                    fit: BoxFit.cover,
                  )),
            ),
            SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(timeago.format(article.timestamp),
                                      style:
                                      Theme.of(context).textTheme.subtitle1)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: <Widget>[
                                  for (var i = 0; i < 3; i++)
                                    Padding(
                                        padding: EdgeInsets.only(right: 4),
                                        child: Chip(
                                          label: Text(
                                            'Test Tag',
                                            style:
                                            Theme.of(context).textTheme.caption,
                                          ),
                                          padding: EdgeInsets.all(0),
                                          visualDensity: VisualDensity(
                                              horizontal: -4, vertical: -4),
                                        ))
                                ],
                              ),
                            ),
                            MarkdownBody(
                              data: article.content,
                              imageDirectory: 'https://raw.githubusercontent.com',
                              onTapLink: (url) async {
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                            ),
                          ],
                        ))
                  ],
                )),
          ],
        )
    );
  }
}
