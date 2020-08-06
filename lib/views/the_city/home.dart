import 'package:flutter/material.dart';

import '../../models/the_city/case.dart';
import '../../models/the_city/law_firm.dart';
import '../../models/the_city/legal_term.dart';

class TheCityHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var section in _theCitySections) ...section.build(context)
      ],
    );
  }
}

class TheCitySection<I> {
  final String title;
  final List<I> items;
  final Widget Function(BuildContext, I) buildItem;
  final double itemHeight;

  TheCitySection(
      {@required this.title,
      @required this.items,
      @required this.buildItem,
      @required this.itemHeight});

  List<Widget> build(BuildContext context) => [
        ListTile(
          title: Text(title, style: Theme.of(context).textTheme.headline2),
        ),
        Container(
          height: itemHeight,
          child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [for (Object item in items) buildItem(context, item)]),
        )
      ];
}

final _theCitySections = <TheCitySection<dynamic>>[
  TheCitySection<LawFirm>(
      title: 'Firms',
      items: lawFirms,
      buildItem: (_, firm) => Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            width: 80,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(firm.logoUrl),
                    radius: 40,
                  ),
                ),
                Text(
                  firm.name,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )),
      itemHeight: 140),
  TheCitySection<LegalTerm>(
      title: 'Terminology',
      items: legalTerms,
      buildItem: (context, term) => Container(
          width: 300,
          child: Card(
              child: InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(term.title,
                            style: Theme.of(context).textTheme.headline6),
                      ),
                      ...(term.subtitle == null
                          ? []
                          : [
                              Text(
                                '(${term.subtitle})',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(fontStyle: FontStyle.italic),
                              )
                            ]),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        term.explanation,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ))),
      itemHeight: 150),
  TheCitySection<Case>(
      title: 'Cases',
      items: cases,
      buildItem: (context, _case) => Container(
            width: 300,
            child: Card(
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text('${_case.claimant} v ${_case.defendant}',
                              style: Theme.of(context).textTheme.headline6),
                        ),
                      ),
                      Text(
                          '[${_case.decidedOn.year}] ${_case.court} ${_case.number}',
                          style: Theme.of(context).textTheme.caption)
                    ],
                  ),
                ),
              ),
            ),
          ),
      itemHeight: 150)
];
