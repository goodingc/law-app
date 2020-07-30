import 'package:flutter/foundation.dart';

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

extension CommercialAwarenessSearchCategoryExtensions on CommercialAwarenessSearchCategory {
  String get name => describeEnum(this);

  String get viewRoute => '/${name.replaceAll(' ', '-')}';
}