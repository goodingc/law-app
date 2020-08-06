import 'package:flutter/foundation.dart';

import 'the_city.dart';

class Case extends TheCityEntity {
  final String claimant;
  final String defendant;
  final DateTime decidedOn;
  final String court;
  final int number;

  Case(
      {@required id,
      @required this.claimant,
      @required this.defendant,
      @required this.decidedOn,
      @required this.court,
      @required this.number})
      : super(id: id);
}

final cases = [
  Case(
    id: 0,
    claimant: 'R (E)',
    defendant: 'Governing Body of JFS',
    decidedOn: DateTime.utc(2009, DateTime.december, 14),
    court: 'UKSC',
    number: 15
  ),
  Case(
    id: 1,
    claimant: 'Steinfeld and Keidan',
    defendant: 'Secretary of State for Education',
    decidedOn: DateTime.utc(2017, DateTime.february, 21),
    court: 'EWCA Civ',
    number: 81
  )
];
