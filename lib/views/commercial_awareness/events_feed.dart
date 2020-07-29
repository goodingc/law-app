import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../providers/commercial_awareness/events.dart';

class EventsFeedView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<CommercialAwarenessEventsProvider>(
      builder: (context, eventsProvider, _) => RefreshIndicator(
        child: ListView(
          children: <Widget>[
            for (var eventBrief in eventsProvider.eventBriefs)
              Card(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/event', arguments: eventBrief.id);
                  },
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        eventBrief.imageUrl,
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
                                      child: Text(eventBrief.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    )),
                                    Text(timeago.format(eventBrief.timestamp),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1)
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
                                  eventBrief.caption,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              )
          ],
        ),
        onRefresh: () async {
          await eventsProvider.pullBriefs();
        },
      ),
    );
  }
}

//class EventsFeedView extends StatelessWidget {
//  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
//
//  List<String> _practiceAreas = const [
//    "Banking and Debt Finance Law",
//    "Charity Law",
//    "Civil litigation dispute resolution law",
//    "Commercial Law",
//    "Construction Law",
//    "Consumer Law",
//    "Corporate Law",
//    "Criminal Law",
//    "Employment Law",
//    "Environmental Law",
//    "Family Law",
//    "Housing Law",
//    "Human Rights Law",
//    "Immigration and Asylum Law",
//    "Insurance Law",
//    "Intellectual Property Law",
//    "Personal injury and clinical negligence law",
//    "Private client law",
//    "Property law",
//    "Public companies and equity finance law",
//    "Restructuring and insolvency law",
//    "Shipping law",
//    "Social welfare law",
//    "Tax law"
//  ];
//
//  final Function(Widget) _setParentView;
//
//  EventsFeedView(this._setParentView);
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.grey,
//        key: _scaffoldKey,
//        body: ListView(
//          children: <Widget>[
//            for (var i = 0; i < 100; i++)
//              Card(
//                child: InkWell(
//                  onTap: () {
//                    _setParentView(EventView(_setParentView));
//                  },
//                  child: Column(
//                    children: <Widget>[
//                      Image.network(
//                        'http://placekitten.com/g/400/200',
//                        fit: BoxFit.fitWidth,
//                      ),
//                      Padding(
//                          padding: EdgeInsets.all(16),
//                          child: Column(
//                            children: <Widget>[
//                              Padding(
//                                padding: EdgeInsets.only(bottom: 4),
//                                child: Row(
//                                  children: <Widget>[
//                                    Expanded(
//                                        child: Align(
//                                      alignment: Alignment.centerLeft,
//                                      child: Text("Event title",
//                                          style: Theme.of(context)
//                                              .textTheme
//                                              .headline6),
//                                    )),
//                                    Text("5 mins ago",
//                                        style:
//                                            Theme.of(context).textTheme.subtitle1)
//                                  ],
//                                ),
//                              ),
//                              Row(
//                                children: <Widget>[
//                                  for (var i = 0; i < 3; i++)
//                                    Padding(
//                                        padding: EdgeInsets.only(right: 4),
//                                        child: Chip(
//                                          label: Text(
//                                            'Test Tag',
//                                            style: Theme.of(context)
//                                                .textTheme
//                                                .caption,
//                                          ),
//                                          padding: EdgeInsets.all(0),
//                                          visualDensity: VisualDensity(
//                                              horizontal: -4, vertical: -4),
//                                        ))
//                                ],
//                              ),
//                              Align(
//                                alignment: Alignment.topLeft,
//                                child: Text(
//                                  "Lorem ipsum dolor sit amet, consectetur adipiscing "
//                                  "elit. Sed pharetra tortor metus, pharetra dignissim "
//                                  "ligula aliquam vel. Sed at imperdiet dui, sed "
//                                  "dapibus eros. Maecenas et quam in velit mollis "
//                                  "mattis. Quisque accumsan ante et lacus accumsan "
//                                  "dignissim. Duis malesuada nibh in convallis "
//                                  "consectetur. Aenean porta dapibus suscipit. "
//                                  "Aliquam luctus sollicitudin pretium.",
//                                  style: Theme.of(context).textTheme.bodyText2,
//                                ),
//                              )
//                            ],
//                          )),
//                    ],
//                  ),
//                ),
//              )
//          ],
//        ),
//        floatingActionButton: Padding(
//            padding: const EdgeInsets.only(left: 30.0),
//            child: Row(
//              children: <Widget>[
//                FloatingActionButton(
//                  onPressed: () {
//                    _scaffoldKey.currentState.openDrawer();
//                  },
//                  child: Icon(Icons.menu),
//                  backgroundColor: Colors.amber[800],
//                ),
//              ],
//            )),
//        drawer: Drawer(
//            child: ListView(
//          children: <Widget>[
//            for (var practiceArea in _practiceAreas)
//              ListTile(
//                title: Text(practiceArea),
//              ),
//          ],
//        )));
//  }
//}
