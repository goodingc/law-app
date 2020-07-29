import '../../models/commercial_awareness/search.dart';
import '../comms.dart';

class CommercialAwarenessSearchProvider {
  CommsProvider comms;

  Future<List<CommercialAwarenessSearchResult>> search(String query) async {
    return [for (int i = 0; i < query.length; i++) CommercialAwarenessSearchResult(
      id: 0,
      title: query.substring(0, i+1),
      category: CommercialAwarenessSearchCategory.event,
    )];
  }
}
