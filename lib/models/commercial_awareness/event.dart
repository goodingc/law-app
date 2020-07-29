import 'package:flutter/material.dart';

import 'event_brief.dart';

class CommercialAwarenessEvent extends CommercialAwarenessEventBrief {
  final String content;

  CommercialAwarenessEvent({
    @required id,
    @required title,
    @required timestamp,
    imageUrl,
    caption,
    @required this.content
  }) : super(
      id: id,
      title: title,
      timestamp: timestamp,
      imageUrl: imageUrl,
      caption: caption
  );
}