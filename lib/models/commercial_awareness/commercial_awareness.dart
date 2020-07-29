import 'package:flutter/cupertino.dart';

enum CommercialAwarenessEntityCategory {
  event
}

abstract class CommercialAwarenessEntity {
  final int id;

  CommercialAwarenessEntity({
    @required this.id
  });

}
