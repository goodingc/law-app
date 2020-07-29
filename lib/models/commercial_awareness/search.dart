import 'package:flutter/material.dart';

import 'commercial_awareness.dart';

class CommercialAwarenessSearchResult extends CommercialAwarenessEntity {
  final CommercialAwarenessSearchCategory category;
  final String title;

  CommercialAwarenessSearchResult({
    @required id,
    @required this.category,
    @required this.title
  }): super(id: id);


}

enum CommercialAwarenessSearchCategory {
  event,
  firm
}