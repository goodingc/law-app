import 'package:flutter/foundation.dart';

import 'the_city.dart';

class LegalTerm extends TheCityEntity {
  final String title;
  final String subtitle;
  final String explanation;

  LegalTerm({
    id,
    @required this.title,
    this.subtitle,
    @required this.explanation,
  }) : super(id: id);
}

final legalTerms = [
  LegalTerm(
      id: 0,
      title: 'Adjective Law',
      subtitle: 'or Procedural Law',
      explanation: 'That area of the law that deals with procedural rules of '
          'evidence, pleadings and practice.'),
  LegalTerm(
      id: 1,
      title: 'Administrative Law',
      explanation: 'The area of law that concerns government agencies.'),
  LegalTerm(
      id: 2,
      title: 'Demurrer',
      subtitle: 'dee-muhr-ur',
      explanation:
          'A formal response to a complaint filed in a lawsuit, pleading '
          'for dismissal and saying, in effect, that even if the facts are true, '
          'there is no legal basis for a lawsuit. Examples include a missing '
          'necessary element of fact, or a complaint that is unclear. The judge '
          'can agree and “leave to amend,” giving the claimant the opportunity to '
          'amend the complaint. If it is not amended to the judge’s satisfaction, '
          'the demurrer is granted. (Some states use a motion to dismiss.)')
];
