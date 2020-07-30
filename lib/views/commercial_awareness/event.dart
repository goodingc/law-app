import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../../providers/commercial_awareness/events.dart';

class EventView extends StatelessWidget {
  final int id;

  EventView({@required this.id});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommercialAwarenessEventsProvider>(
      builder: (context, eventsProvider, _) {
        final event = eventsProvider.getEvent(id);
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text(event.title),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                floating: false,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      event.imageUrl,
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
                                    child: Text(timeago.format(event.timestamp),
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
                                data: event.content,
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
      },
    );
  }
}
