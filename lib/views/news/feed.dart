import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../models/news/article.dart';
import '../titled_navigator.dart';

class NewsFeedView extends StatefulWidget {
  @override
  _NewsFeedViewState createState() => _NewsFeedViewState();
}

class _NewsFeedViewState extends State<NewsFeedView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Row(
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                child: Icon(Icons.menu,
                    color: Theme.of(context).colorScheme.surface),
              ),
            ],
          )),
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          for (var practiceArea in _practiceAreas)
            ListTile(
              title: Text(practiceArea),
            ),
        ],
      )),
      body: ListView(
        children: [
          for (var article in List<NewsArticleBrief>.generate(
              10, (id) => generateArticle(id)))
            Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  TitledNavigator.of(context).pushNamed('/article',
                      arguments: article.id, newTitle: article.title);
                },
                child: Column(
                  children: <Widget>[
                    Image.network(
                      article.imageUrl,
                      fit: BoxFit.fitWidth,
                    ),
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(article.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  )),
                                  Text(timeago.format(article.timestamp),
                                      style:
                                          Theme.of(context).textTheme.subtitle1)
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                for (var i = 0; i < 3; i++)
                                  Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: Chip(
                                        label: Text(
                                          'Test Tag',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                        padding: EdgeInsets.all(0),
                                        visualDensity: VisualDensity(
                                            horizontal: -4, vertical: -4),
                                      ))
                              ],
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                article.caption,
                                textAlign: TextAlign.justify,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

List<String> _practiceAreas = const [
  'Banking and Debt Finance Law',
  'Charity Law',
  'Civil litigation dispute resolution law',
  'Commercial Law',
  'Construction Law',
  'Consumer Law',
  'Corporate Law',
  'Criminal Law',
  'Employment Law',
  'Environmental Law',
  'Family Law',
  'Housing Law',
  'Human Rights Law',
  'Immigration and Asylum Law',
  'Insurance Law',
  'Intellectual Property Law',
  'Personal injury and clinical negligence law',
  'Private client law',
  'Property law',
  'Public companies and equity finance law',
  'Restructuring and insolvency law',
  'Shipping law',
  'Social welfare law',
  'Tax law'
];
