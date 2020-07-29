import 'package:flutter/material.dart';

import 'commercial_awareness.dart';

class CommercialAwarenessEventBrief extends CommercialAwarenessEntity {
  final String title;
  final DateTime timestamp;
  final String imageUrl;
  final String caption;

  CommercialAwarenessEventBrief({
    @required id,
    @required this.title,
    @required this.timestamp,
    this.imageUrl,
    this.caption,
  }) : super(id: id);

}