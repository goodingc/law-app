import '../../models/commercial_awareness/search.dart';
import '../comms.dart';

class CommercialAwarenessSearchProvider {
  CommsProvider comms;

  Future<List<CommercialAwarenessSearchResult>> search(String query) async {
    return [for (int i = 0; i < 2; i++) CommercialAwarenessSearchResult(
      id: i,
      title: 'Commercial Awareness Event $i',
      category: CommercialAwarenessSearchCategory.event,
    )];
  }
}
